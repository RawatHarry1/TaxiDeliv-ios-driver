//
//  WebServices+Trips.swift
//  VenusDriver
//
//  Created by Amit on 24/08/23.
//

import Foundation

extension WebServices {
    
    static func addCards(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .addCard, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(CardsModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func deleteCard(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .deleteCard, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(CardsModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func uploadPackageStatus(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .update_delivery_package_status, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(PackageStatusModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func getCard(url: String,parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .getCard,toAppend: url, loader: true) { (result) in
      
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(GetCardsModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func confirmCard(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .confirmCard, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(CardsModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    // MARK: - Change Availability
    static func changeDriverAvailabilityu(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .changeDriverAvailability, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
//                let data = try! json[APIKeys.data.rawValue].rawData()
//                let model = try! JSONDecoder().decode(UserModel.self, from: data)
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Accept Trip
    static func acceptTripApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .acceptTrip, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(RideDetails.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Reject Trip
    static func rejectTripApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .rejectTrip, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Cancel Trip
    static func cancelTripApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .cancelTrip, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(BlockDriverModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Start Trip
    static func startTripApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .srartTrip, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(EndRideModel.self, from: data)
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To MarkArrive Trip
    static func markArrivedTripApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .markArrived, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
//                let data = try! json[APIKeys.data.rawValue].rawData()
//                let model = try! JSONDecoder().decode(UserModel.self, from: data)
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To MarkArrive Trip
    static func completeTripApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .endRide, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(EndRideModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Fetch Ongoing Trip
    static func fetchOngoingTrip(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .fetchOngoingTrip, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)

                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(OngoingRideModel.self, from: data)
                response(.success(model))

//                if let data = json.dictionaryObject?[APIKeys.data.rawValue] as? [String: Any] {
//                    AvailabilityStatus = ((data["is_driver_online"] as? Int ?? 0) == 1)
//                }
//                if let objc = (json.dictionaryObject?[APIKeys.data.rawValue] as? [String: Any])?["trips"] as? [[String : Any]] {
//                    if objc.count > 0 {
//                        let currentRide = objc[0]
//                        var notificationModel = PushNotification()
//                        notificationModel.status = "\(currentRide["status"] as? Int ?? 0)"
//                        notificationModel.title =  currentRide["title"] as? String
//                        notificationModel.latitude = currentRide["latitude"] as? String
//                        notificationModel.longitude = currentRide["longitude"] as? String
//                        notificationModel.currency = currentRide["currency"] as? String
//                        notificationModel.customer_id = "\(currentRide["user_id"] as? Int ?? 0)"
//                        notificationModel.customer_image = currentRide["customerImage"] as? String
//                        notificationModel.customer_name = currentRide["CustomerName"] as? String
//                        notificationModel.drop_address = currentRide["drop_location_address"] as? String
//                        notificationModel.dry_eta = currentRide["dry_eta"] as? String
//                        notificationModel.estimated_distance = currentRide["estimated_distance"] as? String
//                        notificationModel.pickup_address = currentRide["pickup_location_address"] as? String
//                        notificationModel.token = currentRide["token"] as? String
//                        notificationModel.trip_id = "\(currentRide["engagement_id"] as? Int ?? 0)"
//                        notificationModel.estimated_driver_fare = currentRide["estimated_driver_fare"] as? String
//
//                        response(.success(notificationModel))
//                    } else {
//                        response(.success(json))
//                    }
//                }
//                else {
//                    response(.success(json))
//                }
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
