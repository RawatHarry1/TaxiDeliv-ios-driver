//
//  Notification.swift
//  VenusDriver
//
//  Created by Amit on 28/08/23.
//

import Foundation

struct NotificationDetails : Codable {
    let notification_id : Int?
    let title : String?
    let message : String?

    enum CodingKeys: String, CodingKey {

        case notification_id = "notification_id"
        case title = "title"
        case message = "message"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        notification_id = try values.decodeIfPresent(Int.self, forKey: .notification_id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

    init() {
        notification_id = nil
        title = nil
        message = nil
    }

}
