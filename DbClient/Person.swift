//
//  Person.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Person: Partner {
	
	struct PersonAttributes {
		static let firstName = "Ime: "
		static let id = "Id: "
		static let lastName = "Prezime: "
	}
	
	var firstName: String?
	var id: Int?
	var lastName: String?
	
	override func mapping(map: Map) {
		firstName <- map["ImeOsobe"]
		id <- map["IdOsobe"]
		lastName <- map["PrezimeOsobe"]
	}
    
    override func validateWithError() -> (Bool, String?) {
        return (true,nil)
    }
    
    override func toDAL() -> DALType {
        return PersonDAL(personBLL: self)
    }
    
}
