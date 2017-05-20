//
//  ChoosePresenter.swift
//  DbClient
//
//  Created by Filip Fajdetic on 20/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class ChoosePresenter {
    
    weak var viewController: ChooseViewController!
    let choosePartnerType = "Odaberite vrstu partnera"
    
    func setUp() {
        viewController.chooseLabel.stringValue = choosePartnerType
        viewController.companyButton.title = Tables.Company.rawValue
        viewController.personButton.title = Tables.Person.rawValue
    }
}
