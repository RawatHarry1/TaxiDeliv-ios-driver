
import Foundation
struct GetAllMessages : Codable {
    var thread : [ThreadData]?

    enum CodingKeys: String, CodingKey {

        case thread = "thread"
    }

    init(from decoder: Decoder) throws {
        var values = try decoder.container(keyedBy: CodingKeys.self)
        thread = try values.decodeIfPresent([ThreadData].self, forKey: .thread)
    }

}

struct ThreadData : Codable {
    var chat_message_id : Int?
    var thread : Int?
    var receiver_id : Int?
    var sender_id : Int?
    var message : String?
    var engagement_id : Int?
    var attachment : String?
    var attachment_type : String?
    var status : Int?
    var is_sender_read : Int?
    var created_at : String?
    var updated_at : String?
    var thumbnail : String?
    var sender_name : String?
    var sender_image : String?
    var utc_offset : String?

    enum CodingKeys: String, CodingKey {

        case chat_message_id = "chat_message_id"
        case thread = "thread"
        case receiver_id = "receiver_id"
        case sender_id = "sender_id"
        case message = "message"
        case engagement_id = "engagement_id"
        case attachment = "attachment"
        case attachment_type = "attachment_type"
        case status = "status"
        case is_sender_read = "is_sender_read"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case thumbnail = "thumbnail"
        case sender_name = "sender_name"
        case sender_image = "sender_image"
        case utc_offset = "utc_offset"
    }

    init(from decoder: Decoder) throws {
        var values = try decoder.container(keyedBy: CodingKeys.self)
        chat_message_id = try values.decodeIfPresent(Int.self, forKey: .chat_message_id)
        thread = try values.decodeIfPresent(Int.self, forKey: .thread)
        receiver_id = try values.decodeIfPresent(Int.self, forKey: .receiver_id)
        sender_id = try values.decodeIfPresent(Int.self, forKey: .sender_id)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        engagement_id = try values.decodeIfPresent(Int.self, forKey: .engagement_id)
        attachment = try values.decodeIfPresent(String.self, forKey: .attachment)
        attachment_type = try values.decodeIfPresent(String.self, forKey: .attachment_type)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        is_sender_read = try values.decodeIfPresent(Int.self, forKey: .is_sender_read)
        created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
        updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
        thumbnail = try values.decodeIfPresent(String.self, forKey: .thumbnail)
        sender_name = try values.decodeIfPresent(String.self, forKey: .sender_name)
        sender_image = try values.decodeIfPresent(String.self, forKey: .sender_image)
        utc_offset = try values.decodeIfPresent(String.self, forKey: .utc_offset)
    }

}
struct singleMessageMoal: Codable {
    let receiver_id: Int
    let sender_id: Int
    let senderId: Int
    let chat_message_id: Int
    let is_sender_read: Int
    let attachment: String?
    let engagement_id: Int
    let thumbnail: String?
    let attachment_type: String?
    let receiverId: Int
    let receiver_device_token: String
    let status: Int
    let thread: Int
    let utc_offset: String
    let sender_user_name: String
    let receiverDeviceType: Int
    let created_at: String
    let updated_at: String
    let message: String
}
