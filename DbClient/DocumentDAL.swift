//
//  DocumentDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class DocumentDAL: DALType, BLLConvertible, Mappable {
    
    var docNumber: Int?
    var docDate: Date?
    var docId: Int?
    var partnerId: Int?
    var docBeforeId: Int?
    var docValue: Double?
    var tax: Double?
    var docVr: String?
    var units: [UnitDAL] = []
    var partner: PartnerDAL?
    var docBefore: DocumentDAL?
    
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
    
    init(docBLL: Document) {
        docNumber = docBLL.docNumber
        docDate = docBLL.docDate
        docId = docBLL.docId
        partnerId = docBLL.partnerId
        docBeforeId = docBLL.docBeforeId
        docValue = docBLL.docValue
        tax = docBLL.tax
        docVr = docBLL.docVr
        units = docBLL.units.map({ (unit) -> UnitDAL in
            return UnitDAL(unitBLL: unit)
        })
        if let bllPartner = docBLL.partner {
            partner = PartnerDAL(partnerBLL: bllPartner)
        }
        if let bllDocBefore = docBLL.docBefore {
            docBefore = DocumentDAL(docBLL: bllDocBefore)
        }
    }
    
    func toBLL() -> BLLType {
        return Document(docDAL: self)
    }
    
}
