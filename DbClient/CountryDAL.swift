//
//  CountryDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class CountryDAL: DALType, BLLConvertible, Mappable {
    
    var iso3: String?
    var name: String?
    var mark: String?
    var code: Int?
    var places: [PlaceDAL] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        iso3 <- map["ISO3Drzave"]
        name <- map["NazDrzave"]
        mark <- map["OznDrzave"]
        code <- map["SifDrzave"]
    }
    
    init(countryBLL: Country) {
        iso3 = countryBLL.iso3
        name = countryBLL.name
        mark = countryBLL.mark
        code = countryBLL.code
        places = countryBLL.places.map({ (place) -> PlaceDAL in
            return PlaceDAL(placeBLL: place)
        })
    }
    
    func toBLL() -> BLLType {
        return Country(countryDAL: self)
    }
    
}
