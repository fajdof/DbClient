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
			return 100
		case .Partner:
			return 200
		case .Unit:
			return 180
		case .Company:
			return 120
		}
	}
	
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		let cellView = tableView.make(withIdentifier: dbListView, owner: self) as! DbListView
		
		switch type! {
		case .Item:
			let itemView = tableView.make(withIdentifier: dbItemView, owner: self) as! DbItemView
			return configureItemView(itemView: itemView, row: row)
		case .Document:
			return configureDocumentView(docView: cellView, row: row)
		case .Country:
			return configureCountryView(countryView: cellView, row: row)
		case .Place:
			return configurePlaceView(placeView: cellView, row: row)
		case .Person:
			return configurePersonView(personView: cellView, row: row)
		case .Partner:
			return configurePartnerView(partnerView: cellView, row: row)
		case .Unit:
			return configureUnitView(unitView: cellView, row: row)
		case .Company:
			return configureCompanyView(companyView: cellView, row: row)
		}
	}
	
	
	func configureItemView(itemView: DbItemView, row: Int) -> DbItemView {
		let item = items[row]
		
		itemView.codeLabel.addAttributedString(Item.Attributes.code, dataString: item.code?.description)
		itemView.descLabel.addAttributedString(Item.Attributes.text, dataString: item.text)
		itemView.priceLabel.addAttributedString(Item.Attributes.price, dataString: item.price?.description)
		itemView.unitLabel.addAttributedString(Item.Attributes.measUnit, dataString: item.measUnit)
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
	
	
	func configurePersonView(personView: DbListView, row: Int) -> DbListView {
		let person = people[row]
		
		unhideAllLabels(cellView: personView)
		personView.firstLabel.addAttributedString(Person.Attributes.firstName, dataString: person.firstName)
		personView.secondLabel.addAttributedString(Person.Attributes.lastName, dataString: person.lastName)
		personView.thirdLabel.addAttributedString(Person.Attributes.id, dataString: person.id?.description)
		personView.fourthLabel.isHidden = true
		personView.fifthLabel.isHidden = true
		personView.sixthLabel.isHidden = true
		personView.seventhLabel.isHidden = true
		personView.eighthLabel.isHidden = true
		
		return personView
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
	
	
	func configurePartnerView(partnerView: DbListView, row: Int) -> DbListView {
		let partner = partners[row]
		
		unhideAllLabels(cellView: partnerView)
		partnerView.firstLabel.addAttributedString(Partner.Attributes.partnerAddress, dataString: partner.partnerAddress)
		partnerView.secondLabel.addAttributedString(Partner.Attributes.partnerAddressId, dataString: partner.partnerAddressId?.description)
		partnerView.thirdLabel.addAttributedString(Partner.Attributes.shipmentAddress, dataString: partner.shipmentAddress)
		partnerView.fourthLabel.addAttributedString(Partner.Attributes.shipmentAddressId, dataString: partner.shipmentAddressId?.description)
		partnerView.fifthLabel.addAttributedString(Partner.Attributes.oib, dataString: partner.oib)
		partnerView.sixthLabel.addAttributedString(Partner.Attributes.type, dataString: partner.type)
		partnerView.seventhLabel.addAttributedString(Partner.Attributes.partnerId, dataString: partner.partnerId?.description)
		partnerView.eighthLabel.isHidden = true
		
		return partnerView
	}
	
	
	func configureUnitView(unitView: DbListView, row: Int) -> DbListView {
		let unit = units[row]
		
		unhideAllLabels(cellView: unitView)
		unitView.firstLabel.addAttributedString(Unit.Attributes.docId, dataString: unit.docId?.description)
		unitView.secondLabel.addAttributedString(Unit.Attributes.unitId, dataString: unit.unitId?.description)
		unitView.thirdLabel.addAttributedString(Unit.Attributes.itemPrice, dataString: unit.itemPrice?.description)
		unitView.fourthLabel.addAttributedString(Unit.Attributes.itemQuantity, dataString: unit.itemQuantity?.description)
		unitView.fifthLabel.addAttributedString(Unit.Attributes.itemCode, dataString: unit.itemCode?.description)
		unitView.sixthLabel.addAttributedString(Unit.Attributes.discount, dataString: unit.discount?.description)
		unitView.seventhLabel.isHidden = true
		unitView.eighthLabel.isHidden = true
		
		return unitView
	}
	
	
	func configureCompanyView(companyView: DbListView, row: Int) -> DbListView {
		let company = companies[row]
		
		unhideAllLabels(cellView: companyView)
		companyView.firstLabel.addAttributedString(Company.Attributes.companyId, dataString: company.companyId?.description)
		companyView.secondLabel.addAttributedString(Company.Attributes.name, dataString: company.name)
		companyView.thirdLabel.addAttributedString(Company.Attributes.registryNumber, dataString: company.registryNumber)
		companyView.fourthLabel.isHidden = true
		companyView.fifthLabel.isHidden = true
		companyView.sixthLabel.isHidden = true
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
