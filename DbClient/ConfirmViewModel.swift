//
//  ConfirmViewModel.swift
//  DbClient
//
//  Created by Filip Fajdetic on 20/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class ConfirmViewModel {
    let deleteFrom = "DELETE FROM "
    let whereClause = " WHERE "
    let update = "UPDATE "
    let set = " SET "
    
    var client: SQLClient?
    
    init() {
        client = SQLClient.sharedInstance()
    }
    
    func deleteItem(item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Item.rawValue
        query = query + whereClause + "SifArtikla = '\(item.code!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func deleteCountry(country: Country, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Country.rawValue
        query = query + whereClause + "OznDrzave = '\(country.mark!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func deleteDocument(doc: Document, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Document.rawValue
        query = query + whereClause + "IdDokumenta = '\(doc.docId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func deleteUnit(unit: Unit, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Unit.rawValue
        query = query + whereClause + "IdStavke = '\(unit.unitId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func deletePlace(place: Place, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Place.rawValue
        query = query + whereClause + "IdMjesta = '\(place.id!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func deleteCompany(company: Company, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Company.rawValue
        query = query + whereClause + "IdTvrtke = '\(company.companyId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func deletePerson(person: Person, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Person.rawValue
        query = query + whereClause + "IdOsobe = '\(person.id!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func removePlaceFromPartner(shipment: Bool, partnerId: Int?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Partner.rawValue + set
        if shipment {
            query = query + "IdMjestaIsporuke = NULL"
        } else {
            query = query + "IdMjestaPartnera = NULL"
        }
        query = query + whereClause + "IdPartnera = '\(partnerId!)'; "
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
}
