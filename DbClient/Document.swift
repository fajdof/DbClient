//
//  Document.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Document: Mappable, Validateable, DALConvertible {
	
	struct Attributes {
		static let docNumber = "Broj dokumenta: "
		static let docDate = "Datum dokumenta: "
		static let docId = "Id dokumenta: "
		static let partnerId = "Id partnera: "
		static let docBeforeId = "Id prethodnog dokumenta: "
		static let docValue = "Iznos dokumenta: "
		static let tax = "Postotak poreza: "
		static let docVr = "Vrsta dokumenta: "
	}
	
	var docNumber: Int?
	var docDate: Date?
	var docId: Int?
	var partnerId: Int?
	var docBeforeId: Int?
	var docValue: Double?
	var tax: Double?
	var docVr: String?
	var units: [Unit] = []
	var partner: Partner?
	var docBefore: Document?
	
	required init?(map: Map) {
		
	}
	
	func mapping(map: Map) {
		docNumber <- map["BrDokumenta"]
		docDate <- map["DatDokumenta"]
		docId <- map["IdDokumenta"]
		partnerId <- map["IdPartnera"]
		docBeforeId <- map["IdPrethDokumenta"]
		docValue <- map["IznosDokumenta"]
		docVr <- map["VrDokumenta"]
		tax <- map["PostoPorez"]
	}
    
    func validateWithError() -> (Bool, String?) {
        return (true,nil)
    }
    
    func toDAL() -> DALType {
        return DocumentDAL(docBLL: self)
    }
}
