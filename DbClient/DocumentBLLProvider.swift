//
//  DocumentBLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class DocumentBLLProvider {
    
    let dalProvider = DocumentDALProvider()
    
    func updateDocument(doc: Document, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.updateDocument(doc: doc.toDAL() as! DocumentDAL, completion: completion)
    }
    
    
    func addDocument(doc: Document, company: Company?, person: Person?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addDocument(doc: doc.toDAL() as! DocumentDAL, company: company?.toDAL() as? CompanyDAL, person: person?.toDAL() as? PersonDAL, completion: completion)
    }
    
    
    func addUnitToDocument(unit: Unit, docId: Int?, item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addUnitToDocument(unit: unit.toDAL() as! UnitDAL, docId: docId, item: item.toDAL() as! ItemDAL, completion: completion)
    }
    
    func addBeforeDoc(docId: Int?, beforeDocId: Int?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addBeforeDoc(docId: docId, beforeDocId: beforeDocId, completion: completion)
    }
    
}
