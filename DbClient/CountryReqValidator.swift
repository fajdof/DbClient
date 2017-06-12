//
//  CountryReqValidator.swift
//  DbClient
//
//  Created by Filip Fajdetic on 12/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class CountryReqValidator: Requiredable {
    
    var country: Country
    
    init(country: Country) {
        self.country = country
    }
    
    func requirementFulfilled() -> Bool {
        guard let name = country.name, let iso3 = country.iso3 else {
            return false
        }
        
        guard name.isEmpty || iso3.isEmpty || country.code == nil else {
            guard let mark = country.mark else {
                return true
            }
            
            return !mark.isEmpty
        }
        
        return false
    }
}
