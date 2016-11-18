//
//  Sysdiagram.swift
//  DbClient
//
//  Created by Filip Fajdetic on 18/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Sysdiagram: Mappable {
	
	struct Attributes {
		static let definition = "Definicija: "
		static let diagramId = "Id dijagrama: "
		static let name = "Naziv: "
		static let principalId = "Principal id: "
		static let version = "Verzija: "
	}
	
	var definition: Data?
	var diagramId: Int?
	var name: String?
	var principalId: Int?
	var version: Int?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		definition <- map["definition"]
		diagramId <- map["diagram_id"]
		name <- map["name"]
		principalId <- map["principal_id"]
		version <- map["version"]
	}
}
