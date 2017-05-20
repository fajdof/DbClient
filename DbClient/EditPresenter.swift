//
//  EditPresenter.swift
//  DbClient
//
//  Created by Filip Fajdetic on 19/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class EditPresenter {
    
    weak var viewController: EditViewController!
    
    func configureWithItem(item: Item) {
        
        viewController.firstStaticLabel.stringValue = Item.Attributes.code
        viewController.firstLabel.stringValue = item.code?.description ?? ""
        viewController.secondStaticLabel.stringValue = Item.Attributes.text
        viewController.secondLabel.stringValue = item.text ?? ""
        viewController.thirdStaticLabel.stringValue = Item.Attributes.price
        viewController.thirdLabel.stringValue = item.price?.description ?? ""
        viewController.fourthStaticLabel.stringValue = Item.Attributes.measUnit
        viewController.fourthLabel.stringValue = item.measUnit ?? ""
        viewController.fifthStaticLabel.stringValue = Item.Attributes.secU
        viewController.fifthLabel.stringValue = item.secU?.description ?? ""
        viewController.sixthStaticLabel.stringValue = Item.Attributes.name
        viewController.sixthLabel.stringValue = item.name ?? ""
        
        viewController.seventhStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
        
        viewController.firstLabel.isEditable = false
        viewController.firstLabel.isBezeled = false
    }
    
    func configureWithCompany(company: Company) {
        viewController.firstStaticLabel.stringValue = Company.CompanyAttributes.companyId
        viewController.firstLabel.stringValue = company.companyId?.description ?? ""
        viewController.secondStaticLabel.stringValue = Company.CompanyAttributes.name
        viewController.secondLabel.stringValue = company.name ?? ""
        viewController.thirdStaticLabel.stringValue = Company.CompanyAttributes.registryNumber
        viewController.thirdLabel.stringValue = company.registryNumber ?? ""
        viewController.fourthStaticLabel.stringValue = Company.Attributes.oib
        viewController.fourthLabel.stringValue = company.oib ?? ""
        viewController.fifthStaticLabel.stringValue = Company.Attributes.partnerAddress
        viewController.fifthLabel.stringValue = company.partnerAddress ?? ""
        viewController.sixthStaticLabel.stringValue = Company.Attributes.partnerAddressId
        viewController.sixthLabel.stringValue = company.partnerAddressId?.description ?? ""
        viewController.seventhStaticLabel.stringValue = Company.Attributes.shipmentAddress
        viewController.seventhLabel.stringValue = company.shipmentAddress ?? ""
        viewController.eightStaticLabel.stringValue = Company.Attributes.shipmentAddressId
        viewController.eightLabel.stringValue = company.shipmentAddressId?.description ?? ""
        
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
    }
    
    func configureWithPerson(person: Person) {
        viewController.firstStaticLabel.stringValue = Person.PersonAttributes.firstName
        viewController.firstLabel.stringValue = person.firstName ?? ""
        viewController.secondStaticLabel.stringValue = Person.PersonAttributes.lastName
        viewController.secondLabel.stringValue = person.lastName ?? ""
        viewController.thirdStaticLabel.stringValue = Person.PersonAttributes.id
        viewController.thirdLabel.stringValue = person.id?.description ?? ""
        viewController.fourthStaticLabel.stringValue = Person.Attributes.oib
        viewController.fourthLabel.stringValue = person.oib ?? ""
        viewController.fifthStaticLabel.stringValue = Person.Attributes.partnerAddress
        viewController.fifthLabel.stringValue = person.partnerAddress ?? ""
        viewController.sixthStaticLabel.stringValue = Person.Attributes.partnerAddressId
        viewController.sixthLabel.stringValue = person.partnerAddressId?.description ?? ""
        viewController.seventhStaticLabel.stringValue = Person.Attributes.shipmentAddress
        viewController.seventhLabel.stringValue = person.shipmentAddress ?? ""
        viewController.eightStaticLabel.stringValue = Person.Attributes.shipmentAddressId
        viewController.eightLabel.stringValue = person.shipmentAddressId?.description ?? ""
        
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
    }
    
    func configureWithCountry(country: Country) {
        viewController.firstStaticLabel.stringValue = Country.Attributes.name
        viewController.firstLabel.stringValue = country.name ?? ""
        viewController.secondStaticLabel.stringValue = Country.Attributes.code
        viewController.secondLabel.stringValue = country.code?.description ?? ""
        viewController.thirdStaticLabel.stringValue = Country.Attributes.mark
        viewController.thirdLabel.stringValue = country.mark ?? ""
        viewController.fourthStaticLabel.stringValue = Country.Attributes.iso3
        viewController.fourthLabel.stringValue = country.iso3 ?? ""
        
        viewController.fifthStackView.isHidden = true
        viewController.sixthStackView.isHidden = true
        viewController.seventhStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
    }
    
    func configureWithDocument(doc: Document) {
        viewController.firstStaticLabel.stringValue = Document.Attributes.docId
        viewController.firstLabel.stringValue = doc.docId?.description ?? ""
        viewController.secondStaticLabel.stringValue = Document.Attributes.docNumber
        viewController.secondLabel.stringValue = doc.docNumber?.description ?? ""
        viewController.thirdStaticLabel.stringValue = Document.Attributes.docDate
        viewController.thirdLabel.stringValue = doc.docDate?.inLocalRegion().string(dateStyle: .medium, timeStyle: .short) ?? ""
        viewController.fourthStaticLabel.stringValue = Document.Attributes.docValue
        viewController.fourthLabel.stringValue = doc.docValue?.description ?? ""
        viewController.fifthStaticLabel.stringValue = Document.Attributes.docBeforeId
        viewController.fifthLabel.stringValue = doc.docBeforeId?.description ?? ""
        viewController.sixthStaticLabel.stringValue = Document.Attributes.partnerId
        viewController.sixthLabel.stringValue = doc.partnerId?.description ?? ""
        viewController.seventhStaticLabel.stringValue = Document.Attributes.docVr
        viewController.seventhLabel.stringValue = doc.docVr ?? ""
        viewController.eightStaticLabel.stringValue = Document.Attributes.tax
        viewController.eightLabel.stringValue = doc.tax?.description ?? ""
        
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
    }
    
    func configureWithUnit(unit: Unit) {
        viewController.firstStaticLabel.stringValue = Unit.Attributes.docId
        viewController.firstLabel.stringValue = unit.docId?.description ?? ""
        viewController.secondStaticLabel.stringValue = Unit.Attributes.unitId
        viewController.secondLabel.stringValue = unit.unitId?.description ?? ""
        viewController.thirdStaticLabel.stringValue = Unit.Attributes.itemPrice
        viewController.thirdLabel.stringValue = unit.itemPrice?.description ?? ""
        viewController.fourthStaticLabel.stringValue = Unit.Attributes.itemQuantity
        viewController.fourthLabel.stringValue = unit.itemQuantity?.description ?? ""
        viewController.fifthLabel.stringValue = Unit.Attributes.itemCode
        viewController.fifthLabel.stringValue = unit.itemCode?.description ?? ""
        viewController.sixthStaticLabel.stringValue = Unit.Attributes.discount
        viewController.sixthLabel.stringValue = unit.discount?.description ?? ""
        
        viewController.seventhStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
    }
    
    func configureWithPlace(place: Place) {
        viewController.firstStaticLabel.stringValue = Place.Attributes.name
        viewController.firstLabel.stringValue = place.name ?? ""
        viewController.secondStaticLabel.stringValue = Place.Attributes.countryCode
        viewController.secondLabel.stringValue = place.countryCode ?? ""
        viewController.thirdStaticLabel.stringValue = Place.Attributes.id
        viewController.thirdLabel.stringValue = place.id?.description ?? ""
        viewController.fourthStaticLabel.stringValue = Place.Attributes.postalCode
        viewController.fourthLabel.stringValue = place.postalCode?.description ?? ""
        viewController.fifthStaticLabel.stringValue = Place.Attributes.postalName
        viewController.fifthLabel.stringValue = place.postalName ?? ""
        
        viewController.sixthStackView.isHidden = true
        viewController.seventhStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
    }
    
}
