//
//  RideDetails.swift
//  VenusDriver
//
//  Created by Amit on 27/08/23.
//

import Foundation

struct RideDetails : Codable {
    let address : String?
    let currency : String?
    let current_latitude : Double?
    let current_longitude : Double?
    let distance_unit : String?
    let customer_data : Customer_data?
    let fare_details : Fare_details?
    let tripId : String?

    enum CodingKeys: String, CodingKey {

        case address = "address"
        case currency = "currency"
        case current_latitude = "current_latitude"
        case current_longitude = "current_longitude"
        case distance_unit = "distance_unit"
        case customer_data = "customer_data"
        case fare_details = "fare_details"
        case tripId = "tripId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        current_latitude = try values.decodeIfPresent(Double.self, forKey: .current_latitude)
        current_longitude = try values.decodeIfPresent(Double.self, forKey: .current_longitude)
        distance_unit = try values.decodeIfPresent(String.self, forKey: .distance_unit)
        customer_data = try values.decodeIfPresent(Customer_data.self, forKey: .customer_data)
        fare_details = try values.decodeIfPresent(Fare_details.self, forKey: .fare_details)
        tripId = try values.decodeIfPresent(String.self, forKey: .tripId)
    }
}


struct Fare_details : Codable {
    let id : Int?
    let fare_fixed : Double?
    let fare_per_km : Double?
    let fare_minimum : Double?
    let display_base_fare : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case fare_fixed = "fare_fixed"
        case fare_per_km = "fare_per_km"
        case fare_minimum = "fare_minimum"
        case display_base_fare = "display_base_fare"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        fare_fixed = try values.decodeIfPresent(Double.self, forKey: .fare_fixed)
        fare_per_km = try values.decodeIfPresent(Double.self, forKey: .fare_per_km)
        fare_minimum = try values.decodeIfPresent(Double.self, forKey: .fare_minimum)
        display_base_fare = try values.decodeIfPresent(String.self, forKey: .display_base_fare)
    }
}

struct Customer_data : Codable {
    let customer_id : Int?
    let customer_name : String?
    let phone_no : String?
    let customer_image : String?
    let customer_rating : Double?
    let venuc_balance : Double?
    let address : String?

    enum CodingKeys: String, CodingKey {

        case customer_id = "customer_id"
        case customer_name = "customer_name"
        case phone_no = "phone_no"
        case customer_image = "customer_image"
        case customer_rating = "customer_rating"
        case venuc_balance = "venuc_balance"
        case address = "address"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customer_id = try values.decodeIfPresent(Int.self, forKey: .customer_id)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        phone_no = try values.decodeIfPresent(String.self, forKey: .phone_no)
        customer_image = try values.decodeIfPresent(String.self, forKey: .customer_image)
        customer_rating = try values.decodeIfPresent(Double.self, forKey: .customer_rating)
        venuc_balance = try values.decodeIfPresent(Double.self, forKey: .venuc_balance)
        address = try values.decodeIfPresent(String.self, forKey: .address)
    }
}
