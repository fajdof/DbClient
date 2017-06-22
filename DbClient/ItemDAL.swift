//
//  ItemDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class ItemDAL: DALType {
    
    var price: Double?
    var measUnit: String?
    var name: String?
    var code: Int?
    var image: Data?
    var text: String?
    var secU: NSNumber?
    var units: [Unit] = []
    
    init(itemBLL: Item) {
        price = itemBLL.price
        measUnit = itemBLL.measUnit
        name = itemBLL.name
        code = itemBLL.code
        image = itemBLL.image
        text = itemBLL.text
        secU = itemBLL.secU
        units = itemBLL.units
    }
    
}
