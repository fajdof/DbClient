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
    
    var originButton: EditButton!
    let presenter = EditPresenter()
    let viewModel = EditViewModel()
    weak var connectVC: DbConnectViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = originButton.type.rawValue
        
        presenter.viewController = self
        
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
                presenter.configureWithCompany(company: company)
            }
            saveButton.action = #selector(EditViewController.updateCompany)
        case .Country:
            if let country = originButton.country {
                self.presenter.configureWithCountry(country: country)
            }
            saveButton.action = #selector(EditViewController.updateCountry)
        case .Person:
            if let person = originButton.person {
                self.presenter.configureWithPerson(person: person)
            }
            saveButton.action = #selector(EditViewController.updatePerson)
        case .Document:
            if let document = originButton.doc {
                self.presenter.configureWithDocument(doc: document)
            }
            saveButton.action = #selector(EditViewController.updateDocument)
        case .Place:
            if let place = originButton.place {
                self.presenter.configureWithPlace(place: place)
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
        
        if let price = Double(thirdLabel.stringValue) {
            item.price = price
        }
        if let secU = Int(fifthLabel.stringValue) {
            item.secU = NSNumber(integerLiteral: secU)
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
        
        if let price = Double(thirdLabel.stringValue) {
            item.price = price
        }
        if let secU = Int(fifthLabel.stringValue) {
            item.secU = NSNumber(integerLiteral: secU)
        }
        if let code = Int(firstLabel.stringValue) {
            item.code = code
        }
        
        viewModel.addItem(item: item) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func updateCompany() {
        
    }
    
    func updateCountry() {
        
    }
    
    func updatePerson() {
        
    }
    
    func updateDocument() {
        
    }
    
    func updatePlace() {
        
    }
    
    func updateUnit() {
        
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
    
}
