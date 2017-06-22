//
//  DocumentDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class DocumentDAL: DALType, BLLConvertible {
    
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
    
    init(docBLL: Document) {
        docNumber = docBLL.docNumber
        docDate = docBLL.docDate
        docId = docBLL.docId
        partnerId = docBLL.partnerId
        docBeforeId = docBLL.docBeforeId
        docValue = docBLL.docValue
        tax = docBLL.tax
        docVr = docBLL.docVr
        units = docBLL.units
        partner = docBLL.partner
        docBefore = docBLL.docBefore
    }
    
    func toBLL() -> BLLType {
        return Document(docDAL: self)
    }
    
}
