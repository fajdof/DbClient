//
//  Unit.swift
//  DbClient
//
//  Created by Filip Fajdetic on 18/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Unit: Mappable, Validateable, DALConvertible, BLLType {
	
	struct Attributes {
		static let docId = "Id dokumenta: "
		static let unitId = "Id stavke: "
		static let itemPrice = "Jedinična cijena artikla: "
		static let itemQuantity = "Količina artikla: "
		static let discount = "Postotak rabata: "
		static let itemCode = "Šifra artikla: "
	}
	
	var docId: Int?
	var unitId: Int?
	var itemPrice: Double?
	var itemQuantity: Double?
	var discount: Double?
	var itemCode: Int?
	var item: Item?
	var document: Document?
	
	required init?(map: Map) {
		
	}
    
    init(unitDAL: UnitDAL) {
        docId = unitDAL.docId
        unitId = unitDAL.unitId
        itemPrice = unitDAL.itemPrice
        itemQuantity = unitDAL.itemQuantity
        discount = unitDAL.discount
        itemCode = unitDAL.itemCode
        if let dalItem = unitDAL.item {
            item = Item(itemDAL: dalItem)
        }
        if let dalDocument = unitDAL.document {
            document = Document(docDAL: dalDocument)
        }
    }
	
	func mapping(map: Map) {
		docId <- map["IdDokumenta"]
		unitId <- map["IdStavke"]
		itemPrice <- map["JedCijArtikla"]
		itemQuantity <- map["KolArtikla"]
		discount <- map["PostoRabat"]
		itemCode <- map["SifArtikla"]
	}
    
    func validateWithError() -> (Bool, String?) {
        return (true,nil)
    }
    
    func toDAL() -> DALType {
        return UnitDAL(unitBLL: self)
    }
    
}
