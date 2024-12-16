

import Foundation
struct ChatModal : Codable {
	let msg : Msg?

	enum CodingKeys: String, CodingKey {

		case msg = "msg"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		msg = try values.decodeIfPresent(Msg.self, forKey: .msg)
	}

}
struct Msg : Codable {
    let chat_message_id : Int?
    let thread : Int?
    let receiver_id : Int?
    let sender_id : Int?
    let message : String?
    let engagement_id : Int?
    let attachment : String?
    let attachment_type : String?
    let status : Int?
    let is_sender_read : Int?
    let created_at : String?
    let updated_at : String?
    let thumbnail : String?
    let receiver_device_token : String?
    let sender_user_name : String?
    let senderId : Int?
    let receiverId : Int?
    let receiverDeviceType : Int?
    let utc_offset : String?

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
        case receiver_device_token = "receiver_device_token"
        case sender_user_name = "sender_user_name"
        case senderId = "senderId"
        case receiverId = "receiverId"
        case receiverDeviceType = "receiverDeviceType"
        case utc_offset = "utc_offset"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
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
        receiver_device_token = try values.decodeIfPresent(String.self, forKey: .receiver_device_token)
        sender_user_name = try values.decodeIfPresent(String.self, forKey: .sender_user_name)
        senderId = try values.decodeIfPresent(Int.self, forKey: .senderId)
        receiverId = try values.decodeIfPresent(Int.self, forKey: .receiverId)
        receiverDeviceType = try values.decodeIfPresent(Int.self, forKey: .receiverDeviceType)
        utc_offset = try values.decodeIfPresent(String.self, forKey: .utc_offset)
    }

}
