//
//  EditPresenter.swift
//  DbClient
//
//  Created by Filip Fajdetic on 19/05/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class EditPresenter {
    
    weak var viewController: EditViewController!
    
    func configureWithItem(item: Item?) {
        
        viewController.firstStaticLabel.stringValue = Item.Attributes.code
        viewController.firstLabel.stringValue = item?.code?.description ?? ""
        viewController.secondStaticLabel.stringValue = Item.Attributes.text
        viewController.secondLabel.stringValue = item?.text ?? ""
        viewController.thirdStaticLabel.stringValue = Item.Attributes.price
        viewController.thirdLabel.stringValue = item?.price?.description ?? ""
        viewController.fourthStaticLabel.stringValue = Item.Attributes.measUnit
        viewController.fourthLabel.stringValue = item?.measUnit ?? ""
        viewController.fifthStaticLabel.stringValue = Item.Attributes.secU
        viewController.fifthLabel.stringValue = item?.secU?.description ?? ""
        viewController.sixthStaticLabel.stringValue = Item.Attributes.name
        viewController.sixthLabel.stringValue = item?.name ?? ""
        
        viewController.seventhStackView.isHidden = true
        viewController.eightStackView.isHidden = true
        viewController.ninthStackView.isHidden = true
        viewController.tenthStackView.isHidden = true
        viewController.eleventhStackView.isHidden = true
    }
    
}
