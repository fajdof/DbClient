//
//  PartnerDALProvider.swift
//  DbClient
//
//  Created by Filip Fajdetic on 22/06/2017.
//  Copyright © 2017 Filip Fajdetic. All rights reserved.
//

import Foundation


class PartnerDALProvider: DALProvider {
    
    func addPlaceToPartner(place: PlaceDAL, country: CountryDAL, partnerId: Int?, shipment: Bool, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = "SET IDENTITY_INSERT Mjesto ON; "
        query = query + insert + Tables.Place.rawValue + " (NazMjesta, IdMjesta, OznDrzave,  PostBrMjesta, PostNazMjesta)" + values
        query = query + "(" + "'\(place.name ?? "")'"
        query = query + colon + "\(place.id ?? 0)"
        query = query + colon + "'\(country.mark ?? "")'"
        query = query + colon + "\(place.postalCode ?? 0)"
        query = query + colon + "'\(place.postalName ?? "")'" + "); "
        query = query + "SET IDENTITY_INSERT Mjesto OFF; "
        
        query = query + update + Tables.Partner.rawValue + set
        if shipment {
            query = query + "IdMjestaIsporuke = '\(place.id!)'"
        } else {
            query = query + "IdMjestaPartnera = '\(place.id!)'"
        }
        query = query + whereClause + "IdPartnera = '\(partnerId!)'"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    func addDocToPartner(doc: DocumentDAL, partnerId: Int?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = insert + Tables.Document.rawValue + " (VrDokumenta, BrDokumenta, DatDokumenta, IznosDokumenta, IdPartnera, PostoPorez)" + values
        query = query + "(" + "'\(doc.docVr ?? "")'"
        query = query + colon + "\(doc.docNumber ?? 0)"
        query = query + colon + "'\(doc.docDate?.string(custom: "YYYYMMdd hh:mm:ss a") ?? "")'"
        query = query + colon + "\(doc.docValue ?? 0)"
        query = query + colon + "\(partnerId ?? 0)"
        query = query + colon + "\(doc.tax ?? 0)" + ")"
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
    
    func removePlaceFromPartner(shipment: Bool, partnerId: Int?, completion: @escaping (_ dbData: [Any]?) -> ()) {
        
        var query = update + Tables.Partner.rawValue + set
        if shipment {
            query = query + "IdMjestaIsporuke = NULL"
        } else {
            query = query + "IdMjestaPartnera = NULL"
        }
        query = query + whereClause + "IdPartnera = '\(partnerId!)'; "
        
        dump(query)
        
        client?.execute(query, completion: { (dbData) in
            
            completion(dbData)
        })
    }
    
}
