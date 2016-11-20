//
//  GeneralExtensions.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//


//				client?.execute("SELECT DISTINCT Stavka.* FROM Artikl LEFT JOIN Stavka ON Stavka.SifArtikla = " + item.code!.description + " WHERE Stavka.SifArtikla <> NULL", completion: { (data) in
//					if let dbData = data {
//						for table in dbData {
//							if let tab = table as? Array<Dictionary<String, AnyObject>> {
//								for row in tab {
//									if let unit = Unit(JSON: row) {
//										item.units.append(unit)
//									}
//								}
//							}
//						}
//					}
//				})

import Foundation
import Cocoa

extension NSTextField {
	
	func addAttributedString(_ nameString: String, dataString: String?) {
		let codeAttString = NSMutableAttributedString(string: nameString + (dataString ?? ""))
		codeAttString.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFont(ofSize: 14), range: NSRange(location: 0, length: nameString.characters.count))
		
		attributedStringValue = codeAttString
	}
	
}
