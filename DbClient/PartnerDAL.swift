//
//  PartnerDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

func == (lhs: PartnerDAL, rhs: PartnerDAL) -> Bool {
    return lhs.partnerId == rhs.partnerId
}


class PartnerDAL: DALType, BLLConvertible, Mappable, Hashable {
    
    var shipmentAddress: String?
    var partnerAddress: String?
    var shipmentAddressId: Int?
    var partnerAddressId: Int?
    var partnerId: Int?
    var oib: String?
    var type: String?
    var shipmentPlace: PlaceDAL?
    var partnerPlace: PlaceDAL?
    var docs: [DocumentDAL] = []
    
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
    
    init(partnerBLL: Partner) {
        shipmentAddress = partnerBLL.shipmentAddress
        partnerAddress = partnerBLL.partnerAddress
        shipmentAddressId = partnerBLL.shipmentAddressId
        partnerAddressId = partnerBLL.partnerAddressId
        partnerId = partnerBLL.partnerId
        oib = partnerBLL.oib
        type = partnerBLL.type
        if let bllShipmentPlace = partnerBLL.shipmentPlace {
            shipmentPlace = PlaceDAL(placeBLL: bllShipmentPlace)
        }
        if let bllPartnerPlace = partnerBLL.partnerPlace {
            partnerPlace = PlaceDAL(placeBLL: bllPartnerPlace)
        }
        docs = partnerBLL.docs.map({ (doc) -> DocumentDAL in
            return DocumentDAL(docBLL: doc)
        })
    }
    
    func toBLL() -> BLLType {
        return Partner(partnerDAL: self)
    }
    
    var hashValue: Int {
        return partnerId!
    }
    
}
