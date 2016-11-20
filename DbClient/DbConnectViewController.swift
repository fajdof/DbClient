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
	var countries: [Country] = []
	var places: [Place] = []
	var people: [Person] = []
	var partners: [Partner] = []
	var units: [Unit] = []
	var companies: [Company] = []
	
	var tables: [Tables] = []
	var queryTables: [Tables] = []
	var dbTableVC: DbTableViewController!

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbNameView, bundle: nil), forIdentifier: dbNameView)
		
		connectToSqlServer()
		
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
	
	
	func connectToSqlServer() {
		client = SQLClient.sharedInstance()
		
		client?.connect(hostName, username: username, password: password, database: dbName, completion: { [weak self] (completed) in
			guard let `self` = self else { return }
			
			if completed {
				self.executeQueries()
			} else {
				self.showAlert(alertString: "Neuspješno spajanje na bazu", infoString: "Provjerite postavke spajanja.")
			}
			
		})
	}
	
	
	func executeQueries() {
		
		queryTables = [Tables.Item, Tables.Document, Tables.Country, Tables.Place, Tables.Person, Tables.Partner, Tables.Unit, Tables.Company]
		
		queryIteration(index: 0)
	}
	
	
	func queryIteration(index: Int) {
		let table = queryTables[index]
		
		client?.execute(selectQuery + table.rawValue, completion: { [weak self] (dbData) in
			guard let `self` = self else { return }
			if let data = dbData {
				self.proccessQuery(data: data, type: table)
				self.tables.append(table)
				self.tableView.reloadData()
				if index < self.queryTables.count-1 {
					self.queryIteration(index: index + 1)
				} else {
					self.connectUnitsAndItems()
					self.connectCountriesAndPlaces()
					self.connectPlacesAndPartners()
					self.connectUnitsAndDocuments()
					self.connectPartnersAndDocuments()
					self.connectDocuments()
					self.addPartnerPropertiesToPerson()
					self.addPartnerPropertiesToCompany()
				}
			} else {
				self.showTableAlert(table: table)
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
		case .Country:
			if let country = Country(JSON: row) {
				countries.append(country)
			}
		case .Place:
			if let place = Place(JSON: row) {
				places.append(place)
			}
		case .Person:
			if let person = Person(JSON: row) {
				people.append(person)
			}
		case .Partner:
			if let partner = Partner(JSON: row) {
				partners.append(partner)
			}
		case .Unit:
			if let unit = Unit(JSON: row) {
				units.append(unit)
			}
		case .Company:
			if let company = Company(JSON: row) {
				companies.append(company)
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
	
	
	func connectUnitsAndItems() {
		DispatchQueue.global().async { [weak self] in
			guard let `self` = self else { return }
			for item in self.items {
				for unit in self.units {
					if unit.itemCode == item.code {
						item.units.append(unit)
						unit.item = item
					}
				}
			}
		}
	}
	
	
	func connectCountriesAndPlaces() {
		DispatchQueue.global().async { [weak self] in
			guard let `self` = self else { return }
			for country in self.countries {
				for place in self.places {
					if place.countryCode == country.mark {
						country.places.append(place)
						place.country = country
					}
				}
			}
		}
	}
	
	
	func connectPlacesAndPartners() {
		DispatchQueue.global().async { [weak self] in
			guard let `self` = self else { return }
			for place in self.places {
				for partner in self.partners {
					if partner.partnerAddressId == place.id {
						place.partners.append(partner)
						partner.partnerPlace = place
					}
					if partner.shipmentAddressId == place.id {
						partner.shipmentPlace = place
						if !place.partners.contains(where: { (thePartner) -> Bool in
							if thePartner.partnerId == partner.partnerId {
								return true
							} else {
								return false
							}
						}) {
							place.partners.append(partner)
						}
					}
				}
			}
		}
	}
	
	
	func connectUnitsAndDocuments() {
		DispatchQueue.global().async { [weak self] in
			guard let `self` = self else { return }
			for doc in self.docs {
				for unit in self.units {
					if unit.docId == doc.docId {
						doc.units.append(unit)
						unit.document = doc
					}
				}
			}
		}
	}
	
	
	func connectPartnersAndDocuments() {
		DispatchQueue.global().async { [weak self] in
			guard let `self` = self else { return }
			for partner in self.partners {
				for doc in self.docs {
					if doc.partnerId == partner.partnerId {
						partner.docs.append(doc)
						doc.partner = partner
					}
				}
			}
		}
	}
	
	
	func connectDocuments() {
		DispatchQueue.global().async { [weak self] in
			guard let `self` = self else { return }
			for doc in self.docs {
				for beforeDoc in self.docs {
					if doc.docBeforeId == beforeDoc.docId {
						doc.docBefore = beforeDoc
					}
				}
			}
		}
	}
	
	
	func addPartnerPropertiesToPerson() {
		DispatchQueue.global().async { [weak self] in
			guard let `self` = self else { return }
			for person in self.people {
				for partner in self.partners {
					if partner.partnerId == person.id {
						self.addPartnerProperties(to: person, partnerOrigin: partner)
					}
				}
			}
		}
	}
	
	
	func addPartnerPropertiesToCompany() {
		DispatchQueue.global().async { [weak self] in
			guard let `self` = self else { return }
			for company in self.companies {
				for partner in self.partners {
					if partner.partnerId == company.companyId {
						self.addPartnerProperties(to: company, partnerOrigin: partner)
					}
				}
			}
		}
	}
	
	
	func addPartnerProperties(to partnerObject: Partner, partnerOrigin: Partner) {
		partnerObject.oib = partnerOrigin.oib
		partnerObject.docs = partnerOrigin.docs
		partnerObject.partnerAddress = partnerOrigin.partnerAddress
		partnerObject.partnerAddressId = partnerOrigin.partnerAddressId
		partnerObject.shipmentAddress = partnerOrigin.shipmentAddress
		partnerObject.shipmentAddressId = partnerOrigin.shipmentAddressId
		partnerObject.shipmentPlace = partnerOrigin.shipmentPlace
		partnerObject.partnerPlace = partnerOrigin.partnerPlace
		partnerObject.type = partnerOrigin.type
	}

}

