//
//  DatabaseProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class DatabaseProvider {
    
    let hostName = "rppp.fer.hr:3000"
    let username = "rppp"
    let password = "r3p##2011"
    let dbName = "Firma"
    let selectQuery = "SELECT * FROM "
    
    var items: [ItemDAL] = []
    var docs: [DocumentDAL] = []
    var countries: [CountryDAL] = []
    var places: [PlaceDAL] = []
    var people: [PersonDAL] = []
    var partners: [PartnerDAL] = []
    var units: [UnitDAL] = []
    var companies: [CompanyDAL] = []
    
    var idsToItems: [Int: ItemDAL] = [:]
    var idsToCountries: [String: CountryDAL] = [:]
    var idsToPlaces: [Int: PlaceDAL] = [:]
    var idsToDocs: [Int: DocumentDAL] = [:]
    var idsToPartners: [Int: PartnerDAL] = [:]
    var idsToCompanies: [Int: CompanyDAL] = [:]
    var idsToPeople: [Int: PersonDAL] = [:]
    
    var client: SQLClient?
    
    init() {
        client = SQLClient.sharedInstance()
    }
    
    
    func connectToSqlServer(completion: @escaping (_ completed: Bool) -> ()) {
        
        client?.connect(hostName, username: username, password: password, database: dbName, completion: { (completed) in
            
            completion(completed)
        })
    }
    
    
    func executeQuery(table: Tables,  completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        client?.execute(selectQuery + table.rawValue, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    
    func proccessQuery(data: [Any], type: Tables) {
        for table in data {
            if let tab = table as? Array<Dictionary<String, AnyObject>> {
                for row in tab {
                    parseRow(row: row, type: type)
                }
            }
        }
    }
    
    
    func parseRow(row: Dictionary<String, AnyObject>, type: Tables) {
        switch type {
        case .Item:
            if let item = ItemDAL(JSON: row) {
                items.append(item)
                if let code = item.code {
                    idsToItems[code] = item
                }
            }
        case .Document:
            if let doc = DocumentDAL(JSON: row) {
                docs.append(doc)
                if let docId = doc.docId {
                    idsToDocs[docId] = doc
                }
            }
        case .Country:
            if let country = CountryDAL(JSON: row) {
                countries.append(country)
                if let mark = country.mark {
                    idsToCountries[mark] = country
                }
            }
        case .Place:
            if let place = PlaceDAL(JSON: row) {
                places.append(place)
                if let id = place.id {
                    idsToPlaces[id] = place
                }
            }
        case .Person:
            if let person = PersonDAL(JSON: row) {
                people.append(person)
                if let id = person.id {
                    idsToPeople[id] = person
                }
            }
        case .Partner:
            if let partner = PartnerDAL(JSON: row) {
                partners.append(partner)
                if let partnerId = partner.partnerId {
                    idsToPartners[partnerId] = partner
                }
            }
        case .Unit:
            if let unit = UnitDAL(JSON: row) {
                units.append(unit)
            }
        case .Company:
            if let company = CompanyDAL(JSON: row) {
                companies.append(company)
                if let id = company.companyId {
                    idsToCompanies[id] = company
                }
            }
        }
    }
    
    
    func connectUnitsWithItemsAndDocs(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for unit in self.units {
                if let itemCode = unit.itemCode {
                    let item = self.idsToItems[itemCode]
                    unit.item = item
                    item?.units.append(unit)
                }
                
                if let docId = unit.docId {
                    let doc = self.idsToDocs[docId]
                    unit.document = doc
                    doc?.units.append(unit)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func connectCountriesAndPlaces(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for place in self.places {
                if let countryCode = place.countryCode {
                    let country = self.idsToCountries[countryCode]
                    place.country = country
                    country?.places.append(place)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func connectPlacesAndPartners(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for partner in self.partners {
                if let partnerAddressId = partner.partnerAddressId {
                    let partnerPlace = self.idsToPlaces[partnerAddressId]
                    partner.partnerPlace = partnerPlace
                    partnerPlace?.partners.insert(partner)
                }
                if let shipmentAddressId = partner.shipmentAddressId {
                    let shipmentPlace = self.idsToPlaces[shipmentAddressId]
                    partner.shipmentPlace = shipmentPlace
                    shipmentPlace?.partners.insert(partner)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func connectDocsWithPartnersAndPreviousDocs(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for doc in self.docs {
                if let partnerId = doc.partnerId {
                    let partner = self.idsToPartners[partnerId]
                    if let company = self.idsToCompanies[partnerId] {
                        doc.partner = company
                    }
                    if let person = self.idsToPeople[partnerId] {
                        doc.partner = person
                    }
                    partner?.docs.append(doc)
                }
                
                if let docBeforeId = doc.docBeforeId {
                    let docBefore = self.idsToDocs[docBeforeId]
                    doc.docBefore = docBefore
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func addPartnerPropertiesToPerson(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for person in self.people {
                if let id = person.id {
                    if let partner = self.idsToPartners[id] {
                        self.addPartnerProperties(to: person, partnerOrigin: partner)
                    }
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func addPartnerPropertiesToCompany(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for company in self.companies {
                if let id = company.companyId {
                    if let partner = self.idsToPartners[id] {
                        self.addPartnerProperties(to: company, partnerOrigin: partner)
                    }
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func addPartnerProperties(to partnerObject: PartnerDAL, partnerOrigin: PartnerDAL) {
        partnerObject.oib = partnerOrigin.oib
        partnerObject.docs = partnerOrigin.docs
        partnerObject.partnerAddress = partnerOrigin.partnerAddress
        partnerObject.partnerAddressId = partnerOrigin.partnerAddressId
        partnerObject.shipmentAddress = partnerOrigin.shipmentAddress
        partnerObject.shipmentAddressId = partnerOrigin.shipmentAddressId
        partnerObject.shipmentPlace = partnerOrigin.shipmentPlace
        partnerObject.partnerPlace = partnerOrigin.partnerPlace
        partnerObject.type = partnerOrigin.type
    }
    
    func clearData() {
        items = []
        companies = []
        countries = []
        docs = []
        units = []
        places = []
        people = []
        partners = []
        idsToCompanies = [:]
        idsToDocs = [:]
        idsToItems = [:]
        idsToPeople = [:]
        idsToPlaces = [:]
        idsToPartners = [:]
        idsToCountries = [:]
    }
    
}
