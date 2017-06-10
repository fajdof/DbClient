//
//  DocumentReqValidator.swift
//  DbClient
//
//  Created by Filip Fajdetic on 10/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class DocumentReqValidator: Requiredable {
    
    var doc: Document
    
    init(doc: Document) {
        self.doc = doc
    }
    
    func requirementFulfilled() -> Bool {
        guard doc.docDate == nil || doc.docNumber == nil || doc.docValue == nil || doc.tax == nil else {
            return true
        }
        
        return false
    }
    
}
