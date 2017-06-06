//
//  ChooseViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 20/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa


class ChooseViewController: NSViewController {
    
    @IBOutlet weak var chooseLabel: NSTextField!
    @IBOutlet weak var companyButton: NSButton!
    @IBOutlet weak var personButton: NSButton!
    
    var doc: Document!
    var originButton: EditButton!
    weak var connectVC: DbConnectViewController!
    let choosePartnerType = "Odaberite vrstu partnera"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = Tables.Document.rawValue
        setUp()
        
        companyButton.action = #selector(ChooseViewController.companyPressed)
        personButton.action = #selector(ChooseViewController.personPressed)
        companyButton.target = self
        personButton.target = self
    }
    
    func setUp() {
        chooseLabel.stringValue = choosePartnerType
        companyButton.title = Tables.Company.rawValue
        personButton.title = Tables.Person.rawValue
    }
    
    func personPressed() {
        goToEdit(isPerson: true)
    }
    
    func companyPressed() {
        goToEdit(isPerson: false)
    }
    
    func goToEdit(isPerson: Bool) {
        let modalStoryboard = NSStoryboard(name: "Modal", bundle: nil)
        let editVC = modalStoryboard.instantiateController(withIdentifier: "EditViewController") as! EditViewController
        editVC.originButton = originButton
        editVC.connectVC = connectVC
        editVC.isPerson = isPerson
        dismiss(self)
        presentViewControllerAsModalWindow(editVC)
    }
}
