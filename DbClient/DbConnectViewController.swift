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
	let dbNameView = "DbNameView"
	let dbTableViewController = "DbTableViewController"
	var client: SQLClient?
	var items: [Item] = []
	var tables: [Tables] = []
	
	enum Tables: String {
		case Item = "Artikl"
		case Document = "Dokument"
	}

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbNameView, bundle: nil), forIdentifier: dbNameView)
		
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
		
		let tables = [Tables.Item]
		
		for table in tables {
			client?.execute(selectQuery + table.rawValue, completion: { [weak self] (dbData) in
				if let data = dbData {
					self?.proccessQuery(data: data, type: table)
					self?.tables.append(table)
					self?.tableView.reloadData()
				} else {
					print("No data")
				}
			})
		}
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
				self.items.append(item)
			}
		case .Document:
			break
		}
	}
	
	
	func error(_ error: String!, code: Int32, severity: Int32) {
		print(error)
	}
	
	
	func message(_ message: String!) {
		print(message)
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
		let dbTableVC = storyboard?.instantiateController(withIdentifier: dbTableViewController) as! DbTableViewController
		dbTableVC.items = items
		dbTableVC.title = tables[row].rawValue
		
		presentViewControllerAsModalWindow(dbTableVC)
		return true
	}

}

