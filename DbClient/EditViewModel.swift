//
//  DbTableViewModel.swift
//  DbClient
//
//  Created by Filip Fajdetic on 20/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class EditViewModel {
    
    let update = "UPDATE "
    let set = " SET "
    let whereClause = " WHERE "
    let colon = ", "
    
    let insert = "INSERT INTO "
    let values = " VALUES "
    
    var client: SQLClient?
    
    init() {
        client = SQLClient.sharedInstance()
    }
    
    func updateItem(item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Item.rawValue + set
        query = query + "NazArtikla = '\(item.name!)'"
        query = query + colon + "JedMjere = '\(item.measUnit!)'"
        query = query + colon + "TekstArtikla = '\(item.text!)'"
        if let price = item.price {
            query = query + colon + "CijArtikla = \(price)"
        }
        if let secU = item.secU {
            query = query + colon + "ZastUsluga = \(secU)"
        }
        query = query + whereClause + "SifArtikla = '\(item.code!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    func addItem(item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = insert + Tables.Item.rawValue + " (CijArtikla, JedMjere, NazArtikla, TekstArtikla, SifArtikla, ZastUsluga)" + values
        query = query + "(" + "\(item.price ?? 0)"
        query = query + colon + "'\(item.measUnit ?? "")'"
        query = query + colon + "'\(item.name ?? "")'"
        query = query + colon + "'\(item.text ?? "")'"
        query = query + colon + "\(item.code ?? 0)"
        query = query + colon + "\(item.secU ?? NSNumber(integerLiteral: 0))" + ")"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }

    
    func updateCountry(country: Country, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Country.rawValue + set
        query = query + "ISO3Drzave = '\(country.iso3!)'"
        query = query + colon + "NazDrzave = '\(country.name!)'"
        if let code = country.code {
            query = query + colon + "SifDrzave = \(code)"
        }
        query = query + whereClause + "OznDrzave = '\(country.mark!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    func addCountry(country: Country, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = insert + Tables.Country.rawValue + " (ISO3Drzave, NazDrzave, SifDrzave, OznDrzave)" + values
        query = query + "(" + "'\(country.iso3 ?? "")'"
        query = query + colon + "'\(country.name ?? "")'"
        query = query + colon + "\(country.code ?? 0)"
        query = query + colon + "'\(country.mark ?? "")'" + ")"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    func updateDocument(doc: Document, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
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
    
    
    func addDocument(doc: Document, company: Company?, person: Person?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
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
    
    
    func addUnit(unit: Unit, docId: Int?, item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
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
    
    
}
