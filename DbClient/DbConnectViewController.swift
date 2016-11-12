//
//  DbConnectViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 05/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Cocoa
import ObjectMapper

class DbConnectViewController: NSViewController, SQLClientDelegate, NSTableViewDataSource, NSTableViewDelegate {
	
	@IBOutlet weak var tableView: NSTableView!
	
	let hostName = "rppp.fer.hr:3000"
	let username = "rppp"
	let password = "r3p##2011"
	let dbName = "Firma"
	let selectQuery = "SELECT * FROM "
	let dbItemView = "DbItemView"
	var client: SQLClient?
	var items: [Item] = []
	
	private struct TableList {
		static let item = "Artikl"
		static let document = "Dokument"
	}

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbItemView, bundle: nil), forIdentifier: dbItemView)
		
		connectToSqlServer()
	}
	
	
	func connectToSqlServer() {
		client = SQLClient.sharedInstance()
		client?.delegate = self
		
		client?.connect(hostName, username: username, password: password, database: dbName, completion: { [weak self] (completed) in
			guard let `self` = self else { return }
			
			if completed {
				self.executeQueries()
			} else {
				print("Connection failure")
			}
			
		})
	}
	
	
	func executeQueries() {
		client?.execute(self.selectQuery + TableList.item, completion: { (dbData) in
			if let data = dbData {
				for table in data {
					if let tab = table as? Array<Dictionary<String, AnyObject>> {
						for row in tab {
							if let item = Item(JSON: row) {
								self.items.append(item)
							}
						}
					}
				}
			}
			self.tableView.reloadData()
		})
		
		//			client?.execute(self.selectQuery + TableList.document, completion: { (data) in
		//				for table in data! {
		//					if let tab = table as? Array<Dictionary<String, AnyObject>> {
		//						for row in tab {
		//							let artikl = Artikl(JSON: row)
		//						}
		//					}
		//				}
		//			})
	}
	
	
	func error(_ error: String!, code: Int32, severity: Int32) {
		print(error)
	}
	
	
	func message(_ message: String!) {
		print(message)
	}

	
	override var representedObject: Any? {
		didSet {
		// Update the view, if already loaded.
		}
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
	
	
	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		return true
	}

}

