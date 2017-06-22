//
//  Item.swift
//  DbClient
//
//  Created by Filip Fajdetic on 06/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Item: Mappable, Validateable, DALConvertible {
	
	struct Attributes {
		static let price = "Cijena: "
		static let measUnit = "Jedinica mjere: "
		static let name = "Naziv: "
		static let code = "Šifra: "
		static let text = "Tekst: "
		static let secU = "Zaštitna usluga: "
	}
	
	var price: Double?
	var measUnit: String?
	var name: String?
	var code: Int?
	var image: Data?
	var text: String?
	var secU: NSNumber?
	var units: [Unit] = []
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		price <- map["CijArtikla"]
		measUnit <- map["JedMjere"]
		text <- map["TekstArtikla"]
		name <- map["NazArtikla"]
		code <- map["SifArtikla"]
		secU <- map["ZastUsluga"]
		image <- map["SlikaArtikla"]
	}
    
    func validateWithError() -> (Bool, String?) {
        if price == nil {
            return (false, "Cijena mora biti decimalni broj")
        }
        
        guard let mUnit = measUnit else {
            return (false, "Jedinica mjere ne može biti prazna")
        }
        
        if mUnit.characters.count > 10 {
            return (false, "Jedinica mjere može sadržavati maksimalno 10 znakova")
        }
        
        guard let `name` = name else {
            return (false, "Naziv ne može biti prazan")
        }
        
        if name.characters.count > 30 {
            return (false, "Naziv može sadržavati maksimalno 30 znakova")
        }
        
        return (true,nil)
    }
    
    func toDAL() -> DALType {
        return ItemDAL(itemBLL: self)
    }
	
}
