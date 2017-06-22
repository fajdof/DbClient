//
//  PersonDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class PersonDAL: PartnerDAL {
    
    var firstName: String?
    var id: Int?
    var lastName: String?
    
    required init?(map: Map) {
        fatalError("init(map:) has not been implemented")
    }
    
    override func mapping(map: Map) {
        firstName <- map["ImeOsobe"]
        id <- map["IdOsobe"]
        lastName <- map["PrezimeOsobe"]
    }
    
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
