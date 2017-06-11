//
//  PersonReqValidator.swift
//  DbClient
//
//  Created by Filip Fajdetic on 10/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class PersonReqValidator: Requiredable {
    
    var person: Person
    
    init(person: Person) {
        self.person = person
    }
    
    func requirementFulfilled() -> Bool {
        guard let firstName = person.firstName, let lastName = person.lastName, let oib = person.oib else { return false }
        
        guard firstName.isEmpty, lastName.isEmpty, oib.isEmpty else {
            return true
        }
        
        return false
    }
    
}
