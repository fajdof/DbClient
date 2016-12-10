//
//  DisclosureButton.swift
//  DbClient
//
//  Created by Filip Fajdetic on 10/12/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa


class DisclosureButton: NSButton {
	
	var items: [Item] = []
	var docs: [Document] = []
	var countries: [Country] = []
	var places: [Place] = []
	var people: [Person] = []
	var partners: [Partner] = []
	var units: [Unit] = []
	var companies: [Company] = []
	var type: Tables! = Tables.Item
	
}
