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
	
	
	func configureDocumentView(docView: DbListView, doc: Document, shouldAddButtons: Bool) -> DbListView {
		
		unhideAllLabels(cellView: docView)
		unhideAllButtons(cellView: docView)
        docView.addButton.isHidden = false
		
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
			} else {
				docView.thirdButton.isHidden = true
			}
		} else {
			hideAllButtons(cellView: docView)
            docView.addButton.isHidden = true
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
        personView.addButtonWidth.constant = 150
		
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
        companyView.addButtonWidth.constant = 150
		
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
