//
//  Person.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Person: Mappable {
	
	struct Attributes {
		static let firstName = "Ime: "
		static let id = "Id: "
		static let lastName = "Prezime: "
	}
	
	var firstName: String?
	var id: Int?
	var lastName: String?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		firstName <- map["ImeOsobe"]
		id <- map["IdOsobe"]
		lastName <- map["PrezimeOsobe"]
	}
}
