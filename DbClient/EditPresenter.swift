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
    let required = " *"
    
    func configureWithItem(item: Item?) {
        
        viewController.secondStaticLabel.stringValue = Item.Attributes.text
        viewController.thirdStaticLabel.stringValue = Item.Attributes.price + required
        viewController.fourthStaticLabel.stringValue = Item.Attributes.measUnit + required
        viewController.fifthStaticLabel.stringValue = Item.Attributes.secU + required
        viewController.sixthStaticLabel.stringValue = Item.Attributes.name + required
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
        viewController.secondStaticLabel.stringValue = Company.CompanyAttributes.name + required
        viewController.secondLabel.stringValue = company?.name ?? ""
        viewController.thirdStaticLabel.stringValue = Company.CompanyAttributes.registryNumber + required
        viewController.thirdLabel.stringValue = company?.registryNumber ?? ""
        viewController.fourthStaticLabel.stringValue = Company.Attributes.oib + required
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
        viewController.firstStaticLabel.stringValue = Person.PersonAttributes.firstName + required
        viewController.firstLabel.stringValue = person?.firstName ?? ""
        viewController.secondStaticLabel.stringValue = Person.PersonAttributes.lastName + required
        viewController.secondLabel.stringValue = person?.lastName ?? ""
        viewController.fourthStaticLabel.stringValue = Person.Attributes.oib + required
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
        viewController.firstStaticLabel.stringValue = Country.Attributes.name + required
        viewController.firstLabel.stringValue = country?.name ?? ""
        viewController.secondStaticLabel.stringValue = Country.Attributes.code + required
        viewController.secondLabel.stringValue = country?.code?.description ?? ""
        viewController.thirdStaticLabel.stringValue = Country.Attributes.mark + required
        viewController.thirdLabel.stringValue = country?.mark ?? ""
        viewController.fourthStaticLabel.stringValue = Country.Attributes.iso3 + required
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
        viewController.firstStaticLabel.stringValue = Document.Attributes.docId + required
        viewController.firstLabel.stringValue = doc?.docId?.description ?? ""
        viewController.secondStaticLabel.stringValue = Document.Attributes.docNumber + required
        viewController.secondLabel.stringValue = doc?.docNumber?.description ?? ""
        viewController.thirdStaticLabel.stringValue = Document.Attributes.docValue + required
        viewController.thirdLabel.stringValue = doc?.docValue?.description ?? ""
        viewController.fourthStaticLabel.stringValue = Document.Attributes.docVr
        viewController.fourthLabel.stringValue = doc?.docVr ?? ""
        viewController.fifthStaticLabel.stringValue = Document.Attributes.tax + required
        viewController.fifthLabel.stringValue = doc?.tax?.description ?? ""
        viewController.twelvethStaticLabel.stringValue = Document.Attributes.docDate + required
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
                viewController.seventhStaticLabel.stringValue = Person.PersonAttributes.firstName + required
                viewController.eightStaticLabel.stringValue = Person.PersonAttributes.lastName + required
                viewController.ninthStaticLabel.stringValue = Person.Attributes.oib + required
            } else {
                viewController.seventhStaticLabel.stringValue = Company.CompanyAttributes.name + required
                viewController.eightStaticLabel.stringValue = Company.CompanyAttributes.registryNumber + required
                viewController.ninthStaticLabel.stringValue = Company.Attributes.oib + required
            }
        }
        
        viewController.sixthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
    }
    
    func configureWithUnit(unit: Unit?) {
        viewController.firstStaticLabel.stringValue = Unit.Attributes.itemPrice + required
        viewController.firstLabel.stringValue = unit?.itemPrice?.description ?? ""
        viewController.secondStaticLabel.stringValue = Unit.Attributes.itemQuantity + required
        viewController.secondLabel.stringValue = unit?.itemQuantity?.description ?? ""
        viewController.thirdStaticLabel.stringValue = Unit.Attributes.discount + required
        viewController.thirdLabel.stringValue = unit?.discount?.description ?? ""
        
        if unit != nil {
            viewController.sixthStackView.isHidden = true
            viewController.seventhStackView.isHidden = true
            viewController.eightStackView.isHidden = true
            viewController.ninthStackView.isHidden = true
            viewController.tenthStackView.isHidden = true
        } else {
            viewController.sixthStaticLabel.stringValue = Item.Attributes.text
            viewController.seventhStaticLabel.stringValue = Item.Attributes.price + required
            viewController.eightStaticLabel.stringValue = Item.Attributes.measUnit + required
            viewController.ninthStaticLabel.stringValue = Item.Attributes.secU + required
            viewController.tenthStaticLabel.stringValue = Item.Attributes.name + required
        }
    
        viewController.fifthStackView.isHidden = true
        viewController.fourthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
        viewController.twelvethStackView.isHidden = true
    }
    
    func configureWithPlace(place: Place?, withId: Bool) {
        viewController.firstStaticLabel.stringValue = Place.Attributes.name + required
        viewController.firstLabel.stringValue = place?.name ?? ""
        viewController.fourthStaticLabel.stringValue = Place.Attributes.postalCode + required
        viewController.fourthLabel.stringValue = place?.postalCode?.description ?? ""
        viewController.fifthStaticLabel.stringValue = Place.Attributes.postalName
        viewController.fifthLabel.stringValue = place?.postalName ?? ""
        viewController.thirdStaticLabel.stringValue = Place.Attributes.id + required
        viewController.thirdLabel.stringValue = place?.id?.description ?? ""
        
        if withId {
            viewController.sixthStaticLabel.stringValue = "Naziv države: " + required
            viewController.seventhStaticLabel.stringValue = "Šifra države: " + required
            viewController.eightStaticLabel.stringValue = "Oznaka države: " + required
            viewController.ninthStaticLabel.stringValue = "ISO3 države: " + required
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
