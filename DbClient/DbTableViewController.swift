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
	let presenter = DbTablePresenter()
	
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
        
        presenter.toggleAddButton(button: addButton, hidden: true)
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
			return 240
		case .Document:
			return 300
		case .Country:
			return 150
		case .Place:
			return 220
		case .Person:
			return 300
		case .Partner:
			return 320
		case .Unit:
			return 240
		case .Company:
			return 300
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
			return presenter.configureItemView(itemView: itemView, item: items[row], shouldAddButtons: shouldAddButtons)
		case .Document:
			return presenter.configureDocumentView(docView: cellView, doc: docs[row], shouldAddButtons: shouldAddButtons)
		case .Country:
			return presenter.configureCountryView(countryView: cellView, country: countries[row], shouldAddButtons: shouldAddButtons)
		case .Place:
			return presenter.configurePlaceView(placeView: cellView, place: places[row], shouldAddButtons: shouldAddButtons)
		case .Person:
			return presenter.configurePersonView(personView: cellView, person: people[row], shouldAddButtons: shouldAddButtons)
		case .Partner:
			if let company = partners[row] as? Company {
				return presenter.configureCompanyView(companyView: cellView, company: company, shouldAddButtons: shouldAddButtons)
			}
			if let person = partners[row] as? Person {
				return presenter.configurePersonView(personView: cellView, person: person, shouldAddButtons: shouldAddButtons)
			}
			return presenter.configurePartnerView(partnerView: cellView, partner: partners[row], shouldAddButtons: shouldAddButtons)
		case .Unit:
			return presenter.configureUnitView(unitView: cellView, unit: units[row], shouldAddButtons: shouldAddButtons)
		case .Company:
			return presenter.configureCompanyView(companyView: cellView, company: companies[row], shouldAddButtons: shouldAddButtons)
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
        
        cellView.editButton.type = type
        cellView.addButton.type = type
        cellView.deleteButton.type = type
        
        switch type! {
        case .Item:
            cellView.editButton.item = items[row]
            cellView.addButton.item = items[row]
            cellView.deleteButton.item = items[row]
        case .Document:
            cellView.editButton.doc = docs[row]
            cellView.addButton.doc = docs[row]
            cellView.deleteButton.doc = docs[row]
        case .Country:
            cellView.editButton.country = countries[row]
            cellView.addButton.country = countries[row]
            cellView.deleteButton.country = countries[row]
            cellView.addButton.isHidden = true
        case .Place:
            cellView.editButton.place = places[row]
            cellView.addButton.place = places[row]
            cellView.deleteButton.place = places[row]
        case .Person:
            cellView.editButton.person = people[row]
            cellView.addButton.person = people[row]
            cellView.deleteButton.person = people[row]
        case .Partner:
            cellView.editButton.partner = partners[row]
            cellView.addButton.partner = partners[row]
            cellView.deleteButton.partner = partners[row]
        case .Unit:
            cellView.editButton.unit = units[row]
            cellView.addButton.unit = units[row]
            cellView.deleteButton.unit = units[row]
        case .Company:
            cellView.editButton.company = companies[row]
            cellView.addButton.company = companies[row]
            cellView.deleteButton.company = companies[row]
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
        presentViewControllerAsModalWindow(confirmVC)
    }
    
    
    func addPressed(sender: EditButton) {
        let modalStoryboard = NSStoryboard(name: "Modal", bundle: nil)
        let editVC = modalStoryboard.instantiateController(withIdentifier: "EditViewController") as! EditViewController
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
	
}
