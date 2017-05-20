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

enum TablePlurals: String {
	case Places = "Mjesta"
	case Companies = "Tvrtke"
	case Units = "Stavke"
	case Documents = "Dokumenti"
	case Partners = "Partneri"
}

enum Places: String {
	case ShipmentPlace = "Mjesto isporuke"
	case PartnerPlace = "Mjesto partnera"
}

enum DocBefore: String {
	case Doc = "Prethodni dokument"
}

class DbConnectViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	
	@IBOutlet weak var tableViewLeading: NSLayoutConstraint!
	@IBOutlet weak var tableViewTrailing: NSLayoutConstraint!
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
	
	var tables: [Tables] = []
	var queryTables: [Tables] = []
	var dbTableVC1: DbTableViewController!
	var dbTableVC2: DbTableViewController!
	let viewModel = DbConnectViewModel()

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbNameView, bundle: nil), forIdentifier: dbNameView)
		progressIndicator.isHidden = true
		
		executeQueries()
		
		addDbTablesAsChildren()
	}
	
	
	func addDbTablesAsChildren() {
		dbTableVC1 = storyboard?.instantiateController(withIdentifier: dbTableViewController) as! DbTableViewController
		addChildViewController(dbTableVC1)
		childView.addSubview(dbTableVC1.view)
		
		dbTableVC2 = storyboard?.instantiateController(withIdentifier: dbTableViewController) as! DbTableViewController
		addChildViewController(dbTableVC2)
		childView.addSubview(dbTableVC2.view)
	}
	
	
	override func viewDidLayout() {
		super.viewDidLayout()
		dbTableVC1.view.frame = CGRect(origin: CGPoint.zero, size: childView.frame.size)
		dbTableVC1.tableView.reloadData()
		if dbTableVC1.backButton.isHidden == false {
			dbTableVC1.view.frame.size.width = self.view.window!.frame.size.width/2
		}
		
		if dbTableVC1.backButton.isHidden == true {
			dbTableVC2.view.frame = CGRect(origin: CGPoint(x: childView.frame.size.width, y: 0), size: childView.frame.size)
		} else {
			dbTableVC2.view.frame = CGRect(origin: CGPoint(x: childView.frame.size.width/2, y: 0), size: childView.frame.size)
		}
	}
	
	
	func executeQueries() {
		queryTables = [Tables.Item, Tables.Document, Tables.Country, Tables.Place, Tables.Person, Tables.Partner, Tables.Unit, Tables.Company]
		
		viewModel.connectToSqlServer(completion: { [weak self] completed in
			guard let `self` = self else { return }
			
			if completed {
				self.startQueryIterations()
			} else {
				self.showAlert(alertString: "Neuspješno spajanje na bazu", infoString: "Provjerite postavke spajanja.")
				self.progressIndicator.isHidden = true
			}
		})
	}
    
    
    func startQueryIterations() {
        progressIndicator.isHidden = false
        progressIndicator.doubleValue = 0
        queryIteration(index: 0)
    }
    
    
    func emptyDatasource() {
        tables = []
        viewModel.items = []
        viewModel.companies = []
        viewModel.countries = []
        viewModel.docs = []
        viewModel.units = []
        viewModel.places = []
        viewModel.people = []
        viewModel.partners = []
        viewModel.idsToCompanies = [:]
        viewModel.idsToDocs = [:]
        viewModel.idsToItems = [:]
        viewModel.idsToPeople = [:]
        viewModel.idsToPlaces = [:]
        viewModel.idsToPartners = [:]
        viewModel.idsToCountries = [:]
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
			self?.dbTableVC1.tableView.reloadData()
		}
		viewModel.connectCountriesAndPlaces { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
		}
		viewModel.connectPlacesAndPartners { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
		}
		viewModel.connectDocsWithPartnersAndPreviousDocs { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
		}
		viewModel.addPartnerPropertiesToPerson { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
		}
		viewModel.addPartnerPropertiesToCompany { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
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
		
		populateTableVC(withTable: tables[row])
		
		return true
	}
    
    
    func populateTableVC(withTable table: Tables) {
        
        switch table {
        case .Item:
            dbTableVC1.items = items
        case .Document:
            dbTableVC1.docs = docs
        case .Country:
            dbTableVC1.countries = countries
        case .Place:
            dbTableVC1.places = places
        case .Person:
            dbTableVC1.people = people
        case .Partner:
            dbTableVC1.partners = partners.map({ (partner) -> Partner in
                if let company = self.viewModel.idsToCompanies[partner.partnerId!] {
                    return company
                }
                if let person = self.viewModel.idsToPeople[partner.partnerId!] {
                    return person
                }
                return partner
            })
        case .Unit:
            dbTableVC1.units = units
        case .Company:
            dbTableVC1.companies = companies
        }
        
        if table == Tables.Document {
            dbTableVC1.addButton.action = #selector(DbTableViewController.addNewDoc)
        } else {
            dbTableVC1.addButton.action = #selector(DbTableViewController.addNew)
        }
        
        dbTableVC1.tableView.tableColumns.first?.title = table.rawValue
        dbTableVC1.type = table
        dbTableVC1.currentOffset = 20
        dbTableVC1.tableView.reloadData()
        dbTableVC1.tableView.scrollRowToVisible(0)
        dbTableVC1.presenter.toggleAddButton(button: dbTableVC1.addButton, hidden: false)
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
        if table != Tables.Partner && table != Tables.Unit {
            tables.append(table)
        }
		tableView.reloadData()
		incrementProgress()
	}
	
	
	func updateDataSource(type: Tables) {
		switch type {
		case .Item:
			items = viewModel.items.sorted(by: { (fItem, sItem) -> Bool in
                return fItem.code! < sItem.code!
            })
		case .Country:
			countries = viewModel.countries.sorted(by: { (fCountry, sCountry) -> Bool in
                return fCountry.mark! < sCountry.mark!
            })
		case .Company:
			companies = viewModel.companies.sorted(by: { (fCompany, sCompany) -> Bool in
                return fCompany.companyId! < sCompany.companyId!
            })
		case .Document:
			docs = viewModel.docs.sorted(by: { (fDoc, sDoc) -> Bool in
                return fDoc.docId! > sDoc.docId!
            })
		case .Partner:
			partners = viewModel.partners
		case .Person:
			people = viewModel.people.sorted(by: { (fPerson, sPerson) -> Bool in
                return fPerson.id! > sPerson.id!
            })
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
            populateTableVC(withTable: dbTableVC1.type)
		}
	}

}

