//
//  DbListView.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa


class DbListView: NSTableCellView {
	
    @IBOutlet weak var addDocButton: EditButton!
    @IBOutlet weak var addShipmentButton: EditButton!
    @IBOutlet weak var addButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var addButton: EditButton!
    @IBOutlet weak var editButton: EditButton!
    @IBOutlet weak var deleteButton: EditButton!
	@IBOutlet weak var firstButton: DisclosureButton!
	@IBOutlet weak var secondButton: DisclosureButton!
	@IBOutlet weak var thirdButton: DisclosureButton!
	@IBOutlet weak var firstLabel: NSTextField!
	@IBOutlet weak var secondLabel: NSTextField!
	@IBOutlet weak var thirdLabel: NSTextField!
	@IBOutlet weak var fourthLabel: NSTextField!
	@IBOutlet weak var fifthLabel: NSTextField!
	@IBOutlet weak var sixthLabel: NSTextField!
	@IBOutlet weak var seventhLabel: NSTextField!
	@IBOutlet weak var eighthLabel: NSTextField!
	
	override func awakeFromNib() {
		super.awakeFromNib()
	}
}
