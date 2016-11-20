//
//  Country.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Country: Mappable {
	
	struct Attributes {
		static let iso3 = "ISO3: "
		static let name = "Naziv: "
		static let mark = "Oznaka: "
		static let code = "Šifra: "
	}
	
	var iso3: String?
	var name: String?
	var mark: String?
	var code: Int?
	var places: [Place] = []
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		iso3 <- map["ISO3Drzave"]
		name <- map["NazDrzave"]
		mark <- map["OznDrzave"]
		code <- map["SifDrzave"]
	}
}
