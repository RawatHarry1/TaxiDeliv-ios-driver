//
//  BookingModel.swift
//  VenusDriver
//
//  Created by Amit on 03/08/23.
//

import Foundation


struct BookingHistoryModel : Codable {
    let trip_id : Int?
    let from : String?
    let to : String?
    let total_fare : Double?
    let distance : Double?
    let ride_time : Int?
    let wait_time : Int?
    let time : String?
    let status_string : String?
    let ride_fare : Double?
    let sub_total_ride_fare : Double?
    let drop_latitude : Double?
    let drop_longitude : Double?
    let pickup_latitude : Double?
    let pickup_longitude : Double?
    let customer_name : String?
    let type : String?
    let created_at : String?
    let tracking_image : String?

    enum CodingKeys: String, CodingKey {

        case trip_id = "trip_id"
        case from = "from"
        case to = "to"
        case total_fare = "total_fare"
        case distance = "distance"
        case ride_time = "ride_time"
        case wait_time = "wait_time"
        case time = "time"
        case status_string = "status_string"
        case ride_fare = "ride_fare"
        case sub_total_ride_fare = "sub_total_ride_fare"
        case drop_latitude = "drop_latitude"
        case drop_longitude = "drop_longitude"
        case pickup_latitude = "pickup_latitude"
        case pickup_longitude = "pickup_longitude"
        case customer_name = "customer_name"
        case type = "type"
        case created_at = "created_at"
        case tracking_image = "tracking_image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trip_id = try values.decodeIfPresent(Int.self, forKey: .trip_id)
        from = try values.decodeIfPresent(String.self, forKey: .from)
        to = try values.decodeIfPresent(String.self, forKey: .to)
        total_fare = try values.decodeIfPresent(Double.self, forKey: .total_fare)
        do {
            distance = try values.decodeIfPresent(Double.self, forKey: .distance)
        } catch {
            distance = 0.0
        }
        ride_time = try values.decodeIfPresent(Int.self, forKey: .ride_time)
        wait_time = try values.decodeIfPresent(Int.self, forKey: .wait_time)
        time = try values.decodeIfPresent(String.self, forKey: .time)
        status_string = try values.decodeIfPresent(String.self, forKey: .status_string)
        ride_fare = try values.decodeIfPresent(Double.self, forKey: .ride_fare)
        sub_total_ride_fare = try values.decodeIfPresent(Double.self, forKey: .sub_total_ride_fare)
        drop_latitude = try values.decodeIfPresent(Double.self, forKey: .drop_latitude)
        drop_longitude = try values.decodeIfPresent(Double.self, forKey: .drop_longitude)
        pickup_latitude = try values.decodeIfPresent(Double.self, forKey: .pickup_latitude)
        pickup_longitude = try values.decodeIfPresent(Double.self, forKey: .pickup_longitude)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        tracking_image = try values.decodeIfPresent(String.self, forKey: .tracking_image)
    }

}
