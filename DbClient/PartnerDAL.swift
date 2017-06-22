//
//  PartnerDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class PartnerDAL: DALType, BLLConvertible {
    
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
    
    init(partnerBLL: Partner) {
        shipmentAddress = partnerBLL.shipmentAddress
        partnerAddress = partnerBLL.partnerAddress
        shipmentAddressId = partnerBLL.shipmentAddressId
        partnerAddressId = partnerBLL.partnerAddressId
        partnerId = partnerBLL.partnerId
        oib = partnerBLL.oib
        type = partnerBLL.type
        shipmentPlace = partnerBLL.shipmentPlace
        partnerPlace = partnerBLL.partnerPlace
        docs = partnerBLL.docs
    }
    
    func toBLL() -> BLLType {
        return Partner(partnerDAL: self)
    }
    
}
