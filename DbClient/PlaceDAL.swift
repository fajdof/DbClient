//
//  PlaceDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class PlaceDAL: DALType, BLLConvertible, Mappable {
    
    var name: String?
    var id: Int?
    var countryCode: String?
    var postalCode: Int?
    var postalName: String?
    var country: CountryDAL?
    var partners: Set<PartnerDAL> = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        name <- map["NazMjesta"]
        id <- map["IdMjesta"]
        countryCode <- map["OznDrzave"]
        postalCode <- map["PostBrMjesta"]
        postalName <- map["PostNazMjesta"]
    }
    
    init(placeBLL: Place) {
        name = placeBLL.name
        id = placeBLL.id
        countryCode = placeBLL.countryCode
        postalCode = placeBLL.postalCode
        postalName = placeBLL.postalName
        if let bllCountry = placeBLL.country {
            country = CountryDAL(countryBLL: bllCountry)
        }
        partners = Set<PartnerDAL>(placeBLL.partners.map({ (partner) -> PartnerDAL in
            return PartnerDAL(partnerBLL: partner)
        }))
    }
    
    func toBLL() -> BLLType {
        return Place(placeDAL: self)
    }
    
}
