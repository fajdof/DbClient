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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = originButton.type.rawValue
        
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
        
        let provider = ItemBLLProvider()
        provider.deleteItem(item: item, completion: { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        })
    }
    
    func deleteCompany() {
        let initDict: [String: Any] = ["IdTvrtke" : originButton.company!.companyId!]
        guard let company = Company(JSON: initDict) else { return }
        
        let provider = CompanyBLLProvider()
        provider.deleteCompany(company: company, completion: { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        })
    }
    
    func deleteCountry() {
        let initDict: [String: Any] = ["OznDrzave" : originButton.country!.mark!]
        guard let country = Country(JSON: initDict) else { return }
        
        let provider = CountryBLLProvider()
        provider.deleteCountry(country: country, completion: { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        })
    }
    
    func deletePerson() {
        let initDict: [String: Any] = ["IdOsobe" : originButton.person!.id!]
        guard let person = Person(JSON: initDict) else { return }
        
        let provider = PersonBLLProvider()
        provider.deletePerson(person: person, completion: { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        })
    }
    
    func deleteDocument() {
        let initDict: [String: Any] = ["IdDokumenta" : originButton.doc!.docId!]
        guard let doc = Document(JSON: initDict) else { return }
        
        let provider = DocumentBLLProvider()
        provider.deleteDocument(doc: doc, completion: { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        })
    }
    
    func deletePlace() {
        let initDict: [String: Any] = ["IdMjesta" : originButton.place!.id!]
        guard let place = Place(JSON: initDict) else { return }
        
        let provider = PlaceBLLProvider()
        provider.deletePlace(place: place, completion: { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        })
    }
    
    func deleteUnit() {
        let initDict: [String: Any] = ["IdStavke" : originButton.unit!.unitId!]
        guard let unit = Unit(JSON: initDict) else { return }
        
        let provider = UnitBLLProvider()
        provider.deleteUnit(unit: unit, completion: { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        })
    }
    
    func deletePlaceFromPartner() {
        guard let `shipment` = shipment, let `partnerId` = partnerId else {
            return
        }
        
        let provider = PartnerBLLProvider()
        provider.removePlaceFromPartner(shipment: shipment, partnerId: partnerId, completion: { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        })
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
    
}
