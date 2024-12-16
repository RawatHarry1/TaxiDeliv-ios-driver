//
//  VDDocumentListModel.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import Foundation

import Foundation
struct DocumentList : Codable {
    let list : [DocumentDetails]?

    enum CodingKeys: String, CodingKey {

        case list = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        list = try values.decodeIfPresent([DocumentDetails].self, forKey: .list)
    }

}


struct DocumentDetails : Codable {
    let doc_type_num : Int?
    let doc_count : Int?
    let image_position : [Image_position]?
    let doc_type_text : String?
    let doc_status : String?
    let doc_url : [String]?
    let reason : String?
    let doc_requirement : Int?

    enum CodingKeys: String, CodingKey {

        case doc_type_num = "doc_type_num"
        case doc_count = "doc_count"
        case image_position = "image_position"
        case doc_type_text = "doc_type_text"
        case doc_status = "doc_status"
        case doc_url = "doc_url"
        case reason = "reason"
        case doc_requirement = "doc_requirement"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        doc_type_num = try values.decodeIfPresent(Int.self, forKey: .doc_type_num)
        doc_count = try values.decodeIfPresent(Int.self, forKey: .doc_count)
        image_position = try values.decodeIfPresent([Image_position].self, forKey: .image_position)
        doc_type_text = try values.decodeIfPresent(String.self, forKey: .doc_type_text)
        doc_status = try values.decodeIfPresent(String.self, forKey: .doc_status)
        doc_url = try values.decodeIfPresent([String].self, forKey: .doc_url)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        doc_requirement = try values.decodeIfPresent(Int.self, forKey: .doc_requirement)
    }

}

struct Image_position : Codable {
    let img_position : Int?
    let name : String?

    enum CodingKeys: String, CodingKey {

        case img_position = "img_position"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        img_position = try values.decodeIfPresent(Int.self, forKey: .img_position)
        name = try values.decodeIfPresent(String.self, forKey: .name)
    }

}
