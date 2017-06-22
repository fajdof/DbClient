//
//  PersonDALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class PersonDALProvider: DALProvider {
    
    func updatePerson(person: PersonDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Partner.rawValue + set
        query = query + "OIB = '\(person.oib!)'"
        query = query + colon + "AdrIsporuke = '\(person.shipmentAddress!)'"
        query = query + colon + "AdrPartnera = '\(person.partnerAddress!)'"
        query = query + whereClause + "IdPartnera = '\(person.id!)'; "
        
        query = query + update + Tables.Person.rawValue + set
        query = query + "ImeOsobe = '\(person.firstName!)'"
        query = query + colon + "PrezimeOsobe = '\(person.lastName!)'"
        query = query + whereClause + "IdOsobe = '\(person.id!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    func addPerson(person: PersonDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = "SET IDENTITY_INSERT Partner ON; "
        query = query + insert + Tables.Partner.rawValue + " (IdPartnera, TipPartnera, OIB, AdrIsporuke, AdrPartnera)" + values
        query = query + "(" + "\(person.id ?? 0)"
        query = query + colon + "'\(person.type ?? "")'"
        query = query + colon + "'\(person.oib ?? "")'"
        query = query + colon + "'\(person.shipmentAddress ?? "")'"
        query = query + colon + "'\(person.partnerAddress ?? "")'" + "); "
        query = query + "SET IDENTITY_INSERT Partner OFF; "
        
        query = query + insert + Tables.Person.rawValue + " (IdOsobe, ImeOsobe, PrezimeOsobe)" + values
        query = query + "(" + "\(person.id ?? 0)"
        query = query + colon + "'\(person.firstName ?? "")'"
        query = query + colon + "'\(person.lastName ?? "")'" + "); "
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
}
