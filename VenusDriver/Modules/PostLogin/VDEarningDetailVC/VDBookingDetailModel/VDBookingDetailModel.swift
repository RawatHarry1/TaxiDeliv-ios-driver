//
//  VDBookingDetailModel.swift
//  VenusDriver
//
//  Created by Amit on 03/08/23.
//

import Foundation

struct BookingDetailModel : Codable {
    let accept_distance : Double?
    let accept_time : String?
    let arrived_at : String?
    let drop_location_address : String?
    let driver_rating : Int?
    let driver_accept_longitude : Double?
    let driver_accept_latitude : Double?
    let pickup_location_address : String?
    let pickup_longitude : Double?
    let pickup_latitude : Double?
    let pickup_time : String?
    let wait_time : Int?
    let ride_time : Int?
    let drop_time : String?
    let drop_latitude : Double?
    let drop_longitude : Double?
    let distance_travelled : Double?
    let customer_name : String?
    let total_fare : Double?
    let sub_total_ride_fare : Double?
    let ride_fare : Double?
    let created_at : String?
   let tracking_image : String?
    let net_customer_tax: Double?
    let venus_commission: Double?
    var delivery_packages: [DeliveryPackageHistoryData]?

    enum CodingKeys: String, CodingKey {

        case accept_distance = "accept_distance"
        case accept_time = "accept_time"
        case arrived_at = "arrived_at"
        case drop_location_address = "drop_location_address"
        case driver_rating = "driver_rating"
        case driver_accept_longitude = "driver_accept_longitude"
        case driver_accept_latitude = "driver_accept_latitude"
        case pickup_location_address = "pickup_location_address"
        case pickup_longitude = "pickup_longitude"
        case pickup_latitude = "pickup_latitude"
        case pickup_time = "pickup_time"
        case wait_time = "wait_time"
        case ride_time = "ride_time"
        case drop_time = "drop_time"
        case drop_latitude = "drop_latitude"
        case drop_longitude = "drop_longitude"
        case distance_travelled = "distance_travelled"
        case customer_name = "customer_name"
        case total_fare = "total_fare"
        case sub_total_ride_fare = "sub_total_ride_fare"
        case ride_fare = "ride_fare"
        case created_at = "created_at"
        case tracking_image = "tracking_image"
        case net_customer_tax = "net_customer_tax"
        case venus_commission = "venus_commission"
        case delivery_packages = "delivery_packages"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accept_distance = try values.decodeIfPresent(Double.self, forKey: .accept_distance)
        accept_time = try values.decodeIfPresent(String.self, forKey: .accept_time)
        arrived_at = try values.decodeIfPresent(String.self, forKey: .arrived_at)
        drop_location_address = try values.decodeIfPresent(String.self, forKey: .drop_location_address)
        driver_rating = try values.decodeIfPresent(Int.self, forKey: .driver_rating)
        driver_accept_longitude = try values.decodeIfPresent(Double.self, forKey: .driver_accept_longitude)
        driver_accept_latitude = try values.decodeIfPresent(Double.self, forKey: .driver_accept_latitude)
        pickup_location_address = try values.decodeIfPresent(String.self, forKey: .pickup_location_address)
        pickup_longitude = try values.decodeIfPresent(Double.self, forKey: .pickup_longitude)
        pickup_latitude = try values.decodeIfPresent(Double.self, forKey: .pickup_latitude)
        pickup_time = try values.decodeIfPresent(String.self, forKey: .pickup_time)
        wait_time = try values.decodeIfPresent(Int.self, forKey: .wait_time)
        ride_time = try values.decodeIfPresent(Int.self, forKey: .ride_time)
        drop_time = try values.decodeIfPresent(String.self, forKey: .drop_time)
        drop_latitude = try values.decodeIfPresent(Double.self, forKey: .drop_latitude)
        drop_longitude = try values.decodeIfPresent(Double.self, forKey: .drop_longitude)
        distance_travelled = try values.decodeIfPresent(Double.self, forKey: .distance_travelled)
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        total_fare = try values.decodeIfPresent(Double.self, forKey: .total_fare)
        sub_total_ride_fare = try values.decodeIfPresent(Double.self, forKey: .sub_total_ride_fare)
        ride_fare = try values.decodeIfPresent(Double.self, forKey: .ride_fare)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        tracking_image = try values.decodeIfPresent(String.self, forKey: .tracking_image)
        net_customer_tax = try values.decodeIfPresent(Double.self, forKey: .net_customer_tax)
        venus_commission = try values.decodeIfPresent(Double.self, forKey: .venus_commission)
        delivery_packages  = try values.decodeIfPresent([DeliveryPackageHistoryData].self, forKey: .delivery_packages)
        
        do {
            delivery_packages = try values.decodeIfPresent([DeliveryPackageHistoryData].self, forKey: .delivery_packages)
        } catch {
            print("Error decoding delivery_packages: \(error)")
        }
    }

}

struct DeliveryPackageHistoryData: Codable {
    var package_quantity: Int?
    var id: String?
    var package_type: String?
    var package_image_while_drop_off: [String]?
    var package_image_while_pickup: [String]?
    var package_images_by_customer: [String]?

    var package_size: String?
    var description: String?
}
