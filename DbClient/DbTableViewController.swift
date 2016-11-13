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
	var users: [User] = []
	var places: [Place] = []
	var type: Tables! = Tables.Item
	
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
		case .User:
			return 80
		case .Place:
			return 180
		}
	}
	
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		switch type! {
		case .Item:
			let cellView = tableView.make(withIdentifier: dbItemView, owner: self) as! DbItemView
			return configureItemView(itemView: cellView, row: row)
		case .Document:
			let cellView = tableView.make(withIdentifier: dbListView, owner: self) as! DbListView
			return configureDocumentView(docView: cellView, row: row)
		case .Country:
			let cellView = tableView.make(withIdentifier: dbListView, owner: self) as! DbListView
			return configureCountryView(countryView: cellView, row: row)
		case .User:
			let cellView = tableView.make(withIdentifier: dbListView, owner: self) as! DbListView
			return configureUserView(userView: cellView, row: row)
		case .Place:
			let cellView = tableView.make(withIdentifier: dbListView, owner: self) as! DbListView
			return configurePlaceView(placeView: cellView, row: row)
		}
	}
	
	
	func configureItemView(itemView: DbItemView, row: Int) -> DbItemView {
		let item = items[row]
		
		itemView.codeLabel.addAttributedString(Item.Attributes.code, dataString: item.code?.description)
		itemView.descLabel.addAttributedString(Item.Attributes.text, dataString: item.text)
		itemView.priceLabel.addAttributedString(Item.Attributes.price, dataString: item.price?.description)
		itemView.unitLabel.addAttributedString(Item.Attributes.unit, dataString: item.unit)
		itemView.ZULabel.addAttributedString(Item.Attributes.secU, dataString: item.secU?.description)
		itemView.nameLabel.addAttributedString(Item.Attributes.name, dataString: item.name)
		if let imageData = item.image {
			itemView.itemImageView.image = NSImage(data: imageData)
		} else {
			itemView.itemImageView.image = nil
		}
		
		return itemView
	}
	
	
	func configureDocumentView(docView: DbListView, row: Int) -> DbListView {
		let doc = docs[row]
		
		unhideAllLabels(cellView: docView)
		docView.firstLabel.addAttributedString(Document.Attributes.docId, dataString: doc.docId?.description)
		docView.secondLabel.addAttributedString(Document.Attributes.docNumber, dataString: doc.docNumber?.description)
		docView.thirdLabel.addAttributedString(Document.Attributes.docDate, dataString: doc.docDate?.inLocalRegion().string(dateStyle: .medium, timeStyle: .short))
		docView.fourthLabel.addAttributedString(Document.Attributes.docValue, dataString: doc.docValue?.description)
		docView.fifthLabel.addAttributedString(Document.Attributes.docBeforeId, dataString: doc.docBeforeId?.description)
		docView.sixthLabel.addAttributedString(Document.Attributes.partnerId, dataString: doc.partnerId?.description)
		docView.seventhLabel.addAttributedString(Document.Attributes.docVr, dataString: doc.docVr)
		docView.eighthLabel.addAttributedString(Document.Attributes.tax, dataString: doc.tax?.description)
		
		return docView
	}
	
	
	func configureCountryView(countryView: DbListView, row: Int) -> DbListView {
		let country = countries[row]
		
		unhideAllLabels(cellView: countryView)
		countryView.firstLabel.addAttributedString(Country.Attributes.name, dataString: country.name)
		countryView.secondLabel.addAttributedString(Country.Attributes.code, dataString: country.code?.description)
		countryView.thirdLabel.addAttributedString(Country.Attributes.mark, dataString: country.mark)
		countryView.fourthLabel.addAttributedString(Country.Attributes.iso3, dataString: country.iso3)
		countryView.fifthLabel.isHidden = true
		countryView.sixthLabel.isHidden = true
		countryView.seventhLabel.isHidden = true
		countryView.eighthLabel.isHidden = true
		
		return countryView
	}
	
	
	func configureUserView(userView: DbListView, row: Int) -> DbListView {
		let user = users[row]
		
		unhideAllLabels(cellView: userView)
		userView.firstLabel.addAttributedString(User.Attributes.username, dataString: user.username)
		userView.secondLabel.addAttributedString(User.Attributes.password, dataString: user.password)
		userView.thirdLabel.isHidden = true
		userView.fourthLabel.isHidden = true
		userView.fifthLabel.isHidden = true
		userView.sixthLabel.isHidden = true
		userView.seventhLabel.isHidden = true
		userView.eighthLabel.isHidden = true
		
		return userView
	}
	
	
	func configurePlaceView(placeView: DbListView, row: Int) -> DbListView {
		let place = places[row]
		
		unhideAllLabels(cellView: placeView)
		placeView.firstLabel.addAttributedString(Place.Attributes.name, dataString: place.name)
		placeView.secondLabel.addAttributedString(Place.Attributes.countryCode, dataString: place.countryCode)
		placeView.thirdLabel.addAttributedString(Place.Attributes.id, dataString: place.id?.description)
		placeView.fourthLabel.addAttributedString(Place.Attributes.postalCode, dataString: place.postalCode?.description)
		placeView.fifthLabel.addAttributedString(Place.Attributes.postalName, dataString: place.postalName)
		placeView.sixthLabel.isHidden = true
		placeView.seventhLabel.isHidden = true
		placeView.eighthLabel.isHidden = true
		
		return placeView
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
	
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		switch type! {
		case .Item:
			return items.count
		case .Document:
			return docs.count
		case .Country:
			return countries.count
		case .User:
			return users.count
		case .Place:
			return places.count
		}
	}
}
