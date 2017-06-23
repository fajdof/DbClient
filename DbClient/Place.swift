//
//  Place.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Place: Mappable, Validateable, DALConvertible, BLLType {
	
	struct Attributes {
		static let name = "Naziv: "
		static let id = "Id: "
		static let countryCode = "Oznaka države: "
		static let postalCode = "Poštanski broj: "
		static let postalName = "Poštanski naziv: "
	}
	
	var name: String?
	var id: Int?
	var countryCode: String?
	var postalCode: Int?
	var postalName: String?
	var country: Country?
	var partners: Set<Partner> = []
	
	required init?(map: Map) {
		
	}
    
    init(placeDAL: PlaceDAL) {
        name = placeDAL.name
        id = placeDAL.id
        countryCode = placeDAL.countryCode
        postalCode = placeDAL.postalCode
        postalName = placeDAL.postalName
        if let dalCountry = placeDAL.country {
            country = Country(countryDAL: dalCountry)
        }
        partners = Set<Partner>(placeDAL.partners.map({ (partner) -> Partner in
            return Partner(partnerDAL: partner)
        }))
    }
	
	func mapping(map: Map) {
		name <- map["NazMjesta"]
		id <- map["IdMjesta"]
		countryCode <- map["OznDrzave"]
		postalCode <- map["PostBrMjesta"]
		postalName <- map["PostNazMjesta"]
	}
    
    func validateWithError() -> (Bool, String?) {
        return (true,nil)
    }
    
    func toDAL() -> DALType {
        return PlaceDAL(placeBLL: self)
    }
    
}
