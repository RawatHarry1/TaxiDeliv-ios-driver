//
//  InformationURLModel.swift
//  VenusDriver
//
//  Created by Amit on 12/09/23.
//

import Foundation

struct InformationURLModel : Codable {
    let privacy_policy : String?
    let facebook_url : String?
    let who_we_are : String?
    let legal_url : String?
    let support_email : String?

    enum CodingKeys: String, CodingKey {

        case privacy_policy = "privacy_policy"
        case facebook_url = "facebook_url"
        case who_we_are = "who_we_are"
        case legal_url = "legal_url"
        case support_email = "support_email"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        privacy_policy = try values.decodeIfPresent(String.self, forKey: .privacy_policy)
        facebook_url = try values.decodeIfPresent(String.self, forKey: .facebook_url)
        who_we_are = try values.decodeIfPresent(String.self, forKey: .who_we_are)
        legal_url = try values.decodeIfPresent(String.self, forKey: .legal_url)
        support_email = try values.decodeIfPresent(String.self, forKey: .support_email)
    }

}
