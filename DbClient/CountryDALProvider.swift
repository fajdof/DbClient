//
//  CountryDALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class CountryDALProvider: DALProvider {
    
    func updateCountry(country: CountryDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
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
    
    
    func addCountry(country: CountryDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
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
    
    func addPlaceToCountry(place: PlaceDAL, countryMark: String?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = insert + Tables.Place.rawValue + " (NazMjesta, OznDrzave, PostBrMjesta, PostNazMjesta)" + values
        query = query + "(" + "'\(place.name ?? "")'"
        query = query + colon + "'\(countryMark ?? "")'"
        query = query + colon + "\(place.postalCode ?? 0)"
        query = query + colon + "'\(place.postalName ?? "")'" + ")"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }

    
}
