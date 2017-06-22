//
//  BLLConvertible.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


protocol BLLConvertible {
    
    func toBLL() -> BLLType
    
}