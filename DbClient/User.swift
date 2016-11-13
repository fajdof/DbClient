//
//  User.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class User: Mappable {
	
	struct Attributes {
		static let username = "Lozinka: "
		static let password = "Korisničko ime: "
	}
	
	var username: String?
	var password: String?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		username <- map["Username"]
		password <- map["Password"]
	}
}
