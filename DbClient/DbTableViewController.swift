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
	}
	
	
	func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
		switch type! {
		case .Item:
			return 220
		case .Document:
			return 280
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
}
