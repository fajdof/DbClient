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
	let dbListView = "DbListView"
	var items: [Item] = []
	var docs: [Document] = []
	var type: Tables! = Tables.Item
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbItemView, bundle: nil), forIdentifier: dbItemView)
		tableView.register(NSNib(nibNamed: dbListView, bundle: nil), forIdentifier: dbListView)
	}
	
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		switch type! {
		case .Item:
			return 220
		case .Document:
			return 280
		}
	}
	
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		switch type! {
		case .Item:
			let cellView = tableView.make(withIdentifier: dbItemView, owner: self) as! DbItemView
			return configureItemView(itemView: cellView, row: row)
		case .Document:
			let cellView = tableView.make(withIdentifier: dbListView, owner: self) as! DbListView
			return configureDocumentView(docView: cellView, row: row)
		}
	}
	
	
	func configureItemView(itemView: DbItemView, row: Int) -> DbItemView {
		let item = items[row]
		
		itemView.codeLabel.addAttributedString(Item.Attributes.code, dataString: item.code?.description)
		itemView.descLabel.addAttributedString(Item.Attributes.text, dataString: item.text)
		itemView.priceLabel.addAttributedString(Item.Attributes.price, dataString: item.price?.description)
		itemView.unitLabel.addAttributedString(Item.Attributes.unit, dataString: item.unit)
		itemView.ZULabel.addAttributedString(Item.Attributes.secU, dataString: item.secU?.description)
		itemView.nameLabel.addAttributedString(Item.Attributes.name, dataString: item.name)
		if let imageData = item.image {
			itemView.itemImageView.image = NSImage(data: imageData)
		} else {
			itemView.itemImageView.image = nil
		}
		
		return itemView
	}
	
	
	func configureDocumentView(docView: DbListView, row: Int) -> DbListView {
		let doc = docs[row]
		
		docView.firstLabel.addAttributedString(Document.Attributes.docId, dataString: doc.docId?.description)
		docView.secondLabel.addAttributedString(Document.Attributes.docNumber, dataString: doc.docNumber?.description)
		docView.thirdLabel.addAttributedString(Document.Attributes.docDate, dataString: doc.docDate?.description)
		docView.fourthLabel.addAttributedString(Document.Attributes.docValue, dataString: doc.docValue?.description)
		docView.fifthLabel.addAttributedString(Document.Attributes.docBeforeId, dataString: doc.docBeforeId?.description)
		docView.sixthLabel.addAttributedString(Document.Attributes.partnerId, dataString: doc.partnerId?.description)
		docView.seventhLabel.addAttributedString(Document.Attributes.docVr, dataString: doc.docVr)
		docView.eighthLabel.addAttributedString(Document.Attributes.tax, dataString: doc.tax?.description)
		
		return docView
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
