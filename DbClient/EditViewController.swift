//
//  EditViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 17/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa

class EditViewController: NSViewController {
    
    @IBOutlet weak var cancelButton: NSButton!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var firstStaticLabel: NSTextField!
    @IBOutlet weak var firstLabel: NSTextField!
    @IBOutlet weak var firstStackView: NSStackView!
    @IBOutlet weak var secondStaticLabel: NSTextField!
    @IBOutlet weak var secondLabel: NSTextField!
    @IBOutlet weak var secondStackView: NSStackView!
    @IBOutlet weak var thirdStaticLabel: NSTextField!
    @IBOutlet weak var thirdLabel: NSTextField!
    @IBOutlet weak var thirdStackView: NSStackView!
    @IBOutlet weak var fourthStaticLabel: NSTextField!
    @IBOutlet weak var fourthLabel: NSTextField!
    @IBOutlet weak var fourthStackView: NSStackView!
    @IBOutlet weak var fifthStaticLabel: NSTextField!
    @IBOutlet weak var fifthLabel: NSTextField!
    @IBOutlet weak var fifthStackView: NSStackView!
    @IBOutlet weak var sixthStaticLabel: NSTextField!
    @IBOutlet weak var sixthLabel: NSTextField!
    @IBOutlet weak var sixthStackView: NSStackView!
    @IBOutlet weak var seventhStaticLabel: NSTextField!
    @IBOutlet weak var seventhLabel: NSTextField!
    @IBOutlet weak var seventhStackView: NSStackView!
    @IBOutlet weak var eightStaticLabel: NSTextField!
    @IBOutlet weak var eightLabel: NSTextField!
    @IBOutlet weak var eightStackView: NSStackView!
    @IBOutlet weak var ninthStaticLabel: NSTextField!
    @IBOutlet weak var ninthLabel: NSTextField!
    @IBOutlet weak var ninthStackView: NSStackView!
    @IBOutlet weak var tenthStaticLabel: NSTextField!
    @IBOutlet weak var tenthLabel: NSTextField!
    @IBOutlet weak var tenthStackView: NSStackView!
    @IBOutlet weak var eleventhStaticLabel: NSTextField!
    @IBOutlet weak var eleventhLabel: NSTextField!
    @IBOutlet weak var eleventhStackView: NSStackView!
    @IBOutlet weak var twelvethStaticLabel: NSTextField!
    @IBOutlet weak var twelvethStackView: NSStackView!
    @IBOutlet weak var datePicker: NSDatePicker!
    
    var originButton: EditButton!
    let presenter = EditPresenter()
    let viewModel = EditViewModel()
    weak var connectVC: DbConnectViewController!
    var isPerson: Bool = false
    let generatorService = IdGeneratorService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = originButton.type.rawValue
        
        presenter.viewController = self
        
        cancelButton.action = #selector(EditViewController.cancelButtonPressed)
        
