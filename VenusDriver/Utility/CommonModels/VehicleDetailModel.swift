//
//  VehicleDetailModel.swift
//  VenusDriver
//
//  Created by Amit on 10/09/23.
//

import Foundation

struct VehicleDetailModel : Codable {
    let docStatus : String?
    let vehicle_array : [VehiclesList]?

    enum CodingKeys: String, CodingKey {

        case docStatus = "docStatus"
        case vehicle_array = "vehicle_array"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        docStatus = try values.decodeIfPresent(String.self, forKey: .docStatus)
        vehicle_array = try values.decodeIfPresent([VehiclesList].self, forKey: .vehicle_array)
    }

}

struct VehiclesList : Codable {
    let driver_vehicle_mapping_id : Int?
    let driver_id : Int?
    let driver_vehicle_mapping_status : Int?
    let vehicle_status : Int?
    let reason : String?
    let vehicle_id : Int?
    let vehicle_no : String?
    let vehicle_image : String?
    let vehicle_year : Int?
    let vehicle_type : Int?
    let vehicle_make_id : Int?
    let brand : String?
    let model_name : String?
    let no_of_seat_belts : String?
    let no_of_doors : String?
    let color : String?
    let city_id : Int?
    let no_of_seats : Int?
    let id : Int?
    let model_id : Int?
    let door_id : Int?
    let color_id : Int?
    let seat_belt_id : Int?
    let created_at : String?
    let updated_at : String?
    let vehicle_online : Int?
    let vehicle_type_name : String?
    let make_image : String?

    enum CodingKeys: String, CodingKey {

        case driver_vehicle_mapping_id = "driver_vehicle_mapping_id"
        case driver_id = "driver_id"
        case driver_vehicle_mapping_status = "driver_vehicle_mapping_status"
        case vehicle_status = "vehicle_status"
        case reason = "reason"
        case vehicle_id = "vehicle_id"
        case vehicle_no = "vehicle_no"
        case vehicle_image = "vehicle_image"
        case vehicle_year = "vehicle_year"
        case vehicle_type = "vehicle_type"
        case vehicle_make_id = "vehicle_make_id"
        case brand = "brand"
        case model_name = "model_name"
        case no_of_seat_belts = "no_of_seat_belts"
        case no_of_doors = "no_of_doors"
        case color = "color"
        case city_id = "city_id"
        case no_of_seats = "no_of_seats"
        case id = "id"
        case model_id = "model_id"
        case door_id = "door_id"
        case color_id = "color_id"
        case seat_belt_id = "seat_belt_id"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case vehicle_online = "vehicle_online"
        case vehicle_type_name = "vehicle_type_name"
        case make_image = "make_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        driver_vehicle_mapping_id = try values.decodeIfPresent(Int.self, forKey: .driver_vehicle_mapping_id)
        driver_id = try values.decodeIfPresent(Int.self, forKey: .driver_id)
        driver_vehicle_mapping_status = try values.decodeIfPresent(Int.self, forKey: .driver_vehicle_mapping_status)
        vehicle_status = try values.decodeIfPresent(Int.self, forKey: .vehicle_status)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        vehicle_id = try values.decodeIfPresent(Int.self, forKey: .vehicle_id)
        vehicle_no = try values.decodeIfPresent(String.self, forKey: .vehicle_no)
        vehicle_image = try values.decodeIfPresent(String.self, forKey: .vehicle_image)
        vehicle_year = try values.decodeIfPresent(Int.self, forKey: .vehicle_year)
        vehicle_type = try values.decodeIfPresent(Int.self, forKey: .vehicle_type)
        vehicle_make_id = try values.decodeIfPresent(Int.self, forKey: .vehicle_make_id)
        brand = try values.decodeIfPresent(String.self, forKey: .brand)
        model_name = try values.decodeIfPresent(String.self, forKey: .model_name)
        no_of_seat_belts = try values.decodeIfPresent(String.self, forKey: .no_of_seat_belts)
        no_of_doors = try values.decodeIfPresent(String.self, forKey: .no_of_doors)
        color = try values.decodeIfPresent(String.self, forKey: .color)
        city_id = try values.decodeIfPresent(Int.self, forKey: .city_id)
        no_of_seats = try values.decodeIfPresent(Int.self, forKey: .no_of_seats)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        model_id = try values.decodeIfPresent(Int.self, forKey: .model_id)
        door_id = try values.decodeIfPresent(Int.self, forKey: .door_id)
        color_id = try values.decodeIfPresent(Int.self, forKey: .color_id)
        seat_belt_id = try values.decodeIfPresent(Int.self, forKey: .seat_belt_id)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        vehicle_online = try values.decodeIfPresent(Int.self, forKey: .vehicle_online)
        vehicle_type_name = try values.decodeIfPresent(String.self, forKey: .vehicle_type_name)
        make_image = try values.decodeIfPresent(String.self, forKey: .make_image)
    }

}
