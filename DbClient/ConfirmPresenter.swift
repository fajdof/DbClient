//
//  ConfirmPresenter.swift
//  DbClient
//
//  Created by Filip Fajdetic on 20/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class ConfirmPresenter {
    
    let areYouSure = "Jeste li sigurni da želite izbrisati "
    let yes = "Da"
    let no = "Ne"
    
    weak var viewController: ConfirmViewController!
    
    func setupButtons() {
        viewController.noButton.title = no
        viewController.yesButton.title = yes
        viewController.confirmLabel.stringValue = areYouSure + viewController.originButton.type.rawValue + "?"
    }
    
}
