//
//  ConfirmViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 17/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa


class ConfirmViewController: NSViewController {
    
    @IBOutlet weak var confirmLabel: NSTextField!
    @IBOutlet weak var yesButton: NSButton!
    @IBOutlet weak var noButton: NSButton!
    
    var originButton: EditButton!
    weak var connectVC: DbConnectViewController!
    var partnerId: Int?
    var shipment: Bool?
    
    let areYouSure = "Jeste li sigurni da želite izbrisati "
    let yes = "Da"
    let no = "Ne"
    let deleteFrom = "DELETE FROM "
    let whereClause = " WHERE "
    let update = "UPDATE "
    let set = " SET "
    
    var client: SQLClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = originButton.type.rawValue
        
        client = SQLClient.sharedInstance()
        
        setupButtons()
        
        switch originButton.type! {
        case .Item:
            yesButton.action = #selector(ConfirmViewController.deleteItem)
        case .Company:
            yesButton.action = #selector(ConfirmViewController.deleteCompany)
        case .Country:
            yesButton.action = #selector(ConfirmViewController.deleteCountry)
        case .Person:
            yesButton.action = #selector(ConfirmViewController.deletePerson)
        case .Document:
            yesButton.action = #selector(ConfirmViewController.deleteDocument)
        case .Place:
            if originButton.subType == Tables.Partner {
                yesButton.action = #selector(ConfirmViewController.deletePlaceFromPartner)
            } else {
                yesButton.action = #selector(ConfirmViewController.deletePlace)
            }
        case .Unit:
            yesButton.action = #selector(ConfirmViewController.deleteUnit)
        case .Partner:
            break
        }
        
        noButton.action = #selector(ConfirmViewController.exit)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmViewController.error(notification:)), name: NSNotification.Name.SQLClientError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ConfirmViewController.message(notification:)), name: NSNotification.Name.SQLClientMessage, object: nil)
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        NotificationCenter.default.removeObserver(self)
    }
    
    func deleteItem() {
        let initDict: [String: Any] = ["SifArtikla" : originButton.item!.code!]
        guard let item = Item(JSON: initDict) else { return }
        
        executeDeleteItem(item: item) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deleteCompany() {
        let initDict: [String: Any] = ["IdTvrtke" : originButton.company!.companyId!]
        guard let company = Company(JSON: initDict) else { return }
        
        executeDeleteCompany(company: company) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deleteCountry() {
        let initDict: [String: Any] = ["OznDrzave" : originButton.country!.mark!]
        guard let country = Country(JSON: initDict) else { return }
        
        executeDeleteCountry(country: country) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deletePerson() {
        let initDict: [String: Any] = ["IdOsobe" : originButton.person!.id!]
        guard let person = Person(JSON: initDict) else { return }
        
        executeDeletePerson(person: person) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deleteDocument() {
        let initDict: [String: Any] = ["IdDokumenta" : originButton.doc!.docId!]
        guard let doc = Document(JSON: initDict) else { return }
        
        executeDeleteDocument(doc: doc) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deletePlace() {
        let initDict: [String: Any] = ["IdMjesta" : originButton.place!.id!]
        guard let place = Place(JSON: initDict) else { return }
        
        executeDeletePlace(place: place) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deleteUnit() {
        let initDict: [String: Any] = ["IdStavke" : originButton.unit!.unitId!]
        guard let unit = Unit(JSON: initDict) else { return }
        
        executeDeleteUnit(unit: unit) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deletePlaceFromPartner() {
        guard let `shipment` = shipment, let `partnerId` = partnerId else {
            return
        }
        
        executeRemovePlaceFromPartner(shipment: shipment, partnerId: partnerId) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func exit() {
        dismiss(self)
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
    
    func setupButtons() {
        noButton.title = no
        yesButton.title = yes
        switch originButton.type! {
        case .Item:
            confirmLabel.stringValue = areYouSure + (originButton.item!.name ?? originButton.type.rawValue) + "?"
        case .Company:
            confirmLabel.stringValue = areYouSure + (originButton.type.rawValue) + "?"
        case .Country:
            confirmLabel.stringValue = areYouSure + (originButton.country!.name ?? originButton.type.rawValue) + "?"
        case .Person:
            confirmLabel.stringValue = areYouSure + (originButton.type.rawValue) + "?"
        case .Document:
            confirmLabel.stringValue = areYouSure + (originButton.type.rawValue) + "?"
        case .Place:
            confirmLabel.stringValue = areYouSure + (originButton.type.rawValue) + "?"
        case .Unit:
            confirmLabel.stringValue = areYouSure + (originButton.type.rawValue) + "?"
        case .Partner:
            break
        }
    }
    
    func executeDeleteItem(item: Item, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Item.rawValue
        query = query + whereClause + "SifArtikla = '\(item.code!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func executeDeleteCountry(country: Country, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Country.rawValue
        query = query + whereClause + "OznDrzave = '\(country.mark!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func executeDeleteDocument(doc: Document, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Document.rawValue
        query = query + whereClause + "IdDokumenta = '\(doc.docId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func executeDeleteUnit(unit: Unit, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Unit.rawValue
        query = query + whereClause + "IdStavke = '\(unit.unitId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func executeDeletePlace(place: Place, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Place.rawValue
        query = query + whereClause + "IdMjesta = '\(place.id!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func executeDeleteCompany(company: Company, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Company.rawValue
        query = query + whereClause + "IdTvrtke = '\(company.companyId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func executeDeletePerson(person: Person, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = deleteFrom + Tables.Person.rawValue
        query = query + whereClause + "IdOsobe = '\(person.id!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    func executeRemovePlaceFromPartner(shipment: Bool, partnerId: Int?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Partner.rawValue + set
        if shipment {
            query = query + "IdMjestaIsporuke = NULL"
        } else {
            query = query + "IdMjestaPartnera = NULL"
        }
        query = query + whereClause + "IdPartnera = '\(partnerId!)'; "
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
}
