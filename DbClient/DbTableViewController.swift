//
//  DbTableViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 12/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa
import SwiftDate


class DbTableViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
	
	@IBOutlet weak var tableView: NSTableView!
	@IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var addButton: NSButton!
	
	let dbItemView = "DbItemView"
	let dbListView = "DbListView"
	var items: [Item] = []
	var docs: [Document] = []
	var countries: [Country] = []
	var places: [Place] = []
	var people: [Person] = []
	var partners: [Partner] = []
	var units: [Unit] = []
	var companies: [Company] = []
	var type: Tables! = Tables.Item
    var partnerId: Int?
    var shipment: Bool?
	
	let offset = 20
	var currentOffset: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbItemView, bundle: nil), forIdentifier: dbItemView)
		tableView.register(NSNib(nibNamed: dbListView, bundle: nil), forIdentifier: dbListView)
		backButton.isHidden = true
		currentOffset = offset
        
        toggleAddButton(button: addButton, hidden: true)
        if type == Tables.Document {
            addButton.action = #selector(DbTableViewController.addNewDoc)
        } else {
            addButton.action = #selector(DbTableViewController.addNew)
        }
        addButton.target = self
	}
	
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		switch type! {
		case .Item:
			return 200
		case .Document:
			return 260
		case .Country:
			return 150
		case .Place:
			return 120
		case .Person:
			return 280
		case .Partner:
			return 320
		case .Unit:
			return 170
		case .Company:
			return 280
		}
	}
	
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		guard let parentVC = parent as? DbConnectViewController else {
			return NSView()
		}
		
		let cellView = tableView.make(withIdentifier: dbListView, owner: self) as! DbListView
		
        connectButtons(cellView: cellView, row: row)
		
		var shouldAddButtons: Bool = true
		if self == parentVC.dbTableVC2 {
			shouldAddButtons = false
		}
		
		switch type! {
		case .Item:
			let itemView = tableView.make(withIdentifier: dbItemView, owner: self) as! DbItemView
			connectItemButtons(itemView: itemView, row: row)
			return configureItemView(itemView: itemView, item: items[row], shouldAddButtons: shouldAddButtons)
		case .Document:
            if parentVC.dbTableVC1.type == Tables.Document {
                return configureDocumentView(docView: cellView, doc: docs[row], shouldAddButtons: shouldAddButtons, shouldHideDelete: true)
            } else {
                return configureDocumentView(docView: cellView, doc: docs[row], shouldAddButtons: shouldAddButtons, shouldHideDelete: false)
            }
		case .Country:
			return configureCountryView(countryView: cellView, country: countries[row], shouldAddButtons: shouldAddButtons)
		case .Place:
			return configurePlaceView(placeView: cellView, place: places[row], shouldAddButtons: shouldAddButtons)
		case .Person:
			return configurePersonView(personView: cellView, person: people[row], shouldAddButtons: shouldAddButtons)
		case .Partner:
			if let company = partners[row] as? Company {
				return configureCompanyView(companyView: cellView, company: company, shouldAddButtons: shouldAddButtons)
			}
			if let person = partners[row] as? Person {
				return configurePersonView(personView: cellView, person: person, shouldAddButtons: shouldAddButtons)
			}
			return configurePartnerView(partnerView: cellView, partner: partners[row], shouldAddButtons: shouldAddButtons)
		case .Unit:
			return configureUnitView(unitView: cellView, unit: units[row], shouldAddButtons: shouldAddButtons)
		case .Company:
			return configureCompanyView(companyView: cellView, company: companies[row], shouldAddButtons: shouldAddButtons)
		}
	}
    
    
    func connectButtons(cellView: DbListView, row: Int) {
        cellView.firstButton.action = #selector(DbTableViewController.disclosureButtonPressed(sender:))
        cellView.firstButton.target = self
        cellView.secondButton.action = #selector(DbTableViewController.disclosureButtonPressed(sender:))
        cellView.secondButton.target = self
        cellView.thirdButton.action = #selector(DbTableViewController.disclosureButtonPressed(sender:))
        cellView.thirdButton.target = self
        cellView.editButton.action = #selector(DbTableViewController.editPressed(sender:))
        cellView.editButton.target = self
        cellView.deleteButton.action = #selector(DbTableViewController.deletePressed(sender:))
        cellView.deleteButton.target = self
        cellView.addButton.action = #selector(DbTableViewController.addPressed(sender:))
        cellView.addButton.target = self
        cellView.addShipmentButton.action = #selector(DbTableViewController.addPressed(sender:))
        cellView.addShipmentButton.target = self
        cellView.addDocButton.action = #selector(DbTableViewController.addPressed(sender:))
        cellView.addDocButton.target = self
        
        cellView.editButton.type = type
        cellView.addButton.type = type
        cellView.deleteButton.type = type
        cellView.addShipmentButton.type = type
        cellView.addDocButton.type = type
        cellView.deleteButton.isHidden = false
        cellView.addButton.isHidden = false
        cellView.addButton.isEnabled = true
        cellView.addShipmentButton.isHidden = true
        cellView.addDocButton.isHidden = true
        cellView.addShipmentButton.isEnabled = true
        cellView.addDocButton.title = "Dodaj dokument"
        cellView.addDocButton.isEnabled = true
        
        switch type! {
        case .Item:
            cellView.editButton.item = items[row]
            cellView.addButton.item = items[row]
            cellView.deleteButton.item = items[row]
        case .Document:
            cellView.editButton.doc = docs[row]
            cellView.addButton.doc = docs[row]
            cellView.deleteButton.doc = docs[row]
            cellView.addDocButton.doc = docs[row]
            cellView.addButton.subType = Tables.Unit
            cellView.addDocButton.isHidden = false
            cellView.addDocButton.title = "Dodaj preth. dokument"
            if docs[row].docBefore == nil {
                cellView.addDocButton.subType = Tables.Document
                cellView.addDocButton.isEnabled = true
            } else {
                cellView.addDocButton.isEnabled = false
            }
        case .Country:
            cellView.editButton.country = countries[row]
            cellView.addButton.country = countries[row]
            cellView.deleteButton.country = countries[row]
            cellView.addButton.subType = Tables.Place
        case .Place:
            cellView.editButton.place = places[row]
            cellView.addButton.place = places[row]
            cellView.deleteButton.place = places[row]
            cellView.addButton.isHidden = true
            if let parentVC = parent as? DbConnectViewController {
                if parentVC.dbTableVC1.type == Tables.Person || parentVC.dbTableVC1.type == Tables.Company {
                    cellView.deleteButton.subType = Tables.Partner
                }
            }
        case .Person:
            cellView.editButton.person = people[row]
            cellView.addButton.person = people[row]
            cellView.deleteButton.person = people[row]
            cellView.addShipmentButton.person = people[row]
            cellView.addDocButton.person = people[row]
            if people[row].partnerAddressId == nil {
                cellView.addButton.subType = Tables.Place
            } else {
                cellView.addButton.isEnabled = false
            }
            if people[row].shipmentAddressId == nil {
                cellView.addShipmentButton.subType = Tables.Place
                cellView.addShipmentButton.shipment = true
            } else {
                cellView.addShipmentButton.isEnabled = false
                cellView.addShipmentButton.shipment = false
            }
            cellView.addShipmentButton.isHidden = false
        case .Partner:
            cellView.editButton.partner = partners[row]
            cellView.addButton.partner = partners[row]
            cellView.deleteButton.partner = partners[row]
        case .Unit:
            cellView.editButton.unit = units[row]
            cellView.addButton.unit = units[row]
            cellView.deleteButton.unit = units[row]
            cellView.addButton.isHidden = true
        case .Company:
            cellView.editButton.company = companies[row]
            cellView.addButton.company = companies[row]
            cellView.deleteButton.company = companies[row]
            cellView.addShipmentButton.company = companies[row]
            cellView.addDocButton.company = companies[row]
            if companies[row].partnerAddressId == nil {
                cellView.addButton.subType = Tables.Place
            } else {
                cellView.addButton.isEnabled = false
            }
            if companies[row].shipmentAddressId == nil {
                cellView.addShipmentButton.subType = Tables.Place
                cellView.addShipmentButton.shipment = true
            } else {
                cellView.addShipmentButton.isEnabled = false
                cellView.addShipmentButton.shipment = false
            }
            cellView.addShipmentButton.isHidden = false
        }
    }
    
    
    func connectItemButtons(itemView: DbItemView, row: Int) {
        itemView.disclosureButton.action = #selector(DbTableViewController.disclosureButtonPressed(sender:))
        itemView.disclosureButton.target = self
        itemView.editButton.action = #selector(DbTableViewController.editPressed(sender:))
        itemView.editButton.target = self
        itemView.deleteButton.action = #selector(DbTableViewController.deletePressed(sender:))
        itemView.deleteButton.target = self
        itemView.addButton.action = #selector(DbTableViewController.addPressed(sender:))
        itemView.addButton.target = self
        
        itemView.editButton.type = type
        itemView.deleteButton.type = type
        itemView.addButton.type = type
        
        switch type! {
        case .Item:
            itemView.editButton.item = items[row]
            itemView.addButton.item = items[row]
            itemView.deleteButton.item = items[row]
        case .Document:
            itemView.editButton.doc = docs[row]
            itemView.addButton.doc = docs[row]
            itemView.deleteButton.doc = docs[row]
        case .Country:
            itemView.editButton.country = countries[row]
            itemView.addButton.country = countries[row]
            itemView.deleteButton.country = countries[row]
        case .Place:
            itemView.editButton.place = places[row]
            itemView.addButton.place = places[row]
            itemView.deleteButton.place = places[row]
        case .Person:
            itemView.editButton.person = people[row]
            itemView.addButton.person = people[row]
            itemView.deleteButton.person = people[row]
        case .Partner:
            itemView.editButton.partner = partners[row]
            itemView.addButton.partner = partners[row]
            itemView.deleteButton.partner = partners[row]
        case .Unit:
            itemView.editButton.unit = units[row]
            itemView.addButton.unit = units[row]
            itemView.deleteButton.unit = units[row]
        case .Company:
            itemView.editButton.company = companies[row]
            itemView.addButton.company = companies[row]
            itemView.deleteButton.company = companies[row]
        }
    }
	
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		switch type! {
		case .Item:
			return items.count < currentOffset ? items.count : currentOffset
		case .Document:
			return docs.count < currentOffset ? docs.count : currentOffset
		case .Country:
			return countries.count < currentOffset ? countries.count : currentOffset
		case .Place:
			return places.count < currentOffset ? places.count : currentOffset
		case .Person:
			return people.count < currentOffset ? people.count : currentOffset
		case .Partner:
			return partners.count < currentOffset ? partners.count : currentOffset
		case .Unit:
			return units.count < currentOffset ? units.count : currentOffset
		case .Company:
			return companies.count < currentOffset ? companies.count : currentOffset
		}
	}
	
	
	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		
        return true
		
	}
	
	
	func tableView(_ tableView: NSTableView, didAdd rowView: NSTableRowView, forRow row: Int) {
		if row > currentOffset - offset/2 {
			currentOffset = currentOffset + offset
			tableView.reloadData()
		}
	}
    
	
	@IBAction func goBack(_ sender: NSButton) {
		guard let parentVC = parent as? DbConnectViewController else {
			return
		}
		
		makeDirectionalAnimation(parentLeadingConstant: 0, dbTableVC2OriginX: parentVC.childView.frame.size.width, backButtonHidden: true, button: nil)
	}
	
	
	func disclosureButtonPressed(sender: DisclosureButton) {
		guard let parentVC = parent as? DbConnectViewController else {
			return
		}
		
		makeDirectionalAnimation(parentLeadingConstant: -parentVC.tableView.frame.size.width, dbTableVC2OriginX: self.view.window!.frame.size.width/2, backButtonHidden: false, button: sender)
	}
    
    
    func editPressed(sender: EditButton) {
        let modalStoryboard = NSStoryboard(name: "Modal", bundle: nil)
        let editVC = modalStoryboard.instantiateController(withIdentifier: "EditViewController") as! EditViewController
        editVC.originButton = sender
        editVC.connectVC = parent as! DbConnectViewController
        presentViewControllerAsModalWindow(editVC)
    }
    
    
    func deletePressed(sender: EditButton) {
        let modalStoryboard = NSStoryboard(name: "Modal", bundle: nil)
        let confirmVC = modalStoryboard.instantiateController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        confirmVC.originButton = sender
        confirmVC.connectVC = parent as! DbConnectViewController
        confirmVC.partnerId = partnerId
        confirmVC.shipment = shipment
        presentViewControllerAsModalWindow(confirmVC)
    }
    
    
    func addPressed(sender: EditButton) {
        let modalStoryboard = NSStoryboard(name: "Modal", bundle: nil)
        let editVC = modalStoryboard.instantiateController(withIdentifier: "EditViewController") as! EditViewController
        editVC.originButton = sender
        editVC.connectVC = parent as! DbConnectViewController
        presentViewControllerAsModalWindow(editVC)
    }
	
	
	func makeDirectionalAnimation(parentLeadingConstant: CGFloat, dbTableVC2OriginX: CGFloat, backButtonHidden: Bool, button: DisclosureButton?) {
		guard let parentVC = parent as? DbConnectViewController else {
			return
		}
		
		view.layoutSubtreeIfNeeded()
		parentVC.tableViewLeading.constant = parentLeadingConstant
		
		NSAnimationContext.runAnimationGroup({ [weak self] (context) in
			guard let `self` = self else { return }
			context.duration = 0.25
			context.allowsImplicitAnimation = true
			parentVC.view.updateConstraints()
			parentVC.view.layoutSubtreeIfNeeded()
			parentVC.dbTableVC2.view.frame.origin.x = dbTableVC2OriginX
			if backButtonHidden {
				self.view.frame.size.width = self.view.window!.frame.size.width - 300
			} else {
				self.view.frame.size.width = self.view.window!.frame.size.width/2
			}
			self.backButton.isHidden = backButtonHidden
			}, completionHandler: { [weak self] in
				
				self?.populateDbTableVC2(button: button, parentVC: parentVC)
				
				if backButtonHidden {
					self?.emptyDbTableVC2(parentVC: parentVC)
				}
		})
	}
	
	
	func populateDbTableVC2(button: DisclosureButton?, parentVC: DbConnectViewController) {
		if let disclosureButton = button {
			switch disclosureButton.type! {
			case .Item:
				parentVC.dbTableVC2.items = disclosureButton.items
			case .Document:
				parentVC.dbTableVC2.docs =  disclosureButton.docs
			case .Country:
				parentVC.dbTableVC2.countries =  disclosureButton.countries
			case .Place:
				parentVC.dbTableVC2.places =  disclosureButton.places
			case .Person:
				parentVC.dbTableVC2.people =  disclosureButton.people
			case .Partner:
				parentVC.dbTableVC2.partners =  disclosureButton.partners
			case .Unit:
				parentVC.dbTableVC2.units =  disclosureButton.units
			case .Company:
				parentVC.dbTableVC2.companies =  disclosureButton.companies
			}
			
			parentVC.dbTableVC2.tableView.tableColumns.first?.title = disclosureButton.type.rawValue
			parentVC.dbTableVC2.type = disclosureButton.type
			parentVC.dbTableVC2.tableView.reloadData()
            parentVC.dbTableVC2.partnerId = disclosureButton.partnerId
            parentVC.dbTableVC2.shipment = disclosureButton.shipment
		}
	}
	
	
	func emptyDbTableVC2(parentVC: DbConnectViewController) {
		
		parentVC.dbTableVC2.items = []
		parentVC.dbTableVC2.docs = []
		parentVC.dbTableVC2.countries = []
		parentVC.dbTableVC2.places = []
		parentVC.dbTableVC2.people = []
		parentVC.dbTableVC2.partners = []
		parentVC.dbTableVC2.units = []
		parentVC.dbTableVC2.companies = []
		
		parentVC.dbTableVC2.currentOffset = 20
		parentVC.dbTableVC2.tableView.reloadData()
        parentVC.dbTableVC2.partnerId = nil
        parentVC.dbTableVC2.shipment = nil
	}
    
    
    func addNew() {
        let modalStoryboard = NSStoryboard(name: "Modal", bundle: nil)
        let editVC = modalStoryboard.instantiateController(withIdentifier: "EditViewController") as! EditViewController
        let fakeButton = EditButton()
        fakeButton.type = type
        editVC.originButton = fakeButton
        editVC.connectVC = parent as! DbConnectViewController
        presentViewControllerAsModalWindow(editVC)
    }
    
    
    func addNewDoc() {
        let modalStoryboard = NSStoryboard(name: "Modal", bundle: nil)
        let chooseVC = modalStoryboard.instantiateController(withIdentifier: "ChooseViewController") as! ChooseViewController
        let fakeButton = EditButton()
        fakeButton.type = type
        chooseVC.originButton = fakeButton
        chooseVC.connectVC = parent as! DbConnectViewController
        presentViewControllerAsModalWindow(chooseVC)
    }
    
    func toggleAddButton(button: NSButton, hidden: Bool) {
        button.isHidden = hidden
    }
    
    func configureItemView(itemView: DbItemView, item: Item, shouldAddButtons: Bool) -> DbItemView {
        
        itemView.codeLabel.addAttributedString(Item.Attributes.code, dataString: item.code?.description)
        itemView.descLabel.addAttributedString(Item.Attributes.text, dataString: item.text)
        itemView.priceLabel.addAttributedString(Item.Attributes.price, dataString: item.price?.description)
        itemView.unitLabel.addAttributedString(Item.Attributes.measUnit, dataString: item.measUnit)
        itemView.ZULabel.addAttributedString(Item.Attributes.secU, dataString: item.secU?.description)
        itemView.nameLabel.addAttributedString(Item.Attributes.name, dataString: item.name)
        
        itemView.itemImageView.image = NSImage(named: "placeholder")
        if let imageData = item.image {
            if let image = NSImage(data: imageData), image.isValid {
                itemView.itemImageView.image = image
            }
        }
        
        itemView.disclosureButton.isHidden = true
        itemView.addButton.isHidden = true
        
        return itemView
    }
    
    
    func configureDocumentView(docView: DbListView, doc: Document, shouldAddButtons: Bool, shouldHideDelete: Bool) -> DbListView {
        
        unhideAllLabels(cellView: docView)
        unhideAllButtons(cellView: docView)
        docView.addButton.isHidden = false
        docView.addDocButton.isHidden = false
        
        docView.firstLabel.addAttributedString(Document.Attributes.docId, dataString: doc.docId?.description)
        docView.secondLabel.addAttributedString(Document.Attributes.docNumber, dataString: doc.docNumber?.description)
        docView.thirdLabel.addAttributedString(Document.Attributes.docDate, dataString: doc.docDate?.inLocalRegion().string(dateStyle: .medium, timeStyle: .short))
        docView.fourthLabel.addAttributedString(Document.Attributes.docValue, dataString: doc.docValue?.description)
        docView.fifthLabel.addAttributedString(Document.Attributes.docVr, dataString: doc.docVr)
        docView.sixthLabel.addAttributedString(Document.Attributes.tax, dataString: doc.tax?.description)
        docView.seventhLabel.isHidden = true
        docView.eighthLabel.isHidden = true
        docView.addButton.title = "Dodaj stavku"
        docView.addButtonWidth.constant = 100
        
        if shouldAddButtons {
            if let partner = doc.partner {
                docView.firstButton.isEnabled = true
                docView.firstButton.image = NSImage(named: NSImageNameGoRightTemplate)
                if let company = partner as? Company {
                    docView.firstButton.title = Tables.Partner.rawValue
                    docView.firstButton.type = Tables.Company
                    docView.firstButton.companies = [company]
                }
                if let person = partner as? Person {
                    docView.firstButton.title = Tables.Partner.rawValue
                    docView.firstButton.type = Tables.Person
                    docView.firstButton.people = [person]
                }
            } else {
                docView.firstButton.isHidden = true
            }
            if doc.units.count != 0 {
                docView.secondButton.title = TablePlurals.Units.rawValue
                docView.secondButton.type = Tables.Unit
                docView.secondButton.units = doc.units
                docView.secondButton.isEnabled = true
                docView.secondButton.image = NSImage(named: NSImageNameGoRightTemplate)
            } else {
                docView.secondButton.title = "Nema stavaka"
                docView.secondButton.isEnabled = false
                docView.secondButton.image = nil
            }
            if let docBefore = doc.docBefore {
                docView.thirdButton.title = DocBefore.Doc.rawValue
                docView.thirdButton.type = Tables.Document
                docView.thirdButton.docs = [docBefore]
                docView.thirdButton.isEnabled = true
                docView.thirdButton.image = NSImage(named: NSImageNameGoRightTemplate)
            } else {
                docView.thirdButton.title = "Nema prethodnog dokumenta"
                docView.thirdButton.isEnabled = false
                docView.thirdButton.image = nil
            }
        } else {
            hideAllButtons(cellView: docView)
            docView.addButton.isHidden = true
            docView.addDocButton.isHidden = true
            if shouldHideDelete {
                docView.deleteButton.isHidden = true
            }
        }
        
        return docView
    }
    
    
    func configureCountryView(countryView: DbListView, country: Country,shouldAddButtons: Bool) -> DbListView {
        
        unhideAllLabels(cellView: countryView)
        unhideAllButtons(cellView: countryView)
        
        countryView.firstLabel.addAttributedString(Country.Attributes.name, dataString: country.name)
        countryView.secondLabel.addAttributedString(Country.Attributes.code, dataString: country.code?.description)
        countryView.thirdLabel.addAttributedString(Country.Attributes.mark, dataString: country.mark)
        countryView.fourthLabel.addAttributedString(Country.Attributes.iso3, dataString: country.iso3)
        countryView.fifthLabel.isHidden = true
        countryView.sixthLabel.isHidden = true
        countryView.seventhLabel.isHidden = true
        countryView.eighthLabel.isHidden = true
        
        countryView.addButton.title = "Dodaj mjesto"
        countryView.addButtonWidth.constant = 100
        
        if shouldAddButtons {
            if country.places.count != 0 {
                countryView.firstButton.title = TablePlurals.Places.rawValue
                countryView.firstButton.type = Tables.Place
                countryView.firstButton.places = country.places
                countryView.firstButton.isEnabled = true
                countryView.firstButton.image = NSImage(named: NSImageNameGoRightTemplate)
            } else {
                countryView.firstButton.isEnabled = false
                countryView.firstButton.image = nil
                countryView.firstButton.title = "Nema mjesta"
            }
            countryView.secondButton.isHidden = true
            countryView.thirdButton.isHidden = true
        } else {
            hideAllButtons(cellView: countryView)
        }
        
        return countryView
    }
    
    
    func configurePersonView(personView: DbListView, person: Person,shouldAddButtons: Bool) -> DbListView {
        
        unhideAllLabels(cellView: personView)
        unhideAllButtons(cellView: personView)
        
        personView.firstButton.partnerId = nil
        personView.firstButton.shipment = nil
        personView.secondButton.partnerId = nil
        personView.secondButton.shipment = nil
        
        personView.firstLabel.addAttributedString(Person.PersonAttributes.firstName, dataString: person.firstName)
        personView.secondLabel.addAttributedString(Person.PersonAttributes.lastName, dataString: person.lastName)
        personView.thirdLabel.addAttributedString(Person.PersonAttributes.id, dataString: person.id?.description)
        personView.fourthLabel.addAttributedString(Person.Attributes.oib, dataString: person.oib)
        personView.fifthLabel.addAttributedString(Person.Attributes.partnerAddress, dataString: person.partnerAddress)
        personView.sixthLabel.addAttributedString(Person.Attributes.shipmentAddress, dataString: person.shipmentAddress)
        personView.addButton.title = "Dodaj mjesto partnera"
        personView.addButtonWidth.constant = 155
        
        if shouldAddButtons {
            if let partnerPlace = person.partnerPlace {
                personView.firstButton.title = Places.PartnerPlace.rawValue
                personView.firstButton.type = Tables.Place
                personView.firstButton.places = [partnerPlace]
                personView.firstButton.isEnabled = true
                personView.firstButton.image = NSImage(named: NSImageNameGoRightTemplate)
                personView.firstButton.partnerId = person.id
                personView.firstButton.shipment = false
            } else {
                personView.firstButton.isEnabled = false
                personView.firstButton.image = nil
                personView.firstButton.title = "Nema mjesta partnera"
            }
            if let shipmentPlace = person.shipmentPlace {
                personView.secondButton.title = Places.ShipmentPlace.rawValue
                personView.secondButton.type = Tables.Place
                personView.secondButton.places = [shipmentPlace]
                personView.secondButton.isEnabled = true
                personView.secondButton.image = NSImage(named: NSImageNameGoRightTemplate)
                personView.secondButton.partnerId = person.id
                personView.secondButton.shipment = true
            } else {
                personView.secondButton.isEnabled = false
                personView.secondButton.image = nil
                personView.secondButton.title = "Nema mjesta isporuke"
            }
            if person.docs.count != 0 {
                personView.thirdButton.title = TablePlurals.Documents.rawValue
                personView.thirdButton.type = Tables.Document
                personView.thirdButton.docs = person.docs
                personView.thirdButton.isEnabled = true
                personView.thirdButton.image = NSImage(named: NSImageNameGoRightTemplate)
            } else {
                personView.thirdButton.isEnabled = false
                personView.thirdButton.image = nil
                personView.thirdButton.title = "Nema dokumenata"
            }
        } else {
            hideAllButtons(cellView: personView)
            personView.addButton.isHidden = true
            personView.addDocButton.isHidden = true
            personView.addShipmentButton.isHidden = true
            personView.deleteButton.isHidden = true
        }
        
        personView.seventhLabel.isHidden = true
        personView.eighthLabel.isHidden = true
        
        return personView
    }
    
    
    func configurePlaceView(placeView: DbListView, place: Place, shouldAddButtons: Bool) -> DbListView {
        
        unhideAllLabels(cellView: placeView)
        unhideAllButtons(cellView: placeView)
        
        placeView.firstLabel.addAttributedString(Place.Attributes.name, dataString: place.name)
        placeView.secondLabel.addAttributedString(Place.Attributes.countryCode, dataString: place.countryCode)
        placeView.fourthLabel.addAttributedString(Place.Attributes.postalCode, dataString: place.postalCode?.description)
        placeView.fifthLabel.addAttributedString(Place.Attributes.postalName, dataString: place.postalName)
        placeView.sixthLabel.isHidden = true
        placeView.seventhLabel.isHidden = true
        placeView.eighthLabel.isHidden = true
        placeView.thirdLabel.isHidden = true
        placeView.secondLabel.isHidden = true
        
        if shouldAddButtons {
            if let country = place.country {
                placeView.firstButton.title = Tables.Country.rawValue
                placeView.firstButton.type = Tables.Country
                placeView.firstButton.countries = [country]
            } else {
                placeView.firstButton.isHidden = true
            }
            placeView.secondButton.isHidden = true
            placeView.thirdButton.isHidden = true
        } else {
            hideAllButtons(cellView: placeView)
        }
        
        return placeView
    }
    
    
    func configurePartnerView(partnerView: DbListView, partner: Partner, shouldAddButtons: Bool) -> DbListView {
        
        unhideAllLabels(cellView: partnerView)
        unhideAllButtons(cellView: partnerView)
        
        partnerView.firstLabel.addAttributedString(Partner.Attributes.partnerAddress, dataString: partner.partnerAddress)
        partnerView.secondLabel.addAttributedString(Partner.Attributes.partnerAddressId, dataString: partner.partnerAddressId?.description)
        partnerView.thirdLabel.addAttributedString(Partner.Attributes.shipmentAddress, dataString: partner.shipmentAddress)
        partnerView.fourthLabel.addAttributedString(Partner.Attributes.shipmentAddressId, dataString: partner.shipmentAddressId?.description)
        partnerView.fifthLabel.addAttributedString(Partner.Attributes.oib, dataString: partner.oib)
        partnerView.sixthLabel.addAttributedString(Partner.Attributes.type, dataString: partner.type)
        partnerView.seventhLabel.addAttributedString(Partner.Attributes.partnerId, dataString: partner.partnerId?.description)
        partnerView.eighthLabel.isHidden = true
        
        if shouldAddButtons {
            if let partnerPlace = partner.partnerPlace {
                partnerView.firstButton.title = Places.PartnerPlace.rawValue
                partnerView.firstButton.type = Tables.Place
                partnerView.firstButton.places = [partnerPlace]
            } else {
                partnerView.firstButton.isHidden = true
            }
            if let shipmentPlace = partner.shipmentPlace {
                partnerView.secondButton.title = Places.ShipmentPlace.rawValue
                partnerView.secondButton.type = Tables.Place
                partnerView.secondButton.places = [shipmentPlace]
            } else {
                partnerView.secondButton.isHidden = true
            }
            if partner.docs.count != 0 {
                partnerView.thirdButton.title = TablePlurals.Documents.rawValue
                partnerView.thirdButton.type = Tables.Document
                partnerView.thirdButton.docs = partner.docs
            } else {
                partnerView.thirdButton.isHidden = true
            }
        } else {
            hideAllButtons(cellView: partnerView)
        }
        
        return partnerView
    }
    
    
    func configureUnitView(unitView: DbListView, unit: Unit, shouldAddButtons: Bool) -> DbListView {
        
        unhideAllLabels(cellView: unitView)
        unhideAllButtons(cellView: unitView)
        
        unitView.secondLabel.addAttributedString(Unit.Attributes.unitId, dataString: unit.unitId?.description)
        unitView.thirdLabel.addAttributedString(Unit.Attributes.itemPrice, dataString: unit.itemPrice?.description)
        unitView.fourthLabel.addAttributedString(Unit.Attributes.itemQuantity, dataString: unit.itemQuantity?.description)
        unitView.fifthLabel.addAttributedString(Unit.Attributes.itemCode, dataString: unit.itemCode?.description)
        unitView.sixthLabel.addAttributedString(Unit.Attributes.discount, dataString: unit.discount?.description)
        unitView.seventhLabel.isHidden = true
        unitView.eighthLabel.isHidden = true
        
        if shouldAddButtons {
            if let doc = unit.document {
                unitView.firstButton.title = Tables.Document.rawValue
                unitView.firstButton.type = Tables.Document
                unitView.firstButton.docs = [doc]
            } else {
                unitView.firstButton.isHidden = true
            }
            if let item = unit.item {
                unitView.secondButton.title = Tables.Item.rawValue
                unitView.secondButton.type = Tables.Item
                unitView.secondButton.items = [item]
            } else {
                unitView.secondButton.isHidden = true
            }
            unitView.thirdButton.isHidden = true
        } else {
            hideAllButtons(cellView: unitView)
        }
        
        unitView.firstLabel.isHidden = true
        
        return unitView
    }
    
    
    func configureCompanyView(companyView: DbListView, company: Company, shouldAddButtons: Bool) -> DbListView {
        
        unhideAllLabels(cellView: companyView)
        unhideAllButtons(cellView: companyView)
        
        companyView.firstButton.partnerId = nil
        companyView.firstButton.shipment = nil
        companyView.secondButton.partnerId = nil
        companyView.secondButton.shipment = nil
        
        companyView.firstLabel.addAttributedString(Company.CompanyAttributes.companyId, dataString: company.companyId?.description)
        companyView.secondLabel.addAttributedString(Company.CompanyAttributes.name, dataString: company.name)
        companyView.thirdLabel.addAttributedString(Company.CompanyAttributes.registryNumber, dataString: company.registryNumber)
        companyView.fourthLabel.addAttributedString(Company.Attributes.oib, dataString: company.oib)
        companyView.fifthLabel.addAttributedString(Company.Attributes.partnerAddress, dataString: company.partnerAddress)
        companyView.sixthLabel.addAttributedString(Company.Attributes.shipmentAddress, dataString: company.shipmentAddress)
        companyView.addButton.title = "Dodaj mjesto partnera"
        companyView.addButtonWidth.constant = 155
        
        if shouldAddButtons {
            if let partnerPlace = company.partnerPlace {
                companyView.firstButton.title = Places.PartnerPlace.rawValue
                companyView.firstButton.type = Tables.Place
                companyView.firstButton.places = [partnerPlace]
                companyView.firstButton.isEnabled = true
                companyView.firstButton.image = NSImage(named: NSImageNameGoRightTemplate)
                companyView.firstButton.partnerId = company.companyId
                companyView.firstButton.shipment = false
            } else {
                companyView.firstButton.isEnabled = false
                companyView.firstButton.image = nil
                companyView.firstButton.title = "Nema mjesta partnera"
            }
            if let shipmentPlace = company.shipmentPlace {
                companyView.secondButton.title = Places.ShipmentPlace.rawValue
                companyView.secondButton.type = Tables.Place
                companyView.secondButton.places = [shipmentPlace]
                companyView.secondButton.isEnabled = true
                companyView.secondButton.image = NSImage(named: NSImageNameGoRightTemplate)
                companyView.secondButton.partnerId = company.companyId
                companyView.secondButton.shipment = true
            } else {
                companyView.secondButton.isEnabled = false
                companyView.secondButton.image = nil
                companyView.secondButton.title = "Nema mjesta isporuke"
            }
            if company.docs.count != 0 {
                companyView.thirdButton.title = TablePlurals.Documents.rawValue
                companyView.thirdButton.type = Tables.Document
                companyView.thirdButton.docs = company.docs
                companyView.thirdButton.isEnabled = true
                companyView.thirdButton.image = NSImage(named: NSImageNameGoRightTemplate)
            } else {
                companyView.thirdButton.isEnabled = false
                companyView.thirdButton.image = nil
                companyView.thirdButton.title = "Nema dokumenata"
            }
        } else {
            hideAllButtons(cellView: companyView)
            companyView.addButton.isHidden = true
            companyView.addDocButton.isHidden = true
            companyView.addShipmentButton.isHidden = true
            companyView.deleteButton.isHidden = true
        }
        
        companyView.seventhLabel.isHidden = true
        companyView.eighthLabel.isHidden = true
        
        return companyView
    }
    
    
    func unhideAllLabels(cellView: DbListView) {
        cellView.firstLabel.isHidden = false
        cellView.secondLabel.isHidden = false
        cellView.thirdLabel.isHidden = false
        cellView.fourthLabel.isHidden = false
        cellView.fifthLabel.isHidden = false
        cellView.sixthLabel.isHidden = false
        cellView.seventhLabel.isHidden = false
        cellView.eighthLabel.isHidden = false
    }
    
    
    func unhideAllButtons(cellView: DbListView) {
        cellView.firstButton.isHidden = false
        cellView.secondButton.isHidden = false
        cellView.thirdButton.isHidden = false
    }
    
    
    func hideAllButtons(cellView: DbListView) {
        cellView.firstButton.isHidden = true
        cellView.secondButton.isHidden = true
        cellView.thirdButton.isHidden = true
    }
	
}
