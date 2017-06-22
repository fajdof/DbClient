//
//  UnitDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class UnitDAL: DALType {
    
    var docId: Int?
    var unitId: Int?
    var itemPrice: Double?
    var itemQuantity: Double?
    var discount: Double?
    var itemCode: Int?
    var item: Item?
    var document: Document?
    
    init(unitBLL: Unit) {
        docId = unitBLL.docId
        unitId = unitBLL.unitId
        itemPrice = unitBLL.itemPrice
        itemQuantity = unitBLL.itemQuantity
        discount = unitBLL.discount
        itemCode = unitBLL.itemCode
        item = unitBLL.item
        document = unitBLL.document
    }
    
}
