//
//  UnitReqValidator.swift
//  DbClient
//
//  Created by Filip Fajdetic on 12/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class UnitReqValidator: Requiredable {
    
    var unit: Unit
    
    init(unit: Unit) {
        self.unit = unit
    }
    
    func requirementFulfilled() -> Bool {
        
        guard unit.discount == nil || unit.itemPrice == nil || unit.itemQuantity == nil else {
            return true
        }
        
        return false
    }
    
}
