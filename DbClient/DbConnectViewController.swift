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
    
    let hostName = "rppp.fer.hr:3000"
    let username = "rppp"
    let password = "r3p##2011"
    let dbName = "Firma"
    let selectQuery = "SELECT * FROM "
    
    var idsToItems: [Int: Item] = [:]
    var idsToCountries: [String: Country] = [:]
    var idsToPlaces: [Int: Place] = [:]
    var idsToDocs: [Int: Document] = [:]
    var idsToPartners: [Int: Partner] = [:]
    var idsToCompanies: [Int: Company] = [:]
    var idsToPeople: [Int: Person] = [:]
    
    var client: SQLClient?

	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        client = SQLClient.sharedInstance()
		
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
		
		connectToSqlServer(completion: { [weak self] completed in
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
        items = []
        companies = []
        countries = []
        docs = []
        units = []
        places = []
        people = []
        partners = []
        idsToCompanies = [:]
        idsToDocs = [:]
        idsToItems = [:]
        idsToPeople = [:]
        idsToPlaces = [:]
        idsToPartners = [:]
        idsToCountries = [:]
    }
	
	
	func queryIteration(index: Int) {
		let table = queryTables[index]
		
		executeQuery(table: table, completion: { [weak self] (dbData) in
			guard let `self` = self else { return }
			
			if let data = dbData {
				self.proccessQuery(data: data, type: table)
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
		connectUnitsWithItemsAndDocs { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
		}
		connectCountriesAndPlaces { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
		}
		connectPlacesAndPartners { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
		}
		connectDocsWithPartnersAndPreviousDocs { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
		}
		addPartnerPropertiesToPerson { [weak self] in
			self?.dbTableVC1.tableView.reloadData()
		}
		addPartnerPropertiesToCompany { [weak self] in
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
                if let company = self.idsToCompanies[partner.partnerId!] {
                    return company
                }
                if let person = self.idsToPeople[partner.partnerId!] {
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
        dbTableVC1.toggleAddButton(button: dbTableVC1.addButton, hidden: false)
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
        if table != Tables.Partner && table != Tables.Unit && table != Tables.Place {
            tables.append(table)
        }
		tableView.reloadData()
		incrementProgress()
	}
	
	
	func updateDataSource(type: Tables) {
		switch type {
		case .Item:
			items = items.sorted(by: { (fItem, sItem) -> Bool in
                return fItem.code! > sItem.code!
            })
		case .Country:
			countries = countries.sorted(by: { (fCountry, sCountry) -> Bool in
                return fCountry.mark! < sCountry.mark!
            })
		case .Company:
			companies = companies.sorted(by: { (fCompany, sCompany) -> Bool in
                return fCompany.companyId! > sCompany.companyId!
            })
		case .Document:
			docs = docs.sorted(by: { (fDoc, sDoc) -> Bool in
                return fDoc.docId! > sDoc.docId!
            })
		case .Partner:
			partners = partners.sorted(by: { (fPartner, sPartner) -> Bool in
                return fPartner.partnerId! > sPartner.partnerId!
            })
		case .Person:
			people = people.sorted(by: { (fPerson, sPerson) -> Bool in
                return fPerson.id! > sPerson.id!
            })
		case .Unit:
			units = units.sorted(by: { (fUnit, sUnit) -> Bool in
                return fUnit.unitId! > sUnit.unitId!
            })
		case .Place:
			places = places.sorted(by: { (fPlace, sPlace) -> Bool in
                return fPlace.id! > sPlace.id!
            })
		}
	}
	
	
	func incrementProgress() {
		progressIndicator.increment(by: 1)
		if progressIndicator.doubleValue == progressIndicator.maxValue {
			progressIndicator.isHidden = true
            populateTableVC(withTable: dbTableVC1.type)
            dbTableVC2.emptyDbTableVC2(parentVC: self)
		}
	}
    
    func connectToSqlServer(completion: @escaping (_ completed: Bool) -> ()) {
        
        client?.connect(hostName, username: username, password: password, database: dbName, completion: { (completed) in
            
            completion(completed)
        })
    }
    
    
    func executeQuery(table: Tables,  completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        client?.execute(selectQuery + table.rawValue, completion: { (dbData) in
            
            completion(dbData)
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
                if let code = item.code {
                    idsToItems[code] = item
                }
            }
        case .Document:
            if let doc = Document(JSON: row) {
                docs.append(doc)
                if let docId = doc.docId {
                    idsToDocs[docId] = doc
                }
            }
        case .Country:
            if let country = Country(JSON: row) {
                countries.append(country)
                if let mark = country.mark {
                    idsToCountries[mark] = country
                }
            }
        case .Place:
            if let place = Place(JSON: row) {
                places.append(place)
                if let id = place.id {
                    idsToPlaces[id] = place
                }
            }
        case .Person:
            if let person = Person(JSON: row) {
                people.append(person)
                if let id = person.id {
                    idsToPeople[id] = person
                }
            }
        case .Partner:
            if let partner = Partner(JSON: row) {
                partners.append(partner)
                if let partnerId = partner.partnerId {
                    idsToPartners[partnerId] = partner
                }
            }
        case .Unit:
            if let unit = Unit(JSON: row) {
                units.append(unit)
            }
        case .Company:
            if let company = Company(JSON: row) {
                companies.append(company)
                if let id = company.companyId {
                    idsToCompanies[id] = company
                }
            }
        }
    }
    
    
    func connectUnitsWithItemsAndDocs(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for unit in self.units {
                if let itemCode = unit.itemCode {
                    let item = self.idsToItems[itemCode]
                    unit.item = item
                    item?.units.append(unit)
                }
                
                if let docId = unit.docId {
                    let doc = self.idsToDocs[docId]
                    unit.document = doc
                    doc?.units.append(unit)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func connectCountriesAndPlaces(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for place in self.places {
                if let countryCode = place.countryCode {
                    let country = self.idsToCountries[countryCode]
                    place.country = country
                    country?.places.append(place)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func connectPlacesAndPartners(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for partner in self.partners {
                if let partnerAddressId = partner.partnerAddressId {
                    let partnerPlace = self.idsToPlaces[partnerAddressId]
                    partner.partnerPlace = partnerPlace
                    partnerPlace?.partners.insert(partner)
                }
                if let shipmentAddressId = partner.shipmentAddressId {
                    let shipmentPlace = self.idsToPlaces[shipmentAddressId]
                    partner.shipmentPlace = shipmentPlace
                    shipmentPlace?.partners.insert(partner)
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func connectDocsWithPartnersAndPreviousDocs(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for doc in self.docs {
                if let partnerId = doc.partnerId {
                    let partner = self.idsToPartners[partnerId]
                    if let company = self.idsToCompanies[partnerId] {
                        doc.partner = company
                    }
                    if let person = self.idsToPeople[partnerId] {
                        doc.partner = person
                    }
                    partner?.docs.append(doc)
                }
                
                if let docBeforeId = doc.docBeforeId {
                    let docBefore = self.idsToDocs[docBeforeId]
                    doc.docBefore = docBefore
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func addPartnerPropertiesToPerson(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for person in self.people {
                if let id = person.id {
                    if let partner = self.idsToPartners[id] {
                        self.addPartnerProperties(to: person, partnerOrigin: partner)
                    }
                }
            }
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func addPartnerPropertiesToCompany(completion: @escaping () -> ()) {
        DispatchQueue.global().async { [weak self] in
            guard let `self` = self else { return }
            for company in self.companies {
                if let id = company.companyId {
                    if let partner = self.idsToPartners[id] {
                        self.addPartnerProperties(to: company, partnerOrigin: partner)
                    }
                }
            }
            DispatchQueue.main.async {
                completion()
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

