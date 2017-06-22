//
//  DocumentDALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class DocumentDALProvider: DALProvider {
    
    func updateDocument(doc: DocumentDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Document.rawValue + set
        query = query + "VrDokumenta = '\(doc.docVr!)'"
        if let docNumber = doc.docNumber {
            query = query + colon + "BrDokumenta = \(docNumber)"
        }
        if let docDate = doc.docDate {
            let dateString = docDate.string(custom: "YYYYMMdd hh:mm:ss a")
            query = query + colon + "DatDokumenta = '\(dateString)'"
        }
        if let docValue = doc.docValue {
            query = query + colon + "IznosDokumenta = \(docValue)"
        }
        if let tax = doc.tax {
            query = query + colon + "PostoPorez = \(tax)"
        }
        query = query + whereClause + "IdDokumenta = '\(doc.docId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    func addDocument(doc: DocumentDAL, company: CompanyDAL?, person: PersonDAL?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = ""
        
        if let `person` = person {
            query = "SET IDENTITY_INSERT Partner ON; "
            query = query + insert + Tables.Partner.rawValue + " (IdPartnera, TipPartnera, OIB)" + values
            query = query + "(" + "\(person.id ?? 0)"
            query = query + colon + "'\(person.type ?? "")'"
            query = query + colon + "'\(person.oib ?? "")'" + "); "
            query = query + "SET IDENTITY_INSERT Partner OFF; "
            
            query = query + insert + Tables.Person.rawValue + " (IdOsobe, ImeOsobe, PrezimeOsobe)" + values
            query = query + "(" + "\(person.id ?? 0)"
            query = query + colon + "'\(person.firstName ?? "")'"
            query = query + colon + "'\(person.lastName ?? "")'" + "); "
        }
        
        if let `company` = company {
            query = "SET IDENTITY_INSERT Partner ON; "
            query = query + insert + Tables.Partner.rawValue + " (IdPartnera, TipPartnera, OIB)" + values
            query = query + "(" + "\(company.companyId ?? 0)"
            query = query + colon + "'\(company.type ?? "")'"
            query = query + colon + "'\(company.oib ?? "")'" + "); "
            query = query + "SET IDENTITY_INSERT Partner OFF; "
            
            query = query + insert + Tables.Company.rawValue + " (IdTvrtke, NazivTvrtke, MatBrTvrtke)" + values
            query = query + "(" + "\(company.companyId ?? 0)"
            query = query + colon + "'\(company.name ?? "")'"
            query = query + colon + "'\(company.registryNumber ?? "")'" + "); "
        }
        
        query = query + insert + Tables.Document.rawValue + " (VrDokumenta, BrDokumenta, DatDokumenta, IznosDokumenta, IdPartnera, PostoPorez)" + values
        query = query + "(" + "'\(doc.docVr ?? "")'"
        query = query + colon + "\(doc.docNumber ?? 0)"
        query = query + colon + "'\(doc.docDate?.string(custom: "YYYYMMdd hh:mm:ss a") ?? "")'"
        query = query + colon + "\(doc.docValue ?? 0)"
        query = query + colon + "\(company?.companyId ?? (person?.id ?? 0))"
        query = query + colon + "\(doc.tax ?? 0)" + ")"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    func addUnitToDocument(unit: UnitDAL, docId: Int?, item: ItemDAL, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = insert + Tables.Item.rawValue + " (CijArtikla, JedMjere, NazArtikla, TekstArtikla, SifArtikla, ZastUsluga)" + values
        query = query + "(" + "\(item.price ?? 0)"
        query = query + colon + "'\(item.measUnit ?? "")'"
        query = query + colon + "'\(item.name ?? "")'"
        query = query + colon + "'\(item.text ?? "")'"
        query = query + colon + "\(item.code ?? 0)"
        query = query + colon + "\(item.secU ?? NSNumber(integerLiteral: 0))" + "); "
        
        query = query + insert + Tables.Unit.rawValue + " (IdDokumenta, JedCijArtikla, KolArtikla, SifArtikla, PostoRabat)" + values
        query = query + "(" + "\(docId ?? 0)"
        query = query + colon + "\(unit.itemPrice ?? 0)"
        query = query + colon + "\(unit.itemQuantity ?? 0)"
        query = query + colon + "\(item.code ?? 0)"
        query = query + colon + "\(unit.discount ?? 0)" + ")"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func addBeforeDoc(docId: Int?, beforeDocId: Int?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Document.rawValue + set
        query = query + "IdPrethDokumenta = '\(beforeDocId ?? 0)'"
        query = query + whereClause + "IdDokumenta = '\(docId ?? 0)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
        
    }
    
}
