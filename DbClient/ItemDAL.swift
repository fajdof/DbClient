//
//  ItemDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class ItemDAL: DALType, BLLConvertible, Mappable {
    
    var price: Double?
    var measUnit: String?
    var name: String?
    var code: Int?
    var image: Data?
    var text: String?
    var secU: NSNumber?
    var units: [UnitDAL] = []
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        price <- map["CijArtikla"]
        measUnit <- map["JedMjere"]
        text <- map["TekstArtikla"]
        name <- map["NazArtikla"]
        code <- map["SifArtikla"]
        secU <- map["ZastUsluga"]
        image <- map["SlikaArtikla"]
    }
    
    init(itemBLL: Item) {
        price = itemBLL.price
        measUnit = itemBLL.measUnit
        name = itemBLL.name
        code = itemBLL.code
        image = itemBLL.image
        text = itemBLL.text
        secU = itemBLL.secU
        units = itemBLL.units.map({ (unit) -> UnitDAL in
            return UnitDAL(unitBLL: unit)
        })
    }
    
    func toBLL() -> BLLType {
        return Item(itemDAL: self)
    }
    
}
