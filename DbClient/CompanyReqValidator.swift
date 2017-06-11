//
//  CompanyReqValidator.swift
//  DbClient
//
//  Created by Filip Fajdetic on 10/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class CompanyReqValidator: Requiredable {
    
    var company: Company
    
    init(company: Company) {
        self.company = company
    }
    
    func requirementFulfilled() -> Bool {
        guard let registryNumber = company.registryNumber, let name = company.name, let oib = company.oib else { return false }
        
        guard registryNumber.isEmpty, name.isEmpty, oib.isEmpty else {
            return true
        }
        
        return false
    }
    
}
