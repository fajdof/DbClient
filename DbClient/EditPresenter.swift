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
    
    func configureWithItem(item: Item?) {
        
        viewController.secondStaticLabel.stringValue = Item.Attributes.text
        viewController.thirdStaticLabel.stringValue = Item.Attributes.price
        viewController.fourthStaticLabel.stringValue = Item.Attributes.measUnit
        viewController.fifthStaticLabel.stringValue = Item.Attributes.secU
        viewController.sixthStaticLabel.stringValue = Item.Attributes.name
        viewController.secondLabel.stringValue = item?.text ?? ""
        viewController.thirdLabel.stringValue = item?.price?.description ?? ""
        viewController.fourthLabel.stringValue = item?.measUnit ?? ""
        viewController.fifthLabel.stringValue = item?.secU?.description ?? ""
        viewController.sixthLabel.stringValue = item?.name ?? ""
        
        viewController.firstStackView.isHidden = true
        viewController.seventhStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
        viewController.twelvethStackView.isHidden = true
    }
    
    func configureWithCompany(company: Company?) {
        viewController.secondStaticLabel.stringValue = Company.CompanyAttributes.name
        viewController.secondLabel.stringValue = company?.name ?? ""
        viewController.thirdStaticLabel.stringValue = Company.CompanyAttributes.registryNumber
        viewController.thirdLabel.stringValue = company?.registryNumber ?? ""
        viewController.fourthStaticLabel.stringValue = Company.Attributes.oib
        viewController.fourthLabel.stringValue = company?.oib ?? ""
        viewController.fifthStaticLabel.stringValue = Company.Attributes.partnerAddress
        viewController.fifthLabel.stringValue = company?.partnerAddress ?? ""
        viewController.seventhStaticLabel.stringValue = Company.Attributes.shipmentAddress
        viewController.seventhLabel.stringValue = company?.shipmentAddress ?? ""
        
        viewController.firstStackView.isHidden = true
        viewController.sixthStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
        viewController.twelvethStackView.isHidden = true
    }
    
    func configureWithPerson(person: Person?) {
        viewController.firstStaticLabel.stringValue = Person.PersonAttributes.firstName
        viewController.firstLabel.stringValue = person?.firstName ?? ""
        viewController.secondStaticLabel.stringValue = Person.PersonAttributes.lastName
        viewController.secondLabel.stringValue = person?.lastName ?? ""
        viewController.fourthStaticLabel.stringValue = Person.Attributes.oib
        viewController.fourthLabel.stringValue = person?.oib ?? ""
        viewController.fifthStaticLabel.stringValue = Person.Attributes.partnerAddress
        viewController.fifthLabel.stringValue = person?.partnerAddress ?? ""
        viewController.seventhStaticLabel.stringValue = Person.Attributes.shipmentAddress
        viewController.seventhLabel.stringValue = person?.shipmentAddress ?? ""
        
        viewController.thirdStackView.isHidden = true
        viewController.sixthStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
        viewController.twelvethStackView.isHidden = true
    }
    
    func configureWithCountry(country: Country?) {
        viewController.firstStaticLabel.stringValue = Country.Attributes.name
        viewController.firstLabel.stringValue = country?.name ?? ""
        viewController.secondStaticLabel.stringValue = Country.Attributes.code
        viewController.secondLabel.stringValue = country?.code?.description ?? ""
        viewController.thirdStaticLabel.stringValue = Country.Attributes.mark
        viewController.thirdLabel.stringValue = country?.mark ?? ""
        viewController.fourthStaticLabel.stringValue = Country.Attributes.iso3
        viewController.fourthLabel.stringValue = country?.iso3 ?? ""
        
        if country != nil {
            viewController.thirdLabel.isBezeled = false
            viewController.thirdLabel.isEditable = false
        }
        
        viewController.fifthStackView.isHidden = true
        viewController.sixthStackView.isHidden = true
        viewController.seventhStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
        viewController.twelvethStackView.isHidden = true
    }
    
    func configureWithDocument(doc: Document?, fromPartner: Bool) {
        viewController.firstStaticLabel.stringValue = Document.Attributes.docId
        viewController.firstLabel.stringValue = doc?.docId?.description ?? ""
        viewController.secondStaticLabel.stringValue = Document.Attributes.docNumber
        viewController.secondLabel.stringValue = doc?.docNumber?.description ?? ""
        viewController.thirdStaticLabel.stringValue = Document.Attributes.docValue
        viewController.thirdLabel.stringValue = doc?.docValue?.description ?? ""
        viewController.fourthStaticLabel.stringValue = Document.Attributes.docVr
        viewController.fourthLabel.stringValue = doc?.docVr ?? ""
        viewController.fifthStaticLabel.stringValue = Document.Attributes.tax
        viewController.fifthLabel.stringValue = doc?.tax?.description ?? ""
        viewController.twelvethStaticLabel.stringValue = Document.Attributes.docDate
        viewController.datePicker.dateValue = doc?.docDate ?? Date()
        
        if doc != nil || fromPartner {
            viewController.seventhStackView.isHidden = true
            viewController.eightStackView.isHidden = true
            viewController.ninthStackView.isHidden = true
            viewController.firstLabel.isEditable = false
            viewController.firstLabel.isBezeled = false
            if fromPartner {
                viewController.firstStackView.isHidden = true
            }
        } else {
            viewController.firstStackView.isHidden = true
            if viewController.isPerson {
                viewController.seventhStaticLabel.stringValue = Person.PersonAttributes.firstName
                viewController.eightStaticLabel.stringValue = Person.PersonAttributes.lastName
                viewController.ninthStaticLabel.stringValue = Person.Attributes.oib
            } else {
                viewController.seventhStaticLabel.stringValue = Company.CompanyAttributes.name
                viewController.eightStaticLabel.stringValue = Company.CompanyAttributes.registryNumber
                viewController.ninthStaticLabel.stringValue = Company.Attributes.oib
            }
        }
        
        viewController.sixthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
    }
    
    func configureWithUnit(unit: Unit?) {
        viewController.firstStaticLabel.stringValue = Unit.Attributes.itemPrice
        viewController.firstLabel.stringValue = unit?.itemPrice?.description ?? ""
        viewController.secondStaticLabel.stringValue = Unit.Attributes.itemQuantity
        viewController.secondLabel.stringValue = unit?.itemQuantity?.description ?? ""
        viewController.thirdStaticLabel.stringValue = Unit.Attributes.discount
        viewController.thirdLabel.stringValue = unit?.discount?.description ?? ""
        
        if unit != nil {
            viewController.sixthStackView.isHidden = true
            viewController.seventhStackView.isHidden = true
            viewController.eightStackView.isHidden = true
            viewController.ninthStackView.isHidden = true
            viewController.tenthStackView.isHidden = true
        } else {
            viewController.sixthStaticLabel.stringValue = Item.Attributes.text
            viewController.seventhStaticLabel.stringValue = Item.Attributes.price
            viewController.eightStaticLabel.stringValue = Item.Attributes.measUnit
            viewController.ninthStaticLabel.stringValue = Item.Attributes.secU
            viewController.tenthStaticLabel.stringValue = Item.Attributes.name
        }
    
        viewController.fifthStackView.isHidden = true
        viewController.fourthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
        viewController.twelvethStackView.isHidden = true
    }
    
    func configureWithPlace(place: Place?, withId: Bool) {
        viewController.firstStaticLabel.stringValue = Place.Attributes.name
        viewController.firstLabel.stringValue = place?.name ?? ""
        viewController.fourthStaticLabel.stringValue = Place.Attributes.postalCode
        viewController.fourthLabel.stringValue = place?.postalCode?.description ?? ""
        viewController.fifthStaticLabel.stringValue = Place.Attributes.postalName
        viewController.fifthLabel.stringValue = place?.postalName ?? ""
        viewController.thirdStaticLabel.stringValue = Place.Attributes.id
        viewController.thirdLabel.stringValue = place?.id?.description ?? ""
        
        if withId {
            viewController.sixthStaticLabel.stringValue = "Naziv države: "
            viewController.seventhStaticLabel.stringValue = "Šifra države: "
            viewController.eightStaticLabel.stringValue = "Oznaka države: "
            viewController.ninthStaticLabel.stringValue = "ISO3 države: "
            viewController.thirdStackView.isHidden = false
            viewController.sixthStackView.isHidden = false
            viewController.seventhStackView.isHidden = false
            viewController.eightStackView.isHidden = false
            viewController.ninthStackView.isHidden = false
        } else {
            viewController.thirdStackView.isHidden = true
            viewController.sixthStackView.isHidden = true
            viewController.seventhStackView.isHidden = true
            viewController.eightStackView.isHidden = true
            viewController.ninthStackView.isHidden = true
        }
        
        viewController.secondStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
        viewController.twelvethStackView.isHidden = true
    }
    
    
    func configureWithDocId() {
        viewController.firstStaticLabel.stringValue = "Id prethodnog dokumenta: "
        
        viewController.secondStackView.isHidden = true
        viewController.thirdStackView.isHidden = true
        viewController.fourthStackView.isHidden = true
        viewController.fifthStackView.isHidden = true
        viewController.sixthStackView.isHidden = true
        viewController.seventhStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
        viewController.twelvethStackView.isHidden = true
    }
    
}
