//
//  DbTablePresenter.swift
//  DbClient
//
//  Created by Filip Fajdetic on 26/11/2016.
//  Copyright © 2016 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa


class DbTablePresenter {
	
	func configureItemView(itemView: DbItemView, item: Item) -> DbItemView {
		
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
	
	
	func configureDocumentView(docView: DbListView, doc: Document) -> DbListView {
		
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
	
	
	func configureCountryView(countryView: DbListView, country: Country) -> DbListView {
		
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
	
	
	func configurePersonView(personView: DbListView, person: Person) -> DbListView {
		
		unhideAllLabels(cellView: personView)
		personView.firstLabel.addAttributedString(Person.PersonAttributes.firstName, dataString: person.firstName)
		personView.secondLabel.addAttributedString(Person.PersonAttributes.lastName, dataString: person.lastName)
		personView.thirdLabel.addAttributedString(Person.PersonAttributes.id, dataString: person.id?.description)
		personView.fourthLabel.addAttributedString(Person.Attributes.oib, dataString: person.oib)
		personView.fifthLabel.addAttributedString(Person.Attributes.partnerAddress, dataString: person.partnerAddress)
		personView.sixthLabel.addAttributedString(Person.Attributes.partnerAddressId, dataString: person.partnerAddressId?.description)
		personView.seventhLabel.addAttributedString(Person.Attributes.shipmentAddress, dataString: person.shipmentAddress)
		personView.eighthLabel.addAttributedString(Person.Attributes.shipmentAddressId, dataString: person.shipmentAddressId?.description)
		
		return personView
	}
	
	
	func configurePlaceView(placeView: DbListView, place: Place) -> DbListView {
		
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
	
	
	func configurePartnerView(partnerView: DbListView, partner: Partner) -> DbListView {
		
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
	
	
	func configureUnitView(unitView: DbListView, unit: Unit) -> DbListView {
		
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
	
	
	func configureCompanyView(companyView: DbListView, company: Company) -> DbListView {
		
		unhideAllLabels(cellView: companyView)
		companyView.firstLabel.addAttributedString(Company.CompanyAttributes.companyId, dataString: company.companyId?.description)
		companyView.secondLabel.addAttributedString(Company.CompanyAttributes.name, dataString: company.name)
		companyView.thirdLabel.addAttributedString(Company.CompanyAttributes.registryNumber, dataString: company.registryNumber)
		companyView.fourthLabel.addAttributedString(Company.Attributes.oib, dataString: company.oib)
		companyView.fifthLabel.addAttributedString(Company.Attributes.partnerAddress, dataString: company.partnerAddress)
		companyView.sixthLabel.addAttributedString(Company.Attributes.partnerAddressId, dataString: company.partnerAddressId?.description)
		companyView.seventhLabel.addAttributedString(Company.Attributes.shipmentAddress, dataString: company.shipmentAddress)
		companyView.eighthLabel.addAttributedString(Company.Attributes.shipmentAddressId, dataString: company.shipmentAddressId?.description)
		
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
	
}
