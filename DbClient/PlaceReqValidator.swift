//
//  PlaceReqValidator.swift
//  DbClient
//
//  Created by Filip Fajdetic on 12/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class PlaceReqValidator: Requiredable {
    
    var place: Place
    
    init(place: Place) {
        self.place = place
    }
    
    func requirementFulfilled() -> Bool {
        guard let name = place.name else { return false }
        
        guard name.isEmpty || place.postalCode == nil else {
            return true
        }
        
        return false
    }
    
}
