//
//  VDVehicleFeatureModel.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import Foundation

struct VehicleFeatures : Codable {
    let vehicle_type : [VehiclesType]?
    let colors : [VehicleColors]?
    let vehicles : [VehiclesModel]?

    enum CodingKeys: String, CodingKey {
        case vehicle_type = "vehicle_type"
        case colors = "colors"
        case vehicles = "vehicles"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        vehicle_type = try values.decodeIfPresent([VehiclesType].self, forKey: .vehicle_type)
        colors = try values.decodeIfPresent([VehicleColors].self, forKey: .colors)
        vehicles = try values.decodeIfPresent([VehiclesModel].self, forKey: .vehicles)
    }

}


struct VehicleColors : Codable {
    let id : Int?
    let value : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case value = "value"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }

}

struct VehiclesModel : Codable {
    let vehicle_type : Int?
    let id : Int?
    let brand : String?
    let model_name : String?

    enum CodingKeys: String, CodingKey {
        case vehicle_type = "vehicle_type"
        case id = "id"
        case brand = "brand"
        case model_name = "model_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        model_name = try values.decodeIfPresent(String.self, forKey: .model_name)
        vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
    }
}

struct VehiclesType : Codable {
    let vehicle_type : Int?
    let vehicle_type_name : String?

    enum CodingKeys: String, CodingKey {

        case vehicle_type = "vehicle_type"
        case vehicle_type_name = "vehicle_type_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
        vehicle_type_name = try values.decodeIfPresent(String.self, forKey: .vehicle_type_name)
    }

}
