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
    
    convenience init(databaseProvider: DatabaseProvider) {
        self.init()
        self.databaseProvider = databaseProvider
    }
    
    init() {
        client = SQLClient.sharedInstance()
    }
    
    func getItems() -> [Item] {
        return databaseProvider.items.map({ (itemDAL) -> Item in
            return Item(itemDAL: itemDAL)
        })
    }
    
    func getDocs() -> [Document] {
        return databaseProvider.docs.map({ (docDAL) -> Document in
            return Document(docDAL: docDAL)
        })
    }
    
    func getPartners() -> [Partner] {
        return databaseProvider.partners.map({ (partnerDAL) -> Partner in
            return Partner(partnerDAL: partnerDAL)
        })
    }
    
    func getUnits() -> [Unit] {
        return databaseProvider.units.map({ (unitDAL) -> Unit in
            return Unit(unitDAL: unitDAL)
        })
    }
    
    func getPeople() -> [Person] {
        return databaseProvider.people.map({ (personDAL) -> Person in
            return Person(personDAL: personDAL)
        })
    }
    
    func getCompanies() -> [Company] {
        return databaseProvider.companies.map({ (companyDAL) -> Company in
            return Company(companyDAL: companyDAL)
        })
    }
    
    func getPlaces() -> [Place] {
        return databaseProvider.places.map({ (placeDAL) -> Place in
            return Place(placeDAL: placeDAL)
        })
    }
    
    func getCountries() -> [Country] {
        return databaseProvider.countries.map({ (countryDAL) -> Country in
            return Country(countryDAL: countryDAL)
        })
    }
    
}
