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
    let presenter = ConfirmPresenter()
    let viewModel = ConfirmViewModel()
    weak var connectVC: DbConnectViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = originButton.type.rawValue
        
        presenter.viewController = self
        presenter.setupButtons()
        
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
            yesButton.action = #selector(ConfirmViewController.deletePlace)
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
        
        viewModel.deleteItem(item: item) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deleteCompany() {
        
    }
    
    func deleteCountry() {
        let initDict: [String: Any] = ["OznDrzave" : originButton.country!.mark!]
        guard let country = Country(JSON: initDict) else { return }
        
        viewModel.deleteCountry(country: country) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deletePerson() {
        
    }
    
    func deleteDocument() {
        let initDict: [String: Any] = ["IdDokumenta" : originButton.doc!.docId!]
        guard let doc = Document(JSON: initDict) else { return }
        
        viewModel.deleteDocument(doc: doc) { [weak self] (data) in
            guard let `self` = self else { return }
            self.dismiss(self)
            self.connectVC.emptyDatasource()
            self.connectVC.startQueryIterations()
        }
    }
    
    func deletePlace() {
        
    }
    
    func deleteUnit() {
        
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
    
}
