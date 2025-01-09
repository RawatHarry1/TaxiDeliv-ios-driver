//
//  Webservices+GoogleMapsAPI.swift
//  VenusDriver
//
//  Created by Amit on 26/02/24.
//

import Foundation

extension WebServices {
    static func getNewTripPolyline(parameters: JSONDictionary, showLoader: Bool = false, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGooglePlaceGetAPI(parameters: parameters, endPoint: .newRidePolyline, loader: showLoader) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                if let objc = json.dictionaryObject {
                    if let objc_rows = objc["routes"] as? [[String: Any]], objc_rows.count > 0 {
                        if let objc_rows_elements = objc_rows[0]["overview_polyline"] as? [String: Any],
                           let legs = objc_rows[0]["legs"] as? [[String: Any]] {  // Assuming legs is an array
                        
                            // Combine both overview_polyline and legs into a dictionary
                            let responseDict: [String: Any] = [
                                "overview_polyline": objc_rows_elements,
                                "legs": legs
                            ]
                            
                            response(.success(responseDict))
                        }
                    }
                }
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

}
