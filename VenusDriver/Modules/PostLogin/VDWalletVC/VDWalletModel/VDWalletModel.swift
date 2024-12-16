//
//  VDWalletModel.swift
//  VenusDriver
//
//  Created by Amit on 27/08/23.
//

import Foundation

struct cancelScheduleModal: Codable{
    var flag: Int?
    var message : String?
}

struct VDWalletModel : Codable {
    let venus_balance : Double?
    let user_name : String?

    enum CodingKeys: String, CodingKey {

        case venus_balance = "venus_balance"
        case user_name = "user_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        venus_balance = try values.decodeIfPresent(Double.self, forKey: .venus_balance)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
    }

    init() {
        venus_balance = nil
        user_name = nil
    }

}
