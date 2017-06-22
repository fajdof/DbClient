//
//  PersonBLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class PersonBLLProvider {
    
    let dalProvider = PersonDALProvider()
    
    func updatePerson(person: Person, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.updatePerson(person: person.toDAL() as! PersonDAL, completion: completion)
    }
    
    func addPerson(person: Person, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addPerson(person: person.toDAL() as! PersonDAL, completion: completion)
    }
    
    func deletePerson(person: Person, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.deletePerson(person: person.toDAL() as! PersonDAL, completion: completion)
    }
    
}
