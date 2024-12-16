//
//  Webservices+GoogleMapsAPI.swift
//  VenusDriver
//
//  Created by Amit on 26/02/24.
//

import Foundation

extension WebServices {
    static func getNewTripPolyline(parameters: JSONDictionary,showLoader:Bool = false,response: @escaping ((Result<(Any?),Error>) -> Void)) {
        commonGooglePlaceGetAPI(parameters: parameters, endPoint: .newRidePolyline, loader: showLoader) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                if let objc = json.dictionaryObject {
                    if let objc_rows = objc["routes"] as? [[String:Any]] {
                        if objc_rows.count > 0 {
                            if let objc_rows_elements = objc_rows[0]["overview_polyline"] as? [String:Any] {
    //                                if objc_rows_elements.count > 0 {
                                    response(.success(objc_rows_elements))
    //                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
