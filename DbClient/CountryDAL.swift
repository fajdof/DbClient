//
//  CountryDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class CountryDAL: DALType, BLLConvertible {
    
    var iso3: String?
    var name: String?
    var mark: String?
    var code: Int?
    var places: [Place] = []
    
    init(countryBLL: Country) {
        iso3 = countryBLL.iso3
        name = countryBLL.name
        mark = countryBLL.mark
        code = countryBLL.code
        places = countryBLL.places
    }
    
    func toBLL() -> BLLType {
        return Country(countryDAL: self)
    }
    
}
