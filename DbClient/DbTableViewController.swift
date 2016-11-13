//
//  DbTableViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 12/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa


class DbTableViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	
	@IBOutlet weak var tableView: NSTableView!
	
	let dbItemView = "DbItemView"
	var items: [Item] = []
	var docs: [Document] = []
	var type: Tables! = Tables.Item
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbItemView, bundle: nil), forIdentifier: dbItemView)
		
	}
	
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 220
	}
	
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cellView = tableView.make(withIdentifier: dbItemView, owner: self) as! DbItemView
		
		switch type! {
		case .Item:
			return configureItemView(itemView: cellView, row: row)
		case .Document:
			return NSView()
		}
	}
	
	
	func configureItemView(itemView: DbItemView, row: Int) -> DbItemView {
		let item = items[row]
		
		itemView.codeLabel.addAttributedString(Item.Attributes.code, dataString: item.code)
		itemView.descLabel.addAttributedString(Item.Attributes.text, dataString: item.text)
		itemView.priceLabel.addAttributedString(Item.Attributes.price, dataString: item.price)
		itemView.unitLabel.addAttributedString(Item.Attributes.unit, dataString: item.unit)
		itemView.ZULabel.addAttributedString(Item.Attributes.secU, dataString: item.secU)
		itemView.nameLabel.addAttributedString(Item.Attributes.name, dataString: item.name)
		itemView.itemImageView.image = item.image
		
		return itemView
	}
	
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		switch type! {
		case .Item:
			return items.count
		case .Document:
			return docs.count
		}
	}
}
