//
//  EditButton.swift
//  DbClient
//
//  Created by Filip Fajdetic on 19/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa


class EditButton: NSButton {
    
    var item: Item!
    var doc: Document!
    var country: Country!
    var place: Place!
    var person: Person!
    var partner: Partner!
    var unit: Unit!
    var company: Company!
    var type: Tables! = Tables.Item
    
}
