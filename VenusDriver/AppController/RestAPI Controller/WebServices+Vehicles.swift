//
//  WebServices+Vehicles.swift
//  VenusDriver
//
//  Created by Amit on 12/09/23.
//

import Foundation

extension WebServices {
    // MARK: - To Fetch Vehicle Features
    static func getVehicleFeature(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .getCityVehicles, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(VehicleFeatures.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Update Vehicle
    static func updateVehicleApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .updateVehicle, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
//                let data = try! json[APIKeys.data.rawValue].rawData()
//                let model = try! JSONDecoder().decode(Vehicle.self, from: data)
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Get vehicle List
    static func getDriverVehicleList(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .fetchVehicleDetails, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode(VehicleDetailModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
