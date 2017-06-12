//
//  IdGeneratorService.swift
//  DbClient
//
//  Created by Filip Fajdetic on 10/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class IdGeneratorService {
    
    func generateIdForPartner(partners: [Partner]) -> Int {
        let id = partners.map({ (partner) -> Int in
            return partner.partnerId!
        }).max()! + 1
        
        return id
    }
    
    func generateIdForItem(items: [Item]) -> Int {
        let code = items.map({ (item) -> Int in
            return item.code!
        }).max()! + 1
        
        return code
    }
    
    func generateIdForPlace(places: [Place]) -> Int {
        let id = places.map({ (place) -> Int in
            return place.id!
        }).max()! + 1
        
        return id
    }
    
}
