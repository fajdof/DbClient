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
    let colon = ", "
    
    let insert = "INSERT INTO "
    let values = " VALUES "
    
    var client: SQLClient?
    
    init() {
        client = SQLClient.sharedInstance()
    }
    
    func updateItem(item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
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
    
    
    func addItem(item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = insert + Tables.Item.rawValue + " (CijArtikla, JedMjere, NazArtikla, TekstArtikla, SifArtikla, ZastUsluga)" + values
        query = query + "(" + "\(item.price ?? 0)"
        query = query + colon + "'\(item.measUnit ?? "")'"
        query = query + colon + "'\(item.name ?? "")'"
        query = query + colon + "'\(item.text ?? "")'"
        query = query + colon + "\(item.code ?? 0)"
        query = query + colon + "\(item.secU ?? NSNumber(integerLiteral: 0))" + ")"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }

    
    func updateCountry(country: Country, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Country.rawValue + set
        query = query + "ISO3Drzave = '\(country.iso3!)'"
        query = query + colon + "NazDrzave = '\(country.name!)'"
        if let code = country.code {
            query = query + colon + "SifDrzave = \(code)"
        }
        query = query + whereClause + "OznDrzave = '\(country.mark!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    func addCountry(country: Country, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = insert + Tables.Country.rawValue + " (ISO3Drzave, NazDrzave, SifDrzave, OznDrzave)" + values
        query = query + "(" + "'\(country.iso3 ?? "")'"
        query = query + colon + "'\(country.name ?? "")'"
        query = query + colon + "\(country.code ?? 0)"
        query = query + colon + "'\(country.mark ?? "")'" + ")"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    
}
