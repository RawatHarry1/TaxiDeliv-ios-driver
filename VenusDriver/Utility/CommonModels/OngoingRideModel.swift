//
//  OngoingRideModel.swift
//  VenusDriver
//
//  Created by Amit on 15/09/23.
//

import Foundation

struct OngoingRideModel : Codable {
    let is_driver_online : Int?
    let currency : String?
    let currency_symbol : String?
    var can_end : Int?
    var can_start : Int?
    var deliveryPackages : [DeliveryPackages]?
    let trips : [PushNotification]?

    enum CodingKeys: String, CodingKey {

        case is_driver_online = "is_driver_online"
        case currency = "currency"
        case currency_symbol = "currency_symbol"
        case trips = "trips"
        case can_end = "can_end"
        case can_start = "can_start"
        case deliveryPackages = "deliveryPackages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_driver_online = try values.decodeIfPresent(Int.self, forKey: .is_driver_online)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
        trips = try values.decodeIfPresent([PushNotification].self, forKey: .trips)
        can_end = try values.decodeIfPresent(Int.self, forKey: .can_end)
        can_start = try values.decodeIfPresent(Int.self, forKey: .can_start)
        deliveryPackages = try values.decodeIfPresent([DeliveryPackages].self, forKey: .deliveryPackages)
    }
}
struct DeliveryPackages: Codable{
    var delivery_status: Int?
    var notes :  String?
    var package_id : Int?
    var package_image_while_drop_off : [String]?
    var package_image_while_pickup : [String]?
    var package_images_by_customer : [String]?
    var package_quantity : Int?
    var package_size : String
    var package_type: String?
}