        switch originButton.type! {
        case .Item:
            if let item = originButton.item {
                presenter.configureWithItem(item: item)
                saveButton.action = #selector(EditViewController.updateItem)
            } else {
                presenter.configureWithItem(item: nil)
                saveButton.action = #selector(EditViewController.addItem)
            }
        case .Company:
            if let company = originButton.company {
                if originButton.subType == Tables.Place {
                    self.presenter.configureWithPlace(place: nil, withId: true)
                    saveButton.action = #selector(EditViewController.addPlaceToPartner)
                    title = Tables.Place.rawValue
                } else {
                    if originButton.subType == Tables.Document {
                        presenter.configureWithDocument(doc: nil, fromPartner: true)
                        saveButton.action = #selector(EditViewController.addDocToPartner)
                    } else {
                        presenter.configureWithCompany(company: company)
                        saveButton.action = #selector(EditViewController.updateCompany)
                    }
                }
            } else {
                presenter.configureWithCompany(company: nil)
                saveButton.action = #selector(EditViewController.addCompany)
            }
        case .Country:
            if let country = originButton.country {
                if originButton.subType == Tables.Place {
                    self.presenter.configureWithPlace(place: nil, withId: false)
                    saveButton.action = #selector(EditViewController.addPlace)
                    title = Tables.Place.rawValue
                } else {
                    self.presenter.configureWithCountry(country: country)
                    saveButton.action = #selector(EditViewController.updateCountry)
                }
            } else {
                self.presenter.configureWithCountry(country: nil)
                saveButton.action = #selector(EditViewController.addCountry)
            }
        case .Person:
            if let person = originButton.person {
                if originButton.subType == Tables.Place {
                    self.presenter.configureWithPlace(place: nil, withId: true)
                    saveButton.action = #selector(EditViewController.addPlaceToPartner)
                    title = Tables.Place.rawValue
                } else {
                    if originButton.subType == Tables.Document {
                        presenter.configureWithDocument(doc: nil, fromPartner: true)
                        saveButton.action = #selector(EditViewController.addDocToPartner)
                    } else {
                        self.presenter.configureWithPerson(person: person)
                        saveButton.action = #selector(EditViewController.updatePerson)
                    }
                }
            } else {
                self.presenter.configureWithPerson(person: nil)
                saveButton.action = #selector(EditViewController.addPerson)
            }
        case .Document:
            if let document = originButton.doc {
                if originButton.subType == Tables.Unit {
                    self.presenter.configureWithUnit(unit: nil)
                    saveButton.action = #selector(EditViewController.addUnit)
                    title = Tables.Unit.rawValue
                } else {
                    if originButton.subType == Tables.Document {
                        self.presenter.configureWithDocId()
                        saveButton.action = #selector(EditViewController.addBeforeDoc)
                    } else {
                        self.presenter.configureWithDocument(doc: document, fromPartner: false)
                        saveButton.action = #selector(EditViewController.updateDocument)
                    }
                }
            } else {
                self.presenter.configureWithDocument(doc: nil, fromPartner: false)
                saveButton.action = #selector(EditViewController.addDocument)
            }
        case .Place:
            if let place = originButton.place {
                self.presenter.configureWithPlace(place: place, withId: false)
            }
            saveButton.action = #selector(EditViewController.updatePlace)
        case .Unit:
            if let unit = originButton.unit {
                self.presenter.configureWithUnit(unit: unit)
            }
            saveButton.action = #selector(EditViewController.updateUnit)
        case .Partner:
            break
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.error(notification:)), name: NSNotification.Name.SQLClientError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditViewController.message(notification:)), name: NSNotification.Name.SQLClientMessage, object: nil)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateItem() {
        let initDict: [String: Any] = ["SifArtikla" : originButton.item!.code!]
        guard let item = Item(JSON: initDict) else { return }
        
        item.text = secondLabel.stringValue
        item.measUnit = fourthLabel.stringValue
        item.name = sixthLabel.stringValue
        
        if thirdLabel.stringValue.isEmpty == false {
            item.price = 0
        }
        if fifthLabel.stringValue.isEmpty == false {
            item.secU = NSNumber(integerLiteral: 0)
        }
        
        guard requirementsSatisfied(reqValidator: ItemReqValidator(item: item)) else {
            return
        }
        
        item.price = Double(thirdLabel.stringValue)
        if let secU = Int(fifthLabel.stringValue) {
            item.secU = NSNumber(integerLiteral: secU)
        } else {
            item.secU = nil
        }
        
        viewModel.updateItem(item: item) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func addItem() {
        let initDict: [String: Any] = [:]
        guard let item = Item(JSON: initDict) else { return }
        
        item.text = secondLabel.stringValue
        item.measUnit = fourthLabel.stringValue
        item.name = sixthLabel.stringValue
        item.code = generatorService.generateIdForItem(items: connectVC.items)
        
        if thirdLabel.stringValue.isEmpty == false {
            item.price = 0
        }
        if fifthLabel.stringValue.isEmpty == false {
            item.secU = NSNumber(integerLiteral: 0)
        }
        
        guard requirementsSatisfied(reqValidator: ItemReqValidator(item: item)) else {
            return
        }
        
        item.price = Double(thirdLabel.stringValue)
        if let secU = Int(fifthLabel.stringValue) {
            item.secU = NSNumber(integerLiteral: secU)
        } else {
            item.secU = nil
        }
        
        viewModel.addItem(item: item) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func updateCompany() {
        let initDict: [String: Any] = ["IdTvrtke" : originButton.company!.companyId!]
        guard let company = Company(JSON: initDict) else { return }
        
        company.registryNumber = thirdLabel.stringValue
        company.name = secondLabel.stringValue
        company.oib = fourthLabel.stringValue
        company.partnerAddress = fifthLabel.stringValue
        company.shipmentAddress = seventhLabel.stringValue
        
        guard requirementsSatisfied(reqValidator: CompanyReqValidator(company: company)) else {
            return
        }
        
        viewModel.updateCompany(company: company) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func addCompany() {
        let initDict: [String: Any] = [:]
        guard let company = Company(JSON: initDict) else { return }
        
        company.registryNumber = thirdLabel.stringValue
        company.name = secondLabel.stringValue
        company.oib = fourthLabel.stringValue
        company.partnerAddress = fifthLabel.stringValue
        company.shipmentAddress = seventhLabel.stringValue
        company.companyId = generatorService.generateIdForPartner(partners: connectVC.partners)
        
        guard requirementsSatisfied(reqValidator: CompanyReqValidator(company: company)) else {
            return
        }
        
        viewModel.addCompany(company: company) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func updateCountry() {
        let initDict: [String: Any] = ["OznDrzave" : originButton.country!.mark!]
        guard let country = Country(JSON: initDict) else { return }
        
        if secondLabel.stringValue.isEmpty == false {
            country.code = 0
        }
        country.name = firstLabel.stringValue
        country.iso3 = fourthLabel.stringValue
        
        guard requirementsSatisfied(reqValidator: CountryReqValidator(country: country)) else {
            return
        }
        
        country.code = Int(secondLabel.stringValue)
        
        viewModel.updateCountry(country: country) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func addCountry() {
        let initDict: [String: Any] = [:]
        guard let country = Country(JSON: initDict) else { return }
        
        if secondLabel.stringValue.isEmpty == false {
            country.code = 0
        }
        country.name = firstLabel.stringValue
        country.mark = thirdLabel.stringValue
        country.iso3 = fourthLabel.stringValue
        
        guard requirementsSatisfied(reqValidator: CountryReqValidator(country: country)) else {
            return
        }
        
        country.code = Int(secondLabel.stringValue)
        
        viewModel.addCountry(country: country) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func updatePerson() {
        let initDict: [String: Any] = ["IdOsobe" : originButton.person!.id!]
        guard let person = Person(JSON: initDict) else { return }
        
        person.firstName = firstLabel.stringValue
        person.lastName = secondLabel.stringValue
        person.oib = fourthLabel.stringValue
        person.partnerAddress = fifthLabel.stringValue
        person.shipmentAddress = seventhLabel.stringValue
        
        guard requirementsSatisfied(reqValidator: PersonReqValidator(person: person)) else {
            return
        }
        
        viewModel.updatePerson(person: person) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func addPerson() {
        let initDict: [String: Any] = [:]
        guard let person = Person(JSON: initDict) else { return }
        
        person.firstName = firstLabel.stringValue
        person.lastName = secondLabel.stringValue
        person.oib = fourthLabel.stringValue
        person.partnerAddress = fifthLabel.stringValue
        person.shipmentAddress = seventhLabel.stringValue
        person.id = generatorService.generateIdForPartner(partners: connectVC.partners)
        
        guard requirementsSatisfied(reqValidator: PersonReqValidator(person: person)) else {
            return
        }
        
        viewModel.addPerson(person: person) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func updateDocument() {
        let initDict: [String: Any] = ["IdDokumenta" : originButton.doc!.docId!]
        guard let doc = Document(JSON: initDict) else { return }
        
        if fifthLabel.stringValue.isEmpty == false {
            doc.tax = 0
        }
        if secondLabel.stringValue.isEmpty == false {
            doc.docNumber = 0
        }
        if thirdLabel.stringValue.isEmpty == false {
            doc.docValue = 0
        }
        
        doc.docDate = datePicker.dateValue
        doc.docVr = fourthLabel.stringValue
        
        guard requirementsSatisfied(reqValidator: DocumentReqValidator(doc: doc)) else {
            return
        }
        
        doc.tax = Double(fifthLabel.stringValue)
        doc.docNumber = Int(secondLabel.stringValue)
        doc.docValue = Double(thirdLabel.stringValue)
        
        viewModel.updateDocument(doc: doc) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func addDocument() {
        let initDict: [String: Any] = [:]
        guard let doc = Document(JSON: initDict) else { return }
        
        if fifthLabel.stringValue.isEmpty == false {
            doc.tax = 0
        }
        if secondLabel.stringValue.isEmpty == false {
            doc.docNumber = 0
        }
        if thirdLabel.stringValue.isEmpty == false {
            doc.docValue = 0
        }
        
        doc.docDate = datePicker.dateValue
        doc.docVr = fourthLabel.stringValue
        
        guard requirementsSatisfied(reqValidator: DocumentReqValidator(doc: doc)) else {
            return
        }
        
        doc.tax = Double(fifthLabel.stringValue)
        doc.docNumber = Int(secondLabel.stringValue)
        doc.docValue = Double(thirdLabel.stringValue)
        
        var company: Company?
        var person: Person?
        
        if isPerson {
            person = Person(JSON: initDict)
            person?.firstName = seventhLabel.stringValue
            person?.lastName = eightLabel.stringValue
            person?.oib = ninthLabel.stringValue
            person?.type = "O"
            person?.id = generatorService.generateIdForPartner(partners: connectVC.partners)
            
            guard requirementsSatisfied(reqValidator: PersonReqValidator(person: person!)) else {
                return
            }
            
        } else {
            company = Company(JSON: initDict)
            company?.name = seventhLabel.stringValue
            company?.registryNumber = eightLabel.stringValue
            company?.oib = ninthLabel.stringValue
            company?.type = "T"
            company?.companyId = generatorService.generateIdForPartner(partners: connectVC.partners)
            
            guard requirementsSatisfied(reqValidator: CompanyReqValidator(company: company!)) else {
                return
            }
            
        }
        
        viewModel.addDocument(doc: doc, company: company, person: person) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func updatePlace() {
        let initDict: [String: Any] = ["IdMjesta" : originButton.place!.id!]
        guard let place = Place(JSON: initDict) else { return }
        
        place.name = firstLabel.stringValue
        place.postalName = fifthLabel.stringValue
        if fourthLabel.stringValue.isEmpty == false {
            place.postalCode = 0
        }
        
        guard requirementsSatisfied(reqValidator: PlaceReqValidator(place: place)) else {
            return
        }
        
        place.postalCode = Int(fourthLabel.stringValue)
        
        viewModel.updatePlace(place: place) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }

    }
    
    func addPlace() {
        let initDict: [String: Any] = [:]
        guard let place = Place(JSON: initDict) else { return }
        
        place.name = firstLabel.stringValue
        place.postalName = fifthLabel.stringValue
        if fourthLabel.stringValue.isEmpty == false {
            place.postalCode = 0
        }
        
        guard requirementsSatisfied(reqValidator: PlaceReqValidator(place: place)) else {
            return
        }
        
        place.postalCode = Int(fourthLabel.stringValue)
        
        viewModel.addPlace(place: place, countryMark: originButton.country!.mark!) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func updateUnit() {
        let initDict: [String: Any] = ["IdStavke" : originButton.unit!.unitId!]
        guard let unit = Unit(JSON: initDict) else { return }
        
        if firstLabel.stringValue.isEmpty == false {
            unit.itemPrice = 0
        }
        if secondLabel.stringValue.isEmpty == false {
            unit.itemQuantity = 0
        }
        if thirdLabel.stringValue.isEmpty == false {
            unit.discount = 0
        }
        
        guard requirementsSatisfied(reqValidator: UnitReqValidator(unit: unit)) else {
            return
        }
        
        unit.itemPrice = Double(firstLabel.stringValue)
        unit.itemQuantity = Double(secondLabel.stringValue)
        unit.discount = Double(thirdLabel.stringValue)
        
        viewModel.updateUnit(unit: unit) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func addUnit() {
        let initDict: [String: Any] = [:]
        guard let unit = Unit(JSON: initDict) else { return }
        
        if firstLabel.stringValue.isEmpty == false {
            unit.itemPrice = 0
        }
        if secondLabel.stringValue.isEmpty == false {
            unit.itemQuantity = 0
        }
        if thirdLabel.stringValue.isEmpty == false {
            unit.discount = 0
        }
        
        guard requirementsSatisfied(reqValidator: UnitReqValidator(unit: unit)) else {
            return
        }
        
        unit.itemPrice = Double(firstLabel.stringValue)
        unit.itemQuantity = Double(secondLabel.stringValue)
        unit.discount = Double(thirdLabel.stringValue)
        
        guard let item = Item(JSON: initDict) else { return }
        
        item.text = sixthLabel.stringValue
        item.measUnit = eightLabel.stringValue
        item.name = tenthLabel.stringValue
        
        if seventhLabel.stringValue.isEmpty == false {
            item.price = 0
        }
        if ninthLabel.stringValue.isEmpty == false {
            item.secU = NSNumber(integerLiteral: 0)
        }
        item.code = generatorService.generateIdForItem(items: connectVC.items)
        
        guard requirementsSatisfied(reqValidator: ItemReqValidator(item: item)) else {
            return
        }
        
        item.price = Double(seventhLabel.stringValue)
        if let secU = Int(ninthLabel.stringValue) {
            item.secU = NSNumber(integerLiteral: secU)
        } else {
            item.secU = nil
        }
        
        viewModel.addUnit(unit: unit, docId: originButton.doc?.docId, item: item) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func addPlaceToPartner() {
        let initDict: [String: Any] = [:]
        guard let place = Place(JSON: initDict) else { return }
        guard let country = Country(JSON: initDict) else { return }
        
        place.name = firstLabel.stringValue
        if fourthLabel.stringValue.isEmpty == false {
            place.postalCode = 0
        }
        place.postalName = fifthLabel.stringValue
        if thirdLabel.stringValue.isEmpty == false {
            place.id = 0
        }
        country.name = sixthLabel.stringValue
        if seventhLabel.stringValue.isEmpty == false {
            country.code = 0
        }
        country.mark = eightLabel.stringValue
        country.iso3 = ninthLabel.stringValue
        
        guard requirementsSatisfied(reqValidator: PlaceReqValidator(place: place)) else {
            return
        }
        guard requirementsSatisfied(reqValidator: CountryReqValidator(country: country)) else {
            return
        }
        
        place.postalCode = Int(fourthLabel.stringValue)
        place.id = Int(thirdLabel.stringValue)
        country.code = Int(seventhLabel.stringValue)
        
        let partnerId = originButton.person?.id ?? originButton.company!.companyId!
        
        viewModel.addPlaceToPartner(place: place, country: country, partnerId: partnerId, shipment: originButton.shipment) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func addDocToPartner() {
        let initDict: [String: Any] = [:]
        guard let doc = Document(JSON: initDict) else { return }
        
        if fifthLabel.stringValue.isEmpty == false {
            doc.tax = 0
        }
        if secondLabel.stringValue.isEmpty == false {
            doc.docNumber = 0
        }
        if thirdLabel.stringValue.isEmpty == false {
            doc.docValue = 0
        }
        if firstLabel.stringValue.isEmpty == false {
            doc.docId = 0
        }
        
        doc.docDate = datePicker.dateValue
        doc.docVr = fourthLabel.stringValue
        
        guard requirementsSatisfied(reqValidator: DocumentReqValidator(doc: doc)) else {
            return
        }
        
        doc.tax = Double(fifthLabel.stringValue)
        doc.docNumber = Int(secondLabel.stringValue)
        doc.docValue = Double(thirdLabel.stringValue)
        doc.docId = Int(firstLabel.stringValue)
        
        let partnerId = originButton.person?.id ?? originButton.company!.companyId!
        
        viewModel.addDocToPartner(doc: doc, partnerId: partnerId) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func addBeforeDoc() {
        if let beforeDocId = Int(firstLabel.stringValue) {
            viewModel.addBeforeDoc(docId: originButton.doc?.docId, beforeDocId: beforeDocId) { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            }
        } else {
            showAlert(alertString: "Error", infoString: "Please enter valid document id")
        }
    }
    
    func error(notification: Notification) {
        let _ = notification.userInfo?[SQLClientMessageKey]
    }
    
    func message(notification: Notification) {
        if let message = notification.userInfo?[SQLClientMessageKey] as? String {
            self.connectVC.showAlert(alertString: "Error", infoString: message)
        }
    }
    
    func showAlert(alertString: String, infoString: String) {
        let alert = NSAlert()
        alert.addButton(withTitle: "OK")
        alert.messageText = alertString
        alert.informativeText = infoString
        alert.alertStyle = .warning
        if let window = view.window {
            alert.beginSheetModal(for: window, completionHandler: nil)
        }
    }
    
    func requirementsSatisfied(reqValidator: Requiredable) -> Bool {
        guard reqValidator.requirementFulfilled() else {
            showAlert(alertString: "Potrebno je ispuniti sva obavezna polja", infoString: "")
            return false
        }
        
        return true
    }
    
    func cancelButtonPressed() {
        dismiss(self)
    }
    
}
