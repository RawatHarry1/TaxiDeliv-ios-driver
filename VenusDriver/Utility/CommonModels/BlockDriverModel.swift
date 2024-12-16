//
//  BlockDriverModel.swift
//  VenusDriver
//
//  Created by AB on 05/10/23.
//

import Foundation

struct BlockDriverModel : Codable {
    var driver_blocked_multiple_cancelation : Driver_blocked_multiple_cancelation?

    enum CodingKeys: String, CodingKey {

        case driver_blocked_multiple_cancelation = "driver_blocked_multiple_cancelation"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        driver_blocked_multiple_cancelation = try values.decodeIfPresent(Driver_blocked_multiple_cancelation.self, forKey: .driver_blocked_multiple_cancelation)
    }

}

struct Driver_blocked_multiple_cancelation : Codable {
    var blocked : Int?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case blocked = "blocked"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        blocked = try values.decodeIfPresent(Int.self, forKey: .blocked)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

}
