//
//  ChooseCountryViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 12/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa

protocol ChooseCountryDelegate {
    func countryChosen(country: Country)
}

class ChooseCountryViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    
    let countryView = "CountryView"
    var countries: [Country] = []
    var delegate: ChooseCountryDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NSNib(nibNamed: countryView, bundle: nil), forIdentifier: countryView)
        title = "Oznaka države"
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cellView = tableView.make(withIdentifier: countryView, owner: self) as! CountryView
        cellView.titleLabel.stringValue = countries[row].mark ?? ""
        
        return cellView
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        delegate.countryChosen(country: countries[row])
        dismiss(self)
        return true
    }
    
    
}
