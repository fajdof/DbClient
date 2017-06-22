//
//  PlaceDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

import ObjectMapper

class PlaceDAL: DALType {
    
    var name: String?
    var id: Int?
    var countryCode: String?
    var postalCode: Int?
    var postalName: String?
    var country: Country?
    var partners: Set<Partner> = []
    
    init(placeBLL: Place) {
        name = placeBLL.name
        id = placeBLL.id
        countryCode = placeBLL.countryCode
        postalCode = placeBLL.postalCode
        postalName = placeBLL.postalName
        country = placeBLL.country
        partners = placeBLL.partners
    }
    
}
