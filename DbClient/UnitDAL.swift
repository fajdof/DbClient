//
//  UnitDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class UnitDAL: DALType, BLLConvertible, Mappable {
    
    var docId: Int?
    var unitId: Int?
    var itemPrice: Double?
    var itemQuantity: Double?
    var discount: Double?
    var itemCode: Int?
    var item: ItemDAL?
    var document: DocumentDAL?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        docId <- map["IdDokumenta"]
        unitId <- map["IdStavke"]
        itemPrice <- map["JedCijArtikla"]
        itemQuantity <- map["KolArtikla"]
        discount <- map["PostoRabat"]
        itemCode <- map["SifArtikla"]
    }
    
    init(unitBLL: Unit) {
        docId = unitBLL.docId
        unitId = unitBLL.unitId
        itemPrice = unitBLL.itemPrice
        itemQuantity = unitBLL.itemQuantity
        discount = unitBLL.discount
        itemCode = unitBLL.itemCode
        if let bllItem = unitBLL.item {
            item = ItemDAL(itemBLL: bllItem)
        }
        if let bllDocument = unitBLL.document {
            document = DocumentDAL(docBLL: bllDocument)
        }
    }
    
    func toBLL() -> BLLType {
        return Unit(unitDAL: self)
    }
    
}
