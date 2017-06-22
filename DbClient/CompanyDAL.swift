//
//  CompanyDAL.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class CompanyDAL: PartnerDAL {
    
    var companyId: Int?
    var registryNumber: String?
    var name: String?
    
    init(companyBLL: Company) {
        super.init(partnerBLL: companyBLL)
        companyId = companyBLL.companyId
        registryNumber = companyBLL.registryNumber
        name = companyBLL.name
    }
    
    override func toBLL() -> BLLType {
        return Company(companyDAL: self)
    }
    
}
