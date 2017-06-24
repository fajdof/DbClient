//
//  BLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class BLLProvider {
    
    var dalProvider: DALProvider
    
    init(databaseProvider: DatabaseProvider) {
        dalProvider = DALProvider(databaseProvider: databaseProvider)
    }
    
    func getItems() -> [Item] {
        return dalProvider.getItems()
    }
    
    func getDocs() -> [Document] {
        return dalProvider.getDocs()
    }
    
    func getPartners() -> [Partner] {
        return dalProvider.getPartners()
    }
    
    func getUnits() -> [Unit] {
        return dalProvider.getUnits()
    }
    
    func getPeople() -> [Person] {
        return dalProvider.getPeople()
    }
    
    func getCompanies() -> [Company] {
        return dalProvider.getCompanies()
    }
    
    func getPlaces() -> [Place] {
        return dalProvider.getPlaces()
    }
    
    func getCountries() -> [Country] {
        return dalProvider.getCountries()
    }
    
}
