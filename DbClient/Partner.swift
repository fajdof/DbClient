//
//  Partner.swift
//  DbClient
//
//  Created by Filip Fajdetic on 18/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Partner: Mappable {
	
	struct Attributes {
		static let shipmentAddress = "Adresa isporuke: "
		static let partnerAddress = "Adresa partnera: "
		static let shipmentAddressId = "Id mjesta isporuke: "
		static let partnerAddressId = "Id mjesta partnera: "
		static let partnerId = "Id partnera: "
		static let oib = "OIB: "
		static let type = "Tip partnera: "
	}
	
	var shipmentAddress: String?
	var partnerAddress: String?
	var shipmentAddressId: Int?
	var partnerAddressId: Int?
	var partnerId: Int?
	var oib: String?
	var type: String?
	var shipmentPlace: Place?
	var partnerPlace: Place?
	var docs: [Document] = []
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		shipmentAddress <- map["AdrIsporuke"]
		partnerAddress <- map["AdrPartnera"]
		shipmentAddressId <- map["IdMjestaIsporuke"]
		partnerAddressId <- map["IdMjestaPartnera"]
		partnerId <- map["IdPartnera"]
		oib <- map["OIB"]
		type <- map["TipPartnera"]
	}
}
