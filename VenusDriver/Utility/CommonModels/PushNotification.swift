//
//  PushNotification.swift
//  VenusDriver
//
//  Created by Amit on 29/08/23.
//

import Foundation

struct PushNotification : Codable {
    var title : String?
    var pickup_address : String?
    var longitude : String?
    var estimated_driver_fare : String?
    var status : String?
    var estimated_distance : String?
    var dry_eta : String?
    var currency : String?
    var customer_id : String?
    var latitude : String?
    var customer_image : String?
    var user_phone_no : String?
    var drop_address : String?
    var body : String?
    var token : String?
    var trip_id : String?
    var customer_name : String?
    var date : String?
    var driverBalanceData : Driver_balance_data?
    var drop_latitude : String?
    var drop_longitude : String?
    var customer_notes: String?
    var distanceUnit : String?
    var recipient_phone_no : String?
    var recipient_name: String?
    var customer_ame: String?
    var service_type : Int?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case pickup_address = "pickup_address"
        case longitude = "longitude"
        case estimated_driver_fare = "estimated_driver_fare"
        case status = "status"
        case estimated_distance = "estimated_distance"
        case dry_eta = "dry_eta"
        case currency = "currency"
        case customer_id = "customer_id"
        case latitude = "latitude"
        case customer_image = "customer_image"
        case drop_address = "drop_address"
        case body = "body"
        case token = "token"
        case trip_id = "trip_id"
        case customer_name = "customer_name"
        case date = "date"
        case driverBalanceData = "driver_balance_data"
        case drop_latitude = "drop_latitude"
        case drop_longitude = "drop_longitude"
        case customer_notes = "customer_notes"
        case distanceUnit = "distanceUnit"
        case user_phone_no = "user_phone_no"
        case recipient_phone_no = "recipient_phone_no"
        case recipient_name = "recipient_name"
        case customer_ame = "customer_ame"
        case service_type = "service_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        pickup_address = try values.decodeIfPresent(String.self, forKey: .pickup_address)
        do {
            longitude = try values.decodeIfPresent(String.self, forKey: .longitude)
        }
        catch {
            let int_longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
            longitude = "\(int_longitude ?? 0)"
        }

        do {
            estimated_driver_fare = try values.decodeIfPresent(String.self, forKey: .estimated_driver_fare)
        }
        catch {
            do {
                let double_estimated_driver_fare = try values.decodeIfPresent(Double.self, forKey: .estimated_driver_fare)
                estimated_driver_fare = "\(double_estimated_driver_fare ?? 0.0)"
            }
            catch {
                let double_estimated_driver_fare = try values.decodeIfPresent(Int.self, forKey: .estimated_driver_fare)
                estimated_driver_fare = "\(double_estimated_driver_fare ?? 0)"
            }
        }
        do {
            status = try values.decodeIfPresent(String.self, forKey: .status)
        }
        catch {
            let int_status = try values.decodeIfPresent(Int.self, forKey: .status)
            status = "\(int_status ?? 0)"
        }
        estimated_distance = try values.decodeIfPresent(String.self, forKey: .estimated_distance)
        dry_eta = try values.decodeIfPresent(String.self, forKey: .dry_eta)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        do {
            customer_id = try values.decodeIfPresent(String.self, forKey: .customer_id)
        }
        catch {
            let int_customer_id = try values.decodeIfPresent(Int.self, forKey: .customer_id)
            customer_id = "\(int_customer_id ?? 0)"
        }

        do {
            latitude = try values.decodeIfPresent(String.self, forKey: .latitude)
        }
        catch {
           let double_latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
            latitude = "\(double_latitude ?? 0.0)"
        }

        do {
            drop_longitude = try values.decodeIfPresent(String.self, forKey: .drop_longitude)
        } catch {
            let droplongitude = try values.decodeIfPresent(Double.self, forKey: .drop_longitude)
            drop_longitude = "\(droplongitude ?? 0.0)"
        }

        do {
            drop_latitude = try values.decodeIfPresent(String.self, forKey: .drop_latitude)
        } catch {
            let doublelatitude = try values.decodeIfPresent(Double.self, forKey: .drop_latitude)
            drop_latitude = "\(doublelatitude ?? 0.0)"
        }
        customer_image = try values.decodeIfPresent(String.self, forKey: .customer_image)
        drop_address = try values.decodeIfPresent(String.self, forKey: .drop_address)
        body = try values.decodeIfPresent(String.self, forKey: .body)
        token = try values.decodeIfPresent(String.self, forKey: .token)
        do {
            trip_id = try values.decodeIfPresent(String.self, forKey: .trip_id)
        }
        catch {
            let int_trip_id = try values.decodeIfPresent(Int.self, forKey: .trip_id)
            trip_id = "\(int_trip_id ?? 0)"
        }
        customer_name = try values.decodeIfPresent(String.self, forKey: .customer_name)
        distanceUnit = try values.decodeIfPresent(String.self, forKey: .distanceUnit)
        customer_notes = try values.decodeIfPresent(String.self, forKey: .customer_notes)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        driverBalanceData = try values.decodeIfPresent(Driver_balance_data.self, forKey: .driverBalanceData)
        user_phone_no = try values.decodeIfPresent(String.self, forKey: .user_phone_no)
        recipient_phone_no = try values.decodeIfPresent(String.self, forKey: .recipient_phone_no)
        recipient_name = try values.decodeIfPresent(String.self, forKey: .recipient_name)
        customer_ame = try values.decodeIfPresent(String.self, forKey: .customer_ame)
        service_type = try values.decodeIfPresent(Int.self, forKey: .service_type)
    }

    init() {
        title = nil
        pickup_address = nil
        longitude = nil
        estimated_driver_fare = nil
        status = nil
        estimated_distance = nil
        dry_eta = nil
        currency = nil
        customer_id = nil
        latitude = nil
        customer_image = nil
        drop_address = nil
        body = nil
        token = nil
        trip_id = nil
        customer_name = nil
        date = nil
        driverBalanceData = nil
        drop_latitude = nil
        drop_longitude = nil
        customer_notes = nil
        distanceUnit = nil
        user_phone_no = nil
        recipient_phone_no = nil
        recipient_name = nil
        customer_ame = nil
        service_type = nil
    }
}



struct Driver_balance_data : Codable {
    let min_driver_balance : Double?
    let wallet_balance : Double?

    enum CodingKeys: String, CodingKey {
        case min_driver_balance = "min_driver_balance"
        case wallet_balance = "wallet_balance"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        min_driver_balance = try values.decodeIfPresent(Double.self, forKey: .min_driver_balance)
        wallet_balance = try values.decodeIfPresent(Double.self, forKey: .wallet_balance)
    }

}
