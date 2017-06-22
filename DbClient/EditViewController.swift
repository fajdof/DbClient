//
//  EditViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 17/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa

class EditViewController: NSViewController, ChooseCountryDelegate, SecServiceDelegate {
    
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
    @IBOutlet weak var listShowStackView: NSStackView!
    @IBOutlet weak var listShowStaticLabel: NSTextField!
    @IBOutlet weak var listShowButton: NSButton!
    
    var originButton: EditButton!
    weak var connectVC: DbConnectViewController!
    var isPerson: Bool = false
    let required = " *"
    
    let generatorService = IdGeneratorService()
    
    var chosenCountry: Country?
    var secU: NSNumber?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = originButton.type.rawValue
        
        cancelButton.action = #selector(EditViewController.cancelButtonPressed)
        cancelButton.target = self
        saveButton.target = self
        listShowButton.target = self
        
        chosenCountry = connectVC.countries.first
        secU = originButton.item?.secU ?? NSNumber(integerLiteral: 1)
        
        switch originButton.type! {
        case .Item:
            listShowButton.action = #selector(EditViewController.showSecService)
            if let item = originButton.item {
                configureWithItem(item: item)
                saveButton.action = #selector(EditViewController.updateItem)
            } else {
                configureWithItem(item: nil)
                saveButton.action = #selector(EditViewController.addItem)
            }
        case .Company:
            if let company = originButton.company {
                if originButton.subType == Tables.Place {
                    configureWithPlace(place: nil, withId: true, countryMark: connectVC.countries.first?.mark)
                    saveButton.action = #selector(EditViewController.addPlaceToPartner)
                    title = Tables.Place.rawValue
                    listShowButton.action = #selector(EditViewController.showCountryList)
                } else {
                    if originButton.subType == Tables.Document {
                        configureWithDocument(doc: nil, fromPartner: true)
                        saveButton.action = #selector(EditViewController.addDocToPartner)
                    } else {
                        configureWithCompany(company: company)
                        saveButton.action = #selector(EditViewController.updateCompany)
                    }
                }
            } else {
                configureWithCompany(company: nil)
                saveButton.action = #selector(EditViewController.addCompany)
            }
        case .Country:
            if let country = originButton.country {
                if originButton.subType == Tables.Place {
                    configureWithPlace(place: nil, withId: false, countryMark: nil)
                    saveButton.action = #selector(EditViewController.addPlace)
                    title = Tables.Place.rawValue
                } else {
                    configureWithCountry(country: country)
                    saveButton.action = #selector(EditViewController.updateCountry)
                }
            } else {
                configureWithCountry(country: nil)
                saveButton.action = #selector(EditViewController.addCountry)
            }
        case .Person:
            if let person = originButton.person {
                if originButton.subType == Tables.Place {
                    configureWithPlace(place: nil, withId: true, countryMark: connectVC.countries.first?.mark)
                    saveButton.action = #selector(EditViewController.addPlaceToPartner)
                    title = Tables.Place.rawValue
                    listShowButton.action = #selector(EditViewController.showCountryList)
                } else {
                    if originButton.subType == Tables.Document {
                        configureWithDocument(doc: nil, fromPartner: true)
                        saveButton.action = #selector(EditViewController.addDocToPartner)
                    } else {
                        configureWithPerson(person: person)
                        saveButton.action = #selector(EditViewController.updatePerson)
                    }
                }
            } else {
                configureWithPerson(person: nil)
                saveButton.action = #selector(EditViewController.addPerson)
            }
        case .Document:
            if let document = originButton.doc {
                if originButton.subType == Tables.Unit {
                    configureWithUnit(unit: nil)
                    saveButton.action = #selector(EditViewController.addUnit)
                    title = Tables.Unit.rawValue
                    listShowButton.action = #selector(EditViewController.showSecService)
                } else {
                    if originButton.subType == Tables.Document {
                        configureWithDocId()
                        saveButton.action = #selector(EditViewController.addBeforeDoc)
                    } else {
                        configureWithDocument(doc: document, fromPartner: false)
                        saveButton.action = #selector(EditViewController.updateDocument)
                    }
                }
            } else {
                configureWithDocument(doc: nil, fromPartner: false)
                saveButton.action = #selector(EditViewController.addDocument)
            }
        case .Place:
            if let place = originButton.place {
                configureWithPlace(place: place, withId: false, countryMark: nil)
            }
            saveButton.action = #selector(EditViewController.updatePlace)
        case .Unit:
            if let unit = originButton.unit {
                configureWithUnit(unit: unit)
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
    
    func showCountryList() {
        let modalStoryboard = NSStoryboard(name: "Modal", bundle: nil)
        let chooseVC = modalStoryboard.instantiateController(withIdentifier: "ChooseCountryViewController") as! ChooseCountryViewController
        chooseVC.countries = connectVC.countries
        chooseVC.delegate = self
        presentViewControllerAsModalWindow(chooseVC)
    }
    
    func countryChosen(country: Country) {
        chosenCountry = country
        listShowButton.title = country.mark ?? ""
    }
    
    func showSecService() {
        let modalStoryboard = NSStoryboard(name: "Modal", bundle: nil)
        let secVC = modalStoryboard.instantiateController(withIdentifier: "SecServiceViewController") as! SecServiceViewController
        secVC.delegate = self
        presentViewControllerAsModalWindow(secVC)
    }
    
    func secServiceChosen(integerLiteral: Int) {
        secU = NSNumber(integerLiteral: integerLiteral)
        if integerLiteral == 1 {
            listShowButton.title = "Da"
        } else {
            listShowButton.title = "Ne"
        }
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
        
        item.secU = secU
        
        guard requirementsSatisfied(reqValidator: ItemReqValidator(item: item)) else {
            return
        }
        
        item.price = Double(thirdLabel.stringValue)
        
        let (valid, error) = item.validateWithError()
        
        if valid {
            let provider = ItemBLLProvider()
            provider.updateItem(item: item, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        item.secU = secU
        
        guard requirementsSatisfied(reqValidator: ItemReqValidator(item: item)) else {
            return
        }
        
        item.price = Double(thirdLabel.stringValue)
        
        let (valid, error) = item.validateWithError()
        
        if valid {
            let provider = ItemBLLProvider()
            provider.addItem(item: item, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = company.validateWithError()
        
        if valid {
            let provider = CompanyBLLProvider()
            provider.updateCompany(company: company, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = company.validateWithError()
        
        if valid {
            let provider = CompanyBLLProvider()
            provider.addCompany(company: company, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = country.validateWithError()
        
        if valid {
            let provider = CountryBLLProvider()
            provider.updateCountry(country: country, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = country.validateWithError()
        
        if valid {
            let provider = CountryBLLProvider()
            provider.addCountry(country: country, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = person.validateWithError()
        
        if valid {
            let provider = PersonBLLProvider()
            provider.updatePerson(person: person, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = person.validateWithError()
        
        if valid {
            let provider = PersonBLLProvider()
            provider.addPerson(person: person, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = doc.validateWithError()
        
        if valid {
            let provider = DocumentBLLProvider()
            provider.updateDocument(doc: doc, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
            
            if let (_, error) = person?.validateWithError() {
                if let err = error {
                    showAlert(alertString: err, infoString: "")
                    return
                }
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
            
            if let (_, error) = company?.validateWithError() {
                if let err = error {
                    showAlert(alertString: err, infoString: "")
                    return
                }
            }
            
        }
        
        let (valid, error) = doc.validateWithError()
        
        if valid {
            let provider = DocumentBLLProvider()
            provider.addDocument(doc: doc, company: company, person: person, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = place.validateWithError()
        
        if valid {
            let provider = PlaceBLLProvider()
            provider.updatePlace(place: place, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = place.validateWithError()
        
        if valid {
            let provider = CountryBLLProvider()
            provider.addPlaceToCountry(place: place, countryMark: originButton.country?.mark, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = unit.validateWithError()
        
        if valid {
            let provider = UnitBLLProvider()
            provider.updateUnit(unit: unit, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        item.secU = secU
        item.code = generatorService.generateIdForItem(items: connectVC.items)
        
        guard requirementsSatisfied(reqValidator: ItemReqValidator(item: item)) else {
            return
        }
        
        item.price = Double(seventhLabel.stringValue)
        
        var (valid, error) = item.validateWithError()
        if let err = error {
            showAlert(alertString: err, infoString: "")
        }
        
        (valid, error) = unit.validateWithError()
        
        if valid {
            let provider = DocumentBLLProvider()
            provider.addUnitToDocument(unit: unit, docId: originButton.doc?.docId, item: item, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
        }
    }
    
    func addPlaceToPartner() {
        let initDict: [String: Any] = [:]
        guard let place = Place(JSON: initDict) else { return }
        
        place.name = firstLabel.stringValue
        if fourthLabel.stringValue.isEmpty == false {
            place.postalCode = 0
        }
        place.postalName = fifthLabel.stringValue
        if thirdLabel.stringValue.isEmpty == false {
            place.id = 0
        }
        
        guard requirementsSatisfied(reqValidator: PlaceReqValidator(place: place)) else {
            return
        }
        
        place.postalCode = Int(fourthLabel.stringValue)
        place.id = generatorService.generateIdForPlace(places: connectVC.places)
        
        let partnerId = originButton.person?.id ?? originButton.company!.companyId!
        
        guard let country = chosenCountry else {
            return
        }
        
        let (valid, error) = place.validateWithError()
        
        if valid {
            let provider = PartnerBLLProvider()
            provider.addPlaceToPartner(place: place, country: country, partnerId: partnerId, shipment: originButton.shipment, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
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
        
        let (valid, error) = doc.validateWithError()
        
        if valid {
            let provider = PartnerBLLProvider()
            provider.addDocToPartner(doc: doc, partnerId: partnerId, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
        } else {
            if let err = error {
                showAlert(alertString: err, infoString: "")
            }
        }
    }
    
    func addBeforeDoc() {
        if let beforeDocId = Int(firstLabel.stringValue) {
            let provider = DocumentBLLProvider()
            provider.addBeforeDoc(docId: originButton.doc?.docId, beforeDocId: beforeDocId, completion: { [weak self] (data) in
                guard let `self` = self else { return }
                self.dismiss(self)
                self.connectVC.emptyDatasource()
                self.connectVC.startQueryIterations()
            })
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
    
    func cancelButtonPressed() {
        dismiss(self)
    }
    
    func configureWithItem(item: Item?) {
        secondStaticLabel.stringValue = Item.Attributes.text
        thirdStaticLabel.stringValue = Item.Attributes.price + required
        fourthStaticLabel.stringValue = Item.Attributes.measUnit + required
        listShowStaticLabel.stringValue = Item.Attributes.secU + required
        sixthStaticLabel.stringValue = Item.Attributes.name + required
        secondLabel.stringValue = item?.text ?? ""
        thirdLabel.stringValue = item?.price?.description ?? ""
        fourthLabel.stringValue = item?.measUnit ?? ""
        fifthLabel.stringValue = item?.secU?.description ?? ""
        sixthLabel.stringValue = item?.name ?? ""
        listShowButton.title = "Da"
        if let secU = item?.secU?.intValue {
            if secU == 0 {
                listShowButton.title = "Ne"
            }
        }
        
        firstStackView.isHidden = true
        seventhStackView.isHidden = true
        eightStackView.isHidden = true
        ninthStackView.isHidden = true
        tenthStackView.isHidden = true
        eleventhStackView.isHidden = true
        twelvethStackView.isHidden = true
        fifthStackView.isHidden = true
    }
    
    func configureWithCompany(company: Company?) {
        secondStaticLabel.stringValue = Company.CompanyAttributes.name + required
        secondLabel.stringValue = company?.name ?? ""
        thirdStaticLabel.stringValue = Company.CompanyAttributes.registryNumber + required
        thirdLabel.stringValue = company?.registryNumber ?? ""
        fourthStaticLabel.stringValue = Company.Attributes.oib + required
        fourthLabel.stringValue = company?.oib ?? ""
        fifthStaticLabel.stringValue = Company.Attributes.partnerAddress
        fifthLabel.stringValue = company?.partnerAddress ?? ""
        seventhStaticLabel.stringValue = Company.Attributes.shipmentAddress
        seventhLabel.stringValue = company?.shipmentAddress ?? ""
        
        firstStackView.isHidden = true
        sixthStackView.isHidden = true
        eightStackView.isHidden = true
        ninthStackView.isHidden = true
        tenthStackView.isHidden = true
        eleventhStackView.isHidden = true
        twelvethStackView.isHidden = true
        listShowStackView.isHidden = true
    }
    
    func configureWithPerson(person: Person?) {
        firstStaticLabel.stringValue = Person.PersonAttributes.firstName + required
        firstLabel.stringValue = person?.firstName ?? ""
        secondStaticLabel.stringValue = Person.PersonAttributes.lastName + required
        secondLabel.stringValue = person?.lastName ?? ""
        fourthStaticLabel.stringValue = Person.Attributes.oib + required
        fourthLabel.stringValue = person?.oib ?? ""
        fifthStaticLabel.stringValue = Person.Attributes.partnerAddress
        fifthLabel.stringValue = person?.partnerAddress ?? ""
        seventhStaticLabel.stringValue = Person.Attributes.shipmentAddress
        seventhLabel.stringValue = person?.shipmentAddress ?? ""
        
        thirdStackView.isHidden = true
        sixthStackView.isHidden = true
        eightStackView.isHidden = true
        ninthStackView.isHidden = true
        tenthStackView.isHidden = true
        eleventhStackView.isHidden = true
        twelvethStackView.isHidden = true
        listShowStackView.isHidden = true
    }
    
    func configureWithCountry(country: Country?) {
        firstStaticLabel.stringValue = Country.Attributes.name + required
        firstLabel.stringValue = country?.name ?? ""
        secondStaticLabel.stringValue = Country.Attributes.code + required
        secondLabel.stringValue = country?.code?.description ?? ""
        thirdStaticLabel.stringValue = Country.Attributes.mark + required
        thirdLabel.stringValue = country?.mark ?? ""
        fourthStaticLabel.stringValue = Country.Attributes.iso3 + required
        fourthLabel.stringValue = country?.iso3 ?? ""
        
        if country != nil {
            thirdLabel.isBezeled = false
            thirdLabel.isEditable = false
        }
        
        fifthStackView.isHidden = true
        sixthStackView.isHidden = true
        seventhStackView.isHidden = true
        eightStackView.isHidden = true
        ninthStackView.isHidden = true
        tenthStackView.isHidden = true
        eleventhStackView.isHidden = true
        twelvethStackView.isHidden = true
        listShowStackView.isHidden = true
    }
    
    func configureWithDocument(doc: Document?, fromPartner: Bool) {
        firstStaticLabel.stringValue = Document.Attributes.docId + required
        firstLabel.stringValue = doc?.docId?.description ?? ""
        secondStaticLabel.stringValue = Document.Attributes.docNumber + required
        secondLabel.stringValue = doc?.docNumber?.description ?? ""
        thirdStaticLabel.stringValue = Document.Attributes.docValue + required
        thirdLabel.stringValue = doc?.docValue?.description ?? ""
        fourthStaticLabel.stringValue = Document.Attributes.docVr
        fourthLabel.stringValue = doc?.docVr ?? ""
        fifthStaticLabel.stringValue = Document.Attributes.tax + required
        fifthLabel.stringValue = doc?.tax?.description ?? ""
        twelvethStaticLabel.stringValue = Document.Attributes.docDate + required
        datePicker.dateValue = doc?.docDate ?? Date()
        
        if doc != nil || fromPartner {
            seventhStackView.isHidden = true
            eightStackView.isHidden = true
            ninthStackView.isHidden = true
            firstLabel.isEditable = false
            firstLabel.isBezeled = false
            if fromPartner {
                firstStackView.isHidden = true
            }
        } else {
            firstStackView.isHidden = true
            if isPerson {
                seventhStaticLabel.stringValue = Person.PersonAttributes.firstName + required
                eightStaticLabel.stringValue = Person.PersonAttributes.lastName + required
                ninthStaticLabel.stringValue = Person.Attributes.oib + required
            } else {
                seventhStaticLabel.stringValue = Company.CompanyAttributes.name + required
                eightStaticLabel.stringValue = Company.CompanyAttributes.registryNumber + required
                ninthStaticLabel.stringValue = Company.Attributes.oib + required
            }
        }
        
        sixthStackView.isHidden = true
        tenthStackView.isHidden = true
        eleventhStackView.isHidden = true
        listShowStackView.isHidden = true
    }
    
    func configureWithUnit(unit: Unit?) {
        firstStaticLabel.stringValue = Unit.Attributes.itemPrice + required
        firstLabel.stringValue = unit?.itemPrice?.description ?? ""
        secondStaticLabel.stringValue = Unit.Attributes.itemQuantity + required
        secondLabel.stringValue = unit?.itemQuantity?.description ?? ""
        thirdStaticLabel.stringValue = Unit.Attributes.discount + required
        thirdLabel.stringValue = unit?.discount?.description ?? ""
        
        if unit != nil {
            sixthStackView.isHidden = true
            seventhStackView.isHidden = true
            eightStackView.isHidden = true
            tenthStackView.isHidden = true
            listShowStackView.isHidden = true
        } else {
            sixthStaticLabel.stringValue = Item.Attributes.text
            seventhStaticLabel.stringValue = Item.Attributes.price + required
            eightStaticLabel.stringValue = Item.Attributes.measUnit + required
            listShowStaticLabel.stringValue = Item.Attributes.secU + required
            tenthStaticLabel.stringValue = Item.Attributes.name + required
            listShowButton.title = "Da"
        }
        
        fifthStackView.isHidden = true
        fourthStackView.isHidden = true
        eleventhStackView.isHidden = true
        twelvethStackView.isHidden = true
        ninthStackView.isHidden = true
    }
    
    func configureWithPlace(place: Place?, withId: Bool, countryMark: String?) {
        firstStaticLabel.stringValue = Place.Attributes.name + required
        firstLabel.stringValue = place?.name ?? ""
        fourthStaticLabel.stringValue = Place.Attributes.postalCode + required
        fourthLabel.stringValue = place?.postalCode?.description ?? ""
        fifthStaticLabel.stringValue = Place.Attributes.postalName
        fifthLabel.stringValue = place?.postalName ?? ""
        thirdStaticLabel.stringValue = Place.Attributes.id + required
        thirdLabel.stringValue = place?.id?.description ?? ""
        
        if withId {
            listShowStaticLabel.stringValue = "Oznaka države: " + required
            listShowStackView.isHidden = false
            listShowButton.title = countryMark ?? "Odaberite državu"
        } else {
            listShowStackView.isHidden = true
        }
        
        thirdStackView.isHidden = true
        eightStackView.isHidden = true
        ninthStackView.isHidden = true
        sixthStackView.isHidden = true
        seventhStackView.isHidden = true
        secondStackView.isHidden = true
        tenthStackView.isHidden = true
        eleventhStackView.isHidden = true
        twelvethStackView.isHidden = true
    }
    
    
    func configureWithDocId() {
        firstStaticLabel.stringValue = "Id prethodnog dokumenta: "
        
        secondStackView.isHidden = true
        thirdStackView.isHidden = true
        fourthStackView.isHidden = true
        fifthStackView.isHidden = true
        sixthStackView.isHidden = true
        seventhStackView.isHidden = true
        eightStackView.isHidden = true
        ninthStackView.isHidden = true
        tenthStackView.isHidden = true
        eleventhStackView.isHidden = true
        twelvethStackView.isHidden = true
    }
    
    func requirementsSatisfied(reqValidator: Requiredable) -> Bool {
        guard reqValidator.requirementFulfilled() else {
            showAlert(alertString: "Potrebno je ispuniti sva obavezna polja", infoString: "")
            return false
        }
        
        return true
    }
    
}
