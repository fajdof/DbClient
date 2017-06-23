//
//  DALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class DALProvider {
    
    let update = "UPDATE "
    let set = " SET "
    let whereClause = " WHERE "
    let colon = ", "
    let insert = "INSERT INTO "
    let values = " VALUES "
    let deleteFrom = "DELETE FROM "
    
    var client: SQLClient?
    var databaseProvider: DatabaseProvider!
    
    init() {
        client = SQLClient.sharedInstance()
        databaseProvider = DatabaseProvider()
    }
    
    func connectToSqlServer(completion: @escaping (_ completed: Bool) -> ()) {
        databaseProvider.connectToSqlServer(completion: completion)
    }
    
    func executeQuery(table: Tables,  completion: @escaping (_ dbData: [Any]?) -> ()) {
        databaseProvider.executeQuery(table: table, completion: completion)
    }
    
    func proccessQuery(data: [Any], type: Tables) {
        databaseProvider.proccessQuery(data: data, type: type)
    }
    
    func connectUnitsWithItemsAndDocs(completion: @escaping () -> ()) {
        databaseProvider.connectUnitsWithItemsAndDocs(completion: completion)
    }
    
    func connectCountriesAndPlaces(completion: @escaping () -> ()) {
        databaseProvider.connectCountriesAndPlaces(completion: completion)
    }
    
    func connectPlacesAndPartners(completion: @escaping () -> ()) {
        databaseProvider.connectPlacesAndPartners(completion: completion)
    }
    
    func connectDocsWithPartnersAndPreviousDocs(completion: @escaping () -> ()) {
        databaseProvider.connectDocsWithPartnersAndPreviousDocs(completion: completion)
    }
    
    func addPartnerPropertiesToPerson(completion: @escaping () -> ()) {
        databaseProvider.addPartnerPropertiesToPerson(completion: completion)
    }
    
    func addPartnerPropertiesToCompany(completion: @escaping () -> ()) {
        databaseProvider.addPartnerPropertiesToCompany(completion: completion)
    }
    
    func getItems() -> [Item] {
        return databaseProvider.items.map({ (itemDAL) -> Item in
            return Item(itemDAL: itemDAL)
        })
    }
    
    func getDocs() -> [Document] {
        return databaseProvider.docs.map({ (docDAL) -> Document in
            return Document(docDAL: docDAL)
        })
    }
    
    func getPartners() -> [Partner] {
        return databaseProvider.partners.map({ (partnerDAL) -> Partner in
            return Partner(partnerDAL: partnerDAL)
        })
    }
    
    func getUnits() -> [Unit] {
        return databaseProvider.units.map({ (unitDAL) -> Unit in
            return Unit(unitDAL: unitDAL)
        })
    }
    
    func getPeople() -> [Person] {
        return databaseProvider.people.map({ (personDAL) -> Person in
            return Person(personDAL: personDAL)
        })
    }
    
    func getCompanies() -> [Company] {
        return databaseProvider.companies.map({ (companyDAL) -> Company in
            return Company(companyDAL: companyDAL)
        })
    }
    
    func getPlaces() -> [Place] {
        return databaseProvider.places.map({ (placeDAL) -> Place in
            return Place(placeDAL: placeDAL)
        })
    }
    
    func getCountries() -> [Country] {
        return databaseProvider.countries.map({ (countryDAL) -> Country in
            return Country(countryDAL: countryDAL)
        })
    }
    
    func clearDatabaseProvider() {
        databaseProvider.clearData()
    }
    
}
