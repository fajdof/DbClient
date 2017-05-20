//
//  DbTableViewModel.swift
//  DbClient
//
//  Created by Filip Fajdetic on 20/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class EditViewModel {
    
    let update = "UPDATE "
    let set = " SET "
    let whereClause = " WHERE "
    
    var client: SQLClient?
    
    init() {
        client = SQLClient.sharedInstance()
    }
    
    func updateItem(item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Item.rawValue + set
        query = query + "NazArtikla = '\(item.name!)'" + ", "
        query = query + "CijArtikla = \(item.price!)"
        query = query + whereClause + "SifArtikla = '\(item.code!)'"
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    
}
