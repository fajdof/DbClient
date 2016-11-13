//
//  GeneralExtensions.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa

extension NSTextField {
	
	func addAttributedString(_ nameString: String, dataString: String?) {
		let codeAttString = NSMutableAttributedString(string: nameString + (dataString ?? ""))
		codeAttString.addAttribute(NSFontAttributeName, value: NSFont.boldSystemFont(ofSize: 14), range: NSRange(location: 0, length: nameString.characters.count))
		
		attributedStringValue = codeAttString
	}
	
}
