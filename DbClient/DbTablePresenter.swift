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
		if let imageData = item.image {
			itemView.itemImageView.image = NSImage(data: imageData)
		} else {
			itemView.itemImageView.image = nil
		}
		
        itemView.disclosureButton.isHidden = true
        itemView.addButton.isHidden = true
		
		return itemView
	}
	
	
	func configureDocumentView(docView: DbListView, doc: Document, shouldAddButtons: Bool) -> DbListView {
		
		unhideAllLabels(cellView: docView)
		unhideAllButtons(cellView: docView)
		
		docView.firstLabel.addAttributedString(Document.Attributes.docId, dataString: doc.docId?.description)
		docView.secondLabel.addAttributedString(Document.Attributes.docNumber, dataString: doc.docNumber?.description)
		docView.thirdLabel.addAttributedString(Document.Attributes.docDate, dataString: doc.docDate?.inLocalRegion().string(dateStyle: .medium, timeStyle: .short))
		docView.fourthLabel.addAttributedString(Document.Attributes.docValue, dataString: doc.docValue?.description)
		docView.fifthLabel.addAttributedString(Document.Attributes.docVr, dataString: doc.docVr)
		docView.sixthLabel.addAttributedString(Document.Attributes.tax, dataString: doc.tax?.description)
        docView.seventhLabel.isHidden = true
        docView.eighthLabel.isHidden = true
        docView.addButton.title = "Dodaj stavku"
		
		if shouldAddButtons {
			if let partner = doc.partner {
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
			} else {
				docView.secondButton.isHidden = true
			}
			if let docBefore = doc.docBefore {
				docView.thirdButton.title = DocBefore.Doc.rawValue
				docView.thirdButton.type = Tables.Document
				docView.thirdButton.docs = [docBefore]
			} else {
				docView.thirdButton.isHidden = true
			}
		} else {
			hideAllButtons(cellView: docView)
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
		
		if shouldAddButtons {
			if country.places.count != 0 {
				countryView.firstButton.title = TablePlurals.Places.rawValue
				countryView.firstButton.type = Tables.Place
				countryView.firstButton.places = country.places
			} else {
				countryView.firstButton.isHidden = true
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
		
		personView.firstLabel.addAttributedString(Person.PersonAttributes.firstName, dataString: person.firstName)
		personView.secondLabel.addAttributedString(Person.PersonAttributes.lastName, dataString: person.lastName)
		personView.thirdLabel.addAttributedString(Person.PersonAttributes.id, dataString: person.id?.description)
		personView.fourthLabel.addAttributedString(Person.Attributes.oib, dataString: person.oib)
		personView.fifthLabel.addAttributedString(Person.Attributes.partnerAddress, dataString: person.partnerAddress)
		personView.sixthLabel.addAttributedString(Person.Attributes.partnerAddressId, dataString: person.partnerAddressId?.description)
		personView.seventhLabel.addAttributedString(Person.Attributes.shipmentAddress, dataString: person.shipmentAddress)
		personView.eighthLabel.addAttributedString(Person.Attributes.shipmentAddressId, dataString: person.shipmentAddressId?.description)
		
		if shouldAddButtons {
			if let partnerPlace = person.partnerPlace {
				personView.firstButton.title = Places.PartnerPlace.rawValue
				personView.firstButton.type = Tables.Place
				personView.firstButton.places = [partnerPlace]
			} else {
				personView.firstButton.isHidden = true
			}
			if let shipmentPlace = person.shipmentPlace {
				personView.secondButton.title = Places.ShipmentPlace.rawValue
				personView.secondButton.type = Tables.Place
				personView.secondButton.places = [shipmentPlace]
			} else {
				personView.secondButton.isHidden = true
			}
			if person.docs.count != 0 {
				personView.thirdButton.title = TablePlurals.Documents.rawValue
				personView.thirdButton.type = Tables.Document
				personView.thirdButton.docs = person.docs
			} else {
				personView.thirdButton.isHidden = true
			}
		} else {
			hideAllButtons(cellView: personView)
		}
		
		return personView
	}
	
	
	func configurePlaceView(placeView: DbListView, place: Place, shouldAddButtons: Bool) -> DbListView {
		
		unhideAllLabels(cellView: placeView)
		unhideAllButtons(cellView: placeView)
		
		placeView.firstLabel.addAttributedString(Place.Attributes.name, dataString: place.name)
		placeView.secondLabel.addAttributedString(Place.Attributes.countryCode, dataString: place.countryCode)
		placeView.thirdLabel.addAttributedString(Place.Attributes.id, dataString: place.id?.description)
		placeView.fourthLabel.addAttributedString(Place.Attributes.postalCode, dataString: place.postalCode?.description)
		placeView.fifthLabel.addAttributedString(Place.Attributes.postalName, dataString: place.postalName)
		placeView.sixthLabel.isHidden = true
		placeView.seventhLabel.isHidden = true
		placeView.eighthLabel.isHidden = true
		
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
		
		unitView.firstLabel.addAttributedString(Unit.Attributes.docId, dataString: unit.docId?.description)
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
		
		return unitView
	}
	
	
	func configureCompanyView(companyView: DbListView, company: Company, shouldAddButtons: Bool) -> DbListView {
		
		unhideAllLabels(cellView: companyView)
		companyView.firstLabel.addAttributedString(Company.CompanyAttributes.companyId, dataString: company.companyId?.description)
		companyView.secondLabel.addAttributedString(Company.CompanyAttributes.name, dataString: company.name)
		companyView.thirdLabel.addAttributedString(Company.CompanyAttributes.registryNumber, dataString: company.registryNumber)
		companyView.fourthLabel.addAttributedString(Company.Attributes.oib, dataString: company.oib)
		companyView.fifthLabel.addAttributedString(Company.Attributes.partnerAddress, dataString: company.partnerAddress)
		companyView.sixthLabel.addAttributedString(Company.Attributes.partnerAddressId, dataString: company.partnerAddressId?.description)
		companyView.seventhLabel.addAttributedString(Company.Attributes.shipmentAddress, dataString: company.shipmentAddress)
		companyView.eighthLabel.addAttributedString(Company.Attributes.shipmentAddressId, dataString: company.shipmentAddressId?.description)
		
		if shouldAddButtons {
			if let partnerPlace = company.partnerPlace {
				companyView.firstButton.title = Places.PartnerPlace.rawValue
				companyView.firstButton.type = Tables.Place
				companyView.firstButton.places = [partnerPlace]
			} else {
				companyView.firstButton.isHidden = true
			}
			if let shipmentPlace = company.shipmentPlace {
				companyView.secondButton.title = Places.ShipmentPlace.rawValue
				companyView.secondButton.type = Tables.Place
				companyView.secondButton.places = [shipmentPlace]
			} else {
				companyView.secondButton.isHidden = true
			}
			if company.docs.count != 0 {
				companyView.thirdButton.title = TablePlurals.Documents.rawValue
				companyView.thirdButton.type = Tables.Document
				companyView.thirdButton.docs = company.docs
			} else {
				companyView.thirdButton.isHidden = true
			}
		} else {
			hideAllButtons(cellView: companyView)
		}
		
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
