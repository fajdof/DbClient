//
//  UnitBLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class UnitBLLProvider {
    
    let dalProvider = UnitDALProvider()
    
    func updateUnit(unit: Unit, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.updateUnit(unit: unit.toDAL() as! UnitDAL, completion: completion)
    }
    
}
