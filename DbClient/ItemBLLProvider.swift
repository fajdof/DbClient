//
//  ItemBLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class ItemBLLProvider {
    
    let dalProvider = ItemDALProvider()
    
    func updateItem(item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.updateItem(item: item.toDAL() as! ItemDAL, completion: completion)
    }
    
    func addItem(item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addItem(item: item.toDAL() as! ItemDAL, completion: completion)
    }
    
}
