//
//  ItemReqValidator.swift
//  DbClient
//
//  Created by Filip Fajdetic on 10/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class ItemReqValidator: Requiredable {
    
    var item: Item
    
    init(item: Item) {
        self.item = item
    }
    
    func requirementFulfilled() -> Bool {
        guard let measUnit = item.measUnit, let name = item.name else { return false }
        
        guard measUnit.isEmpty || name.isEmpty || item.price == nil || item.secU == nil else {
            return true
        }
        
        return false
    }
    
}
