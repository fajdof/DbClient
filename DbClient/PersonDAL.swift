//
//  PersonDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class PersonDAL: PartnerDAL {
    
    var firstName: String?
    var id: Int?
    var lastName: String?
    
    init(personBLL: Person) {
        super.init(partnerBLL: personBLL)
        id = personBLL.id
        firstName = personBLL.firstName
        lastName = personBLL.lastName
    }
    
    override func toBLL() -> BLLType {
        return Person(personDAL: self)
    }

}
