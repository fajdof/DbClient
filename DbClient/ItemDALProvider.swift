//
//  ItemDALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class ItemDALProvider: DALProvider {
    
    func addItem() {
        
    }
    
    func updateItem(item: ItemDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Item.rawValue + set
        query = query + "NazArtikla = '\(item.name!)'"
        query = query + colon + "JedMjere = '\(item.measUnit!)'"
        query = query + colon + "TekstArtikla = '\(item.text!)'"
        if let price = item.price {
            query = query + colon + "CijArtikla = \(price)"
        }
        if let secU = item.secU {
            query = query + colon + "ZastUsluga = \(secU)"
        }
        query = query + whereClause + "SifArtikla = '\(item.code!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
}
