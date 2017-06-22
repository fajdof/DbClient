//
//  CompanyBLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class CompanyBLLProvider {
    
    let dalProvider = CompanyDALProvider()
    
    func updateCompany(company: Company, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.updateCompany(company: company.toDAL() as! CompanyDAL, completion: completion)
    }
    
    func addCompany(company: Company, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addCompany(company: company.toDAL() as! CompanyDAL, completion: completion)
    }
    
}
