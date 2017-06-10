//
//  IdGeneratorService.swift
//  DbClient
//
//  Created by Filip Fajdetic on 10/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class IdGeneratorService {
    
    static func generateIdForPartner(partners: [Partner]) -> Int {
        let id = partners.map({ (partner) -> Int in
            return partner.partnerId!
        }).max()! + 1
        
        return id
    }
    
    static func generateIdForItem(items: [Item]) -> Int {
        let code = items.map({ (item) -> Int in
            return item.code!
        }).max()! + 1
        
        return code
    }
    
}
