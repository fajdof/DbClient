//
//  PartnerBLLProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class PartnerBLLProvider {
    
    let dalProvider = PartnerDALProvider()
    
    func addPlaceToPartner(place: Place, country: Country, partnerId: Int?, shipment: Bool, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addPlaceToPartner(place: place.toDAL() as! PlaceDAL, country: country.toDAL() as! CountryDAL, partnerId: partnerId, shipment: shipment, completion: completion)
    }
    
    func addDocToPartner(doc: Document, partnerId: Int?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.addDocToPartner(doc: doc.toDAL() as! DocumentDAL, partnerId: partnerId, completion: completion)
    }
    
    func removePlaceFromPartner(shipment: Bool, partnerId: Int?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        dalProvider.removePlaceFromPartner(shipment: shipment, partnerId: partnerId, completion: completion)
    }
    
}
