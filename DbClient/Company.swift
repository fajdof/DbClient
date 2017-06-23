//
//  Company.swift
//  DbClient
//
//  Created by Filip Fajdetic on 18/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import ObjectMapper

class Company: Partner {
	
	struct CompanyAttributes {
		static let companyId = "Id tvrtke: "
		static let registryNumber = "Matični broj tvrtke: "
		static let name = "Naziv tvrtke: "
	}
	
	var companyId: Int?
	var registryNumber: String?
	var name: String?
    
    init(companyDAL: CompanyDAL) {
        super.init(partnerDAL: companyDAL)
        companyId = companyDAL.companyId
        registryNumber = companyDAL.registryNumber
        name = companyDAL.name
    }
    
    required init?(map: Map) {
        super.init(map: map)
    }
	
	override func mapping(map: Map) {
		companyId <- map["IdTvrtke"]
		registryNumber <- map["MatBrTvrtke"]
		name <- map["NazivTvrtke"]
	}
    
    override func validateWithError() -> (Bool, String?) {
        return (true,nil)
    }
    
    override func toDAL() -> DALType {
        return CompanyDAL(companyBLL: self)
    }
    
}
