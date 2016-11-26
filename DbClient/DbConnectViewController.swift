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
	case Country = "Drzava"
	case Place = "Mjesto"
	case Person = "Osoba"
	case Partner = "Partner"
	case Unit = "Stavka"
	case Company = "Tvrtka"
}

class DbConnectViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	
	@IBOutlet weak var progressIndicator: NSProgressIndicator!
	@IBOutlet weak var tableView: NSTableView!
	@IBOutlet weak var childView: NSView!
	
	let dbNameView = "DbNameView"
	let dbTableViewController = "DbTableViewController"
	
	var items: [Item] = []
	var docs: [Document] = []
	var countries: [Country] = []
	var places: [Place] = []
	var people: [Person] = []
	var partners: [Partner] = []
	var units: [Unit] = []
	var companies: [Company] = []
	
	var idsToItems: [Int: Item] = [:]
	var idsToCountries: [String: Country] = [:]
	var idsToPlaces: [Int: Place] = [:]
	var idsToDocs: [Int: Document] = [:]
	var idsToPartners: [Int: Partner] = [:]
	
	var tables: [Tables] = []
	var queryTables: [Tables] = []
	var dbTableVC: DbTableViewController!
	let viewModel = DbConnectViewModel()

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbNameView, bundle: nil), forIdentifier: dbNameView)
		progressIndicator.isHidden = true
		
		executeQueries()
		
		addDbTableAsChild()
	}
	
	
	func addDbTableAsChild() {
		dbTableVC = storyboard?.instantiateController(withIdentifier: dbTableViewController) as! DbTableViewController
		addChildViewController(dbTableVC)
		childView.addSubview(dbTableVC.view)
	}
	
	
	override func viewDidLayout() {
		super.viewDidLayout()
		dbTableVC.view.frame = CGRect(origin: CGPoint.zero, size: childView.frame.size)
	}
	
	
	func executeQueries() {
		queryTables = [Tables.Item, Tables.Document, Tables.Country, Tables.Place, Tables.Person, Tables.Partner, Tables.Unit, Tables.Company]
		
		viewModel.connectToSqlServer(completion: { [weak self] completed in
			guard let `self` = self else { return }
			
			if completed {
				self.progressIndicator.isHidden = false
				self.queryIteration(index: 0)
			} else {
				self.showAlert(alertString: "Neuspješno spajanje na bazu", infoString: "Provjerite postavke spajanja.")
				self.progressIndicator.isHidden = true
			}
		})
	}
	
	
	func queryIteration(index: Int) {
		let table = queryTables[index]
		
		viewModel.executeQuery(table: table, completion: { [weak self] (dbData) in
			guard let `self` = self else { return }
			
			if let data = dbData {
				self.viewModel.proccessQuery(data: data, type: table)
				self.updateTableView(table: table)
				if index < self.queryTables.count-1 {
					self.queryIteration(index: index + 1)
				} else {
					self.makeConnections()
				}
			} else {
				self.showTableAlert(table: table)
				self.progressIndicator.isHidden = true
			}
		})
	}
	
	
	func makeConnections() {
		viewModel.connectUnitsWithItemsAndDocs { [weak self] in
			self?.tableView.reloadData()
			self?.dbTableVC.tableView.reloadData()
		}
		viewModel.connectCountriesAndPlaces { [weak self] in
			self?.tableView.reloadData()
			self?.dbTableVC.tableView.reloadData()
		}
		viewModel.connectPlacesAndPartners { [weak self] in
			self?.tableView.reloadData()
			self?.dbTableVC.tableView.reloadData()
		}
		viewModel.connectDocsWithPartnersAndPreviousDocs { [weak self] in
			self?.tableView.reloadData()
			self?.dbTableVC.tableView.reloadData()
		}
		viewModel.addPartnerPropertiesToPerson { [weak self] in
			self?.tableView.reloadData()
			self?.dbTableVC.tableView.reloadData()
		}
		viewModel.addPartnerPropertiesToCompany { [weak self] in
			self?.tableView.reloadData()
			self?.dbTableVC.tableView.reloadData()
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
		case .Country:
			dbTableVC.countries = countries
		case .Place:
			dbTableVC.places = places
		case .Person:
			dbTableVC.people = people
		case .Partner:
			dbTableVC.partners = partners
		case .Unit:
			dbTableVC.units = units
		case .Company:
			dbTableVC.companies = companies
		}
		
		dbTableVC.tableView.tableColumns.first?.title = tables[row].rawValue
		dbTableVC.type = tables[row]
		dbTableVC.tableView.reloadData()
		
		return true
	}
	
	
	func showTableAlert(table: Tables) {
		let alert = NSAlert()
		alert.addButton(withTitle: "OK")
		alert.messageText = "Neuspješno dohvaćanje tablice " + table.rawValue
		alert.informativeText = "Provjerite da li tablica postoji na serveru."
		alert.alertStyle = .warning
		if let window = view.window {
			alert.beginSheetModal(for: window, completionHandler: nil)
		}
	}
	
	
	func showAlert(alertString: String, infoString: String) {
		let alert = NSAlert()
		alert.addButton(withTitle: "OK")
		alert.messageText = alertString
		alert.informativeText = infoString
		alert.alertStyle = .warning
		if let window = view.window {
			alert.beginSheetModal(for: window, completionHandler: nil)
		}
	}
	
	
	func updateTableView(table: Tables) {
		updateDataSource(type: table)
		tables.append(table)
		tableView.reloadData()
		incrementProgress()
	}
	
	
	func updateDataSource(type: Tables) {
		switch type {
		case .Item:
			items = viewModel.items
		case .Country:
			countries = viewModel.countries
		case .Company:
			companies = viewModel.companies
		case .Document:
			docs = viewModel.docs
		case .Partner:
			partners = viewModel.partners
		case .Person:
			people = viewModel.people
		case .Unit:
			units = viewModel.units
		case .Place:
			places = viewModel.places
		}
	}
	
	
	func incrementProgress() {
		progressIndicator.increment(by: 1)
		if progressIndicator.doubleValue == progressIndicator.maxValue {
			progressIndicator.isHidden = true
		}
	}

}

