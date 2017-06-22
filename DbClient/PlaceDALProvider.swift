//
//  PlaceDALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class PlaceDALProvider: DALProvider {
    
    func updatePlace(place: PlaceDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Place.rawValue + set
        query = query + "NazMjesta = '\(place.name!)'"
        if let postalCode = place.postalCode {
            query = query + colon + "PostBrMjesta = \(postalCode)"
        }
        query = query + colon + "PostNazMjesta = '\(place.postalName!)'"
        query = query + whereClause + "IdMjesta = '\(place.id!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
}
