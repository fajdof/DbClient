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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.dataSource = self
		tableView.delegate = self
		tableView.register(NSNib(nibNamed: dbItemView, bundle: nil), forIdentifier: dbItemView)
		tableView.register(NSNib(nibNamed: dbListView, bundle: nil), forIdentifier: dbListView)
		backButton.isHidden = true
	}
	
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		switch type! {
		case .Item:
			return 220
		case .Document:
			return 300
		case .Country:
			return 120
		case .Place:
			return 180
		case .Person:
			return 260
		case .Partner:
			return 200
		case .Unit:
			return 180
		case .Company:
			return 280
		}
	}
	
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cellView = tableView.make(withIdentifier: dbListView, owner: self) as! DbListView
		
		cellView.firstButton.action = #selector(DbTableViewController.disclosureButtonPressed(sender:))
		cellView.firstButton.target = self
		cellView.secondButton.action = #selector(DbTableViewController.disclosureButtonPressed(sender:))
		cellView.secondButton.target = self
		cellView.thirdButton.action = #selector(DbTableViewController.disclosureButtonPressed(sender:))
		cellView.thirdButton.target = self
		
		switch type! {
		case .Item:
			let itemView = tableView.make(withIdentifier: dbItemView, owner: self) as! DbItemView
			return presenter.configureItemView(itemView: itemView, item: items[row])
		case .Document:
			return presenter.configureDocumentView(docView: cellView, doc: docs[row])
		case .Country:
			return presenter.configureCountryView(countryView: cellView, country: countries[row])
		case .Place:
			return presenter.configurePlaceView(placeView: cellView, place: places[row])
		case .Person:
			return presenter.configurePersonView(personView: cellView, person: people[row])
		case .Partner:
			return presenter.configurePartnerView(partnerView: cellView, partner: partners[row])
		case .Unit:
			return presenter.configureUnitView(unitView: cellView, unit: units[row])
		case .Company:
			return presenter.configureCompanyView(companyView: cellView, company: companies[row])
		}
	}
	
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		switch type! {
		case .Item:
			return items.count
		case .Document:
			return docs.count
		case .Country:
			return countries.count
		case .Place:
			return places.count
		case .Person:
			return people.count
		case .Partner:
			return partners.count
		case .Unit:
			return units.count
		case .Company:
			return companies.count
		}
	}
	
	
	func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
		
		guard let parentVC = parent as? DbConnectViewController else {
			return true
		}
		
		makeDirectionalAnimation(parentLeadingConstant: -parentVC.tableView.frame.size.width, dbTableVC2OriginX: parentVC.childView.frame.size.width/2, backButtonHidden: false, button: nil)
		
		return true
	}
	
	
	@IBAction func goBack(_ sender: NSButton) {
		guard let parentVC = parent as? DbConnectViewController else {
			return
		}
		
		makeDirectionalAnimation(parentLeadingConstant: 0, dbTableVC2OriginX: parentVC.childView.frame.size.width, backButtonHidden: true, button: nil)
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
			self.backButton.isHidden = backButtonHidden
			}, completionHandler: { [weak self] in
				guard let `self` = self else { return }
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
		})
	}
	
	
	func disclosureButtonPressed(sender: DisclosureButton) {
		guard let parentVC = parent as? DbConnectViewController else {
			return
		}
		
		makeDirectionalAnimation(parentLeadingConstant: -parentVC.tableView.frame.size.width, dbTableVC2OriginX: parentVC.childView.frame.size.width/2, backButtonHidden: false, button: sender)
	}
	
}
