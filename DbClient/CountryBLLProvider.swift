//
//  CountryBLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class CountryBLLProvider {
    
    let dalProvider = CountryDALProvider()
    
    func updateCountry(country: Country, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.updateCountry(country: country.toDAL() as! CountryDAL, completion: completion)
    }
    
    func addCountry(country: Country, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addCountry(country: country.toDAL() as! CountryDAL, completion: completion)
    }
    
    func addPlaceToCountry(place: Place, countryMark: String?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addPlaceToCountry(place: place.toDAL() as! PlaceDAL, countryMark: countryMark, completion: completion)
    }
    
    func deleteCountry(country: Country, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.deleteCountry(country: country.toDAL() as! CountryDAL, completion: completion)
    }
    
}
