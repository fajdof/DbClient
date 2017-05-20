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
        switch viewController.originButton.type! {
        case .Item:
            viewController.confirmLabel.stringValue = areYouSure + (viewController.originButton.item!.name ?? viewController.originButton.type.rawValue) + "?"
        case .Company:
            viewController.confirmLabel.stringValue = areYouSure + (viewController.originButton.type.rawValue) + "?"
        case .Country:
            viewController.confirmLabel.stringValue = areYouSure + (viewController.originButton.country!.name ?? viewController.originButton.type.rawValue) + "?"
        case .Person:
            viewController.confirmLabel.stringValue = areYouSure + (viewController.originButton.type.rawValue) + "?"
        case .Document:
            viewController.confirmLabel.stringValue = areYouSure + (viewController.originButton.type.rawValue) + "?"
        case .Place:
            viewController.confirmLabel.stringValue = areYouSure + (viewController.originButton.type.rawValue) + "?"
        case .Unit:
            viewController.confirmLabel.stringValue = areYouSure + (viewController.originButton.type.rawValue) + "?"
        case .Partner:
            break
        }
    }
    
}
