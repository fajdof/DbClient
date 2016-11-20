//
//  Company.swift
//  DbClient
//
//  Created by Filip Fajdetic on 18/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Company: Partner {
	
	struct Attributes {
		static let companyId = "Id tvrtke: "
		static let registryNumber = "Matični broj tvrtke: "
		static let name = "Naziv tvrtke: "
	}
	
	var companyId: Int?
	var registryNumber: String?
	var name: String?
	
	override func mapping(map: Map) {
		companyId <- map["IdTvrtke"]
		registryNumber <- map["MatBrTvrtke"]
		name <- map["NazivTvrtke"]
	}
}
