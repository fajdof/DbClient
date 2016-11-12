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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbItemView, bundle: nil), forIdentifier: dbItemView)
		
	}
	
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 200
	}
	
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cellView = tableView.make(withIdentifier: dbItemView, owner: self) as! DbItemView
		return configureItemView(itemView: cellView, row: row)
	}
	
	
	func configureItemView(itemView: DbItemView, row: Int) -> DbItemView {
		let item = items[row]
		itemView.codeLabel.stringValue = "Šifra: " + (item.code ?? "")
		itemView.descLabel.stringValue = "Tekst: " + (item.text ?? "")
		itemView.nameLabel.stringValue = "Naziv: " + (item.name ?? "")
		itemView.priceLabel.stringValue = "Cijena: " + (item.price ?? "")
		itemView.unitLabel.stringValue = "Jedinica mjere: " + (item.unit ?? "")
		itemView.ZULabel.stringValue = "ZaštUsluga: " + (item.secU ?? "")
		itemView.itemImageView.image = item.image
		
		return itemView
	}
	
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return items.count
	}
}
