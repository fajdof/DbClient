//
//  SecServiceViewController.swift
//  DbClient
//
//  Created by Filip Fajdetic on 13/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation
import Cocoa

protocol SecServiceDelegate {
    func secServiceChosen(integerLiteral: Int)
}


class SecServiceViewController: NSViewController {
    
    @IBOutlet weak var yesButton: NSButton!
    @IBOutlet weak var noButton: NSButton!
    
    var delegate: SecServiceDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Zaštitna usluga"
        yesButton.title = "Da"
        noButton.title = "Ne"
        
        yesButton.target = self
        yesButton.action = #selector(SecServiceViewController.yesChosen)
        noButton.target = self
        noButton.action = #selector(SecServiceViewController.noChosen)
    }
    
    func yesChosen() {
        delegate.secServiceChosen(integerLiteral: 1)
        dismiss(self)
    }
    
    func noChosen() {
        delegate.secServiceChosen(integerLiteral: 0)
        dismiss(self)
    }
    
}
