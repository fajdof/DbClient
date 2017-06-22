//
//  PlaceBLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class PlaceBLLProvider {
    
    let dalProvider = PlaceDALProvider()
    
    func updatePlace(place: Place, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.updatePlace(place: place.toDAL() as! PlaceDAL, completion: completion)
    }
    
}
