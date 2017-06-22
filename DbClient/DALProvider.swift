//
//  DALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation

class DALProvider {
    
    let update = "UPDATE "
    let set = " SET "
    let whereClause = " WHERE "
    let colon = ", "
    let insert = "INSERT INTO "
    let values = " VALUES "
    let deleteFrom = "DELETE FROM "
    
    var client: SQLClient?
    var databaseProvider: DatabaseProvider!
    
    init() {
        client = SQLClient.sharedInstance()
        databaseProvider = DatabaseProvider()
    }
    
    func connectToSqlServer(completion: @escaping (_ completed: Bool) -> ()) {
        databaseProvider.connectToSqlServer(completion: completion)
    }
    
    func executeQuery(table: Tables,  completion: @escaping (_ dbData: [Any]?) -> ()) {
        databaseProvider.executeQuery(table: table, completion: completion)
    }
    
    func proccessQuery(data: [Any], type: Tables) {
        databaseProvider.proccessQuery(data: data, type: type)
    }
    
    func connectUnitsWithItemsAndDocs(completion: @escaping () -> ()) {
        databaseProvider.connectUnitsWithItemsAndDocs(completion: completion)
    }
    
    func connectCountriesAndPlaces(completion: @escaping () -> ()) {
        databaseProvider.connectCountriesAndPlaces(completion: completion)
    }
    
    func connectPlacesAndPartners(completion: @escaping () -> ()) {
        databaseProvider.connectPlacesAndPartners(completion: completion)
    }
    
    func connectDocsWithPartnersAndPreviousDocs(completion: @escaping () -> ()) {
        databaseProvider.connectDocsWithPartnersAndPreviousDocs(completion: completion)
    }
    
    func addPartnerPropertiesToPerson(completion: @escaping () -> ()) {
        databaseProvider.addPartnerPropertiesToPerson(completion: completion)
    }
    
    func addPartnerPropertiesToCompany(completion: @escaping () -> ()) {
        databaseProvider.addPartnerPropertiesToCompany(completion: completion)
    }
    
    func getItems() -> [Item] {
        return databaseProvider.items
    }
    
    func getDocs() {
        
    }
    
    func getPartners() {
        
    }
    
    func getUnits() {
        
    }
    
    func getPeople() {
        
    }
    
    func getCompanies() {
        
    }
    
    func getPlaces() {
        
    }
    
    func getCountries() {
        
    }
    
}
