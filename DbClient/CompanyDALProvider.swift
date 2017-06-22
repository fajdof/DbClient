//
//  CompanyDALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class CompanyDALProvider: DALProvider {
    
    func updateCompany(company: CompanyDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Partner.rawValue + set
        query = query + "OIB = '\(company.oib!)'"
        query = query + colon + "AdrIsporuke = '\(company.shipmentAddress!)'"
        query = query + colon + "AdrPartnera = '\(company.partnerAddress!)'"
        query = query + whereClause + "IdPartnera = '\(company.companyId!)'; "
        
        query = query + update + Tables.Company.rawValue + set
        query = query + "NazivTvrtke = '\(company.name!)'"
        if let registryNumber = company.registryNumber {
            query = query + colon + "MatBrTvrtke = '\(registryNumber)'"
        }
        query = query + whereClause + "IdTvrtke = '\(company.companyId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func addCompany(company: CompanyDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = "SET IDENTITY_INSERT Partner ON; "
        query = query + insert + Tables.Partner.rawValue + " (IdPartnera, TipPartnera, OIB, AdrIsporuke, AdrPartnera)" + values
        query = query + "(" + "\(company.companyId ?? 0)"
        query = query + colon + "'\(company.type ?? "")'"
        query = query + colon + "'\(company.oib ?? "")'"
        query = query + colon + "'\(company.shipmentAddress ?? "")'"
        query = query + colon + "'\(company.partnerAddress ?? "")'" + "); "
        query = query + "SET IDENTITY_INSERT Partner OFF; "
        
        query = query + insert + Tables.Company.rawValue + " (IdTvrtke, NazivTvrtke, MatBrTvrtke)" + values
        query = query + "(" + "\(company.companyId ?? 0)"
        query = query + colon + "'\(company.name ?? "")'"
        query = query + colon + "'\(company.registryNumber ?? "")'" + "); "
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func deleteCompany(company: CompanyDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Company.rawValue
        query = query + whereClause + "IdTvrtke = '\(company.companyId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
}
