//
//  UnitDALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class UnitDALProvider: DALProvider {
    
    func updateUnit(unit: UnitDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Unit.rawValue + set
        query = query + "JedCijArtikla = \(unit.itemPrice ?? 0)"
        if let itemQuantity = unit.itemQuantity {
            query = query + colon + "KolArtikla = \(itemQuantity)"
        }
        if let discount = unit.discount {
            query = query + colon + "PostoRabat = \(discount)"
        }
        query = query + whereClause + "IdStavke = '\(unit.unitId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func deleteUnit(unit: UnitDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Unit.rawValue
        query = query + whereClause + "IdStavke = '\(unit.unitId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
}
