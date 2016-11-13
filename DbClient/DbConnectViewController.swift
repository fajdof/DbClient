//
//  DbConnectViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 05/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Cocoa
import ObjectMapper

enum Tables: String {
	case Item = "Artikl"
	case Document = "Dokument"
}

class DbConnectViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	
	@IBOutlet weak var tableView: NSTableView!
	@IBOutlet weak var childView: NSView!
	
	let hostName = "rppp.fer.hr:3000"
	let username = "rppp"
	let password = "r3p##2011"
	let dbName = "Firma"
	let selectQuery = "SELECT * FROM "
	let dbNameView = "DbNameView"
	let dbTableViewController = "DbTableViewController"
	
	var client: SQLClient?
	var items: [Item] = []
	var docs: [Document] = []
	var tables: [Tables] = []
	var queryTables: [Tables] = []
	var dbTableVC: DbTableViewController!

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbNameView, bundle: nil), forIdentifier: dbNameView)
		
		connectToSqlServer()
	}
	
	
	override func viewDidLayout() {
		super.viewDidLayout()
		
		dbTableVC = storyboard?.instantiateController(withIdentifier: dbTableViewController) as! DbTableViewController
		addChildViewController(dbTableVC)
		dbTableVC.view.frame = CGRect(origin: CGPoint.zero, size: childView.frame.size)
		
		childView.addSubview(dbTableVC.view)
	}
	
	
	func connectToSqlServer() {
		client = SQLClient.sharedInstance()
		
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
		
		queryTables = [Tables.Item, Tables.Document]
		
		queryIteration(index: 0)
	}
	
	
	func queryIteration(index: Int) {
		let table = queryTables[index]
		
		client?.execute(selectQuery + table.rawValue, completion: { [weak self] (dbData) in
			guard let `self` = self else { return }
			if let data = dbData {
				print(data)
				self.proccessQuery(data: data, type: table)
				self.tables.append(table)
				self.tableView.reloadData()
				if index < self.queryTables.count-1 {
					self.queryIteration(index: index + 1)
				}
			} else {
				print("No data")
			}
		})
	}
	
	
	func proccessQuery(data: [Any], type: Tables) {
		for table in data {
			if let tab = table as? Array<Dictionary<String, AnyObject>> {
				for row in tab {
					parseRow(row: row, type: type)
				}
			}
		}
	}
	
	
	func parseRow(row: Dictionary<String, AnyObject>, type: Tables) {
		switch type {
		case .Item:
			if let item = Item(JSON: row) {
				items.append(item)
			}
		case .Document:
			if let doc = Document(JSON: row) {
				docs.append(doc)
			}
		}
	}
	
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		return 60
	}
	
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		let cellView = tableView.make(withIdentifier: dbNameView, owner: self) as! DbNameView
		return configureNameView(nameView: cellView, row: row)
	}
	
	
	func configureNameView(nameView: DbNameView, row: Int) -> DbNameView {
		nameView.nameLabel.stringValue = tables[row].rawValue
		
		return nameView
	}
	
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return tables.count
	}
	
	
	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		switch tables[row] {
		case .Item:
			dbTableVC.items = items
		case .Document:
			dbTableVC.docs = docs
		}
		
		dbTableVC.tableView.tableColumns.first?.title = tables[row].rawValue
		dbTableVC.type = tables[row]
		dbTableVC.tableView.reloadData()
		
		return true
	}

}

