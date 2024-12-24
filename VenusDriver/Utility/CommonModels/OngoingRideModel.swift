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
    let trips : [PushNotification]?

    enum CodingKeys: String, CodingKey {

        case is_driver_online = "is_driver_online"
        case currency = "currency"
        case currency_symbol = "currency_symbol"
        case trips = "trips"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        is_driver_online = try values.decodeIfPresent(Int.self, forKey: .is_driver_online)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        currency_symbol = try values.decodeIfPresent(String.self, forKey: .currency_symbol)
        trips = try values.decodeIfPresent([PushNotification].self, forKey: .trips)
    }
}
