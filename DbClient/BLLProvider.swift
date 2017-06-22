//
//  BLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class BLLProvider {
    
    let dalProvider = DALProvider()
    
    func connectToSqlServer(completion: @escaping (_ completed: Bool) -> ()) {
        dalProvider.connectToSqlServer(completion: completion)
    }
    
    func executeQuery(table: Tables,  completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.executeQuery(table: table, completion: completion)
    }
    
    func proccessQuery(data: [Any], type: Tables) {
        dalProvider.proccessQuery(data: data, type: type)
    }
    
    func connectUnitsWithItemsAndDocs(completion: @escaping () -> ()) {
        dalProvider.connectUnitsWithItemsAndDocs(completion: completion)
    }
    
    func connectCountriesAndPlaces(completion: @escaping () -> ()) {
        dalProvider.connectCountriesAndPlaces(completion: completion)
    }
    
    func connectPlacesAndPartners(completion: @escaping () -> ()) {
        dalProvider.connectPlacesAndPartners(completion: completion)
    }
    
    func connectDocsWithPartnersAndPreviousDocs(completion: @escaping () -> ()) {
        dalProvider.connectDocsWithPartnersAndPreviousDocs(completion: completion)
    }
    
    func addPartnerPropertiesToPerson(completion: @escaping () -> ()) {
        dalProvider.addPartnerPropertiesToPerson(completion: completion)
    }
    
    func addPartnerPropertiesToCompany(completion: @escaping () -> ()) {
        dalProvider.addPartnerPropertiesToCompany(completion: completion)
    }
    
}
