//
//  VDEarningListModel.swift
//  VenusDriver
//
//  Created by Amit on 26/08/23.
//

import Foundation

struct VDEarningListModel : Codable {
    let totalEarnings : Double?
    let rides : [VDRides]?

    enum CodingKeys: String, CodingKey {

        case totalEarnings = "totalEarnings"
        case rides = "rides"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalEarnings = try values.decodeIfPresent(Double.self, forKey: .totalEarnings)
        rides = try values.decodeIfPresent([VDRides].self, forKey: .rides)
    }

    init() {
        totalEarnings = nil
        rides = nil
    }

}


struct VDRides : Codable {
    let customerName : String?
    let customerImage : String?
    let actual_fare : Double?
    let engagement_id : Int?
    let totalEarnings : Double?

    enum CodingKeys: String, CodingKey {
        case customerName = "customerName"
        case customerImage = "customerImage"
        case actual_fare = "actual_fare"
        case engagement_id = "engagement_id"
        case totalEarnings = "totalEarnings"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        customerName = try values.decodeIfPresent(String.self, forKey: .customerName)
        customerImage = try values.decodeIfPresent(String.self, forKey: .customerImage)
        actual_fare = try values.decodeIfPresent(Double.self, forKey: .actual_fare)
        engagement_id = try values.decodeIfPresent(Int.self, forKey: .engagement_id)
        totalEarnings = try values.decodeIfPresent(Double.self, forKey: .totalEarnings)
    }

    init() {
        customerName = nil
        customerImage = nil
        actual_fare = nil
        engagement_id = nil
        totalEarnings = nil
    }
}
