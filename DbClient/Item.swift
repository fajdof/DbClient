//
//  Item.swift
//  DbClient
//
//  Created by Filip Fajdetic on 06/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Item: Mappable {
	
	struct Attributes {
		static let price = "Cijena: "
		static let unit = "Jedinica mjere: "
		static let name = "Naziv: "
		static let code = "Šifra: "
		static let text = "Tekst: "
		static let secU = "ZaštUsluga: "
	}
	
	var price: String?
	var unit: String?
	var name: String?
	var code: String?
	var image: NSImage?
	var text: String?
	var secU: String?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		price <- map["CijArtikla"]
		unit <- map["JedMjere"]
		text <- map["TekstArtikla"]
		name <- map["NazArtikla"]
		code <- map["SifArtikla"]
		secU <- map["ZastUsluga"]
		image <- map["SlikaArtikla"]
	}
	
}
