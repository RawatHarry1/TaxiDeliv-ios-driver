//
//  EndRideModel.swift
//  VenusDriver
//
//  Created by Amit on 30/08/23.
//

import Foundation

struct EndRideModel : Codable {
    let distance_unit : String?
    let driver_ride_earning : String?
    let paid_using_wallet : Int?
    let fare : Int?
    let to_pay : Double?
    let currency : String?
    let wait_time : Int?
    let driver_ride_date : String?
    let ride_time : Int?
    let payment_mode : Int?
   // let distance_travelled : String?
    let customer_name : String?
    let customer_image: String?
    let customer_id : Int?
    let engagement_id: String?

    enum CodingKeys: String, CodingKey {

        case distance_unit = "distance_unit"
        case driver_ride_earning = "driver_ride_earning"
        case paid_using_wallet = "paid_using_wallet"
        case fare = "fare"
        case to_pay = "to_pay"
        case currency = "currency"
        case wait_time = "wait_time"
        case driver_ride_date = "driver_ride_date"
        case ride_time = "ride_time"
        case payment_mode = "payment_mode"
       // case distance_travelled = "distance_travelled"
        case customer_name = "customer_name"
        case customer_image = "customer_image"
        case customer_id = "customer_id"
        case engagement_id = "engagement_id"
        
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        distance_unit = try values.decodeIfPresent(String.self, forKey: .distance_unit)
        driver_ride_earning = try values.decodeIfPresent(String.self, forKey: .driver_ride_earning)
        paid_using_wallet = try values.decodeIfPresent(Int.self, forKey: .paid_using_wallet)
        fare = try values.decodeIfPresent(Int.self, forKey: .fare)
        to_pay = try values.decodeIfPresent(Double.self, forKey: .to_pay)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        wait_time = try values.decodeIfPresent(Int.self, forKey: .wait_time)
        driver_ride_date = try values.decodeIfPresent(String.self, forKey: .driver_ride_date)
        ride_time = try values.decodeIfPresent(Int.self, forKey: .ride_time)
        payment_mode = try values.decodeIfPresent(Int.self, forKey: .payment_mode)
      //  distance_travelled = try values.decodeIfPresent(String.self, forKey: .distance_travelled)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        customer_image = try values.decodeIfPresent(String.self, forKey: .customer_image)
        customer_id = try values.decodeIfPresent(Int.self, forKey: .customer_id)
        engagement_id = try values.decodeIfPresent(String.self, forKey: .engagement_id)
    }

}
