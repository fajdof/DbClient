//
//  DbItemView.swift
//  DbClient
//
//  Created by Filip Fajdetic on 12/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import AppKit

class DbItemView: NSTableCellView {
	
	@IBOutlet weak var disclosureButton: DisclosureButton!
	@IBOutlet weak var unitLabel: NSTextField!
	@IBOutlet weak var ZULabel: NSTextField!
	@IBOutlet weak var codeLabel: NSTextField!
	@IBOutlet weak var descLabel: NSTextField!
	@IBOutlet weak var nameLabel: NSTextField!
	@IBOutlet weak var priceLabel: NSTextField!
	@IBOutlet weak var itemImageView: NSImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
