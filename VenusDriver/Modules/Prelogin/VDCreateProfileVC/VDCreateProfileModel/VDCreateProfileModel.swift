//
//  VDCreateProfileModel.swift
//  VenusDriver
//
//  Created by Amit on 24/07/23.
//

import Foundation

struct ProfileModel : Codable {
    let first_name : String?
    let last_name : String?
    let profile_image : String?
    let date_of_birth : String?
    let email : String?
    let phone_no : String?
    let driver_id : Int?
    let user_name : String?
    let address : String?
    let emergency_phone_number : String?

    // MARK: - Parameters
    static var currentUserProfile = ProfileModel.getFromUserDefaults() {
        didSet {
            ProfileModel.currentUserProfile.saveToUserDefaults()
        }
    }

    enum CodingKeys: String, CodingKey {

        case first_name = "first_name"
        case last_name = "last_name"
        case profile_image = "profile_image"
        case date_of_birth = "date_of_birth"
        case email = "email"
        case phone_no = "phone_no"
        case driver_id = "driver_id"
        case user_name = "user_name"
        case address = "address"
        case emergency_phone_number = "emergency_phone_number"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        first_name = try values.decodeIfPresent(String.self, forKey: .first_name)
        last_name = try values.decodeIfPresent(String.self, forKey: .last_name)
        profile_image = try values.decodeIfPresent(String.self, forKey: .profile_image)
        date_of_birth = try values.decodeIfPresent(String.self, forKey: .date_of_birth)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone_no = try values.decodeIfPresent(String.self, forKey: .phone_no)
        driver_id = try values.decodeIfPresent(Int.self, forKey: .driver_id)
        user_name = try values.decodeIfPresent(String.self, forKey: .user_name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        emergency_phone_number = try values.decodeIfPresent(String.self, forKey: .emergency_phone_number)
    }

    init() {
        first_name = nil
        last_name = nil
        profile_image = nil
        date_of_birth = nil
        email = nil
        phone_no = nil
        driver_id = nil
        user_name = nil
        address = nil
        emergency_phone_number = nil
    }

    // MARK: - Custom Functions
    private func saveToUserDefaults() {
        guard let data = try? JSONEncoder().encode(self) else { return }
        VDUserDefaults.save(value: data, forKey: .userProfile)
    }

    private static func getFromUserDefaults() -> ProfileModel {
        guard let data = try? VDUserDefaults.value(forKey: .userProfile).rawData(), let user = try? JSONDecoder().decode(ProfileModel.self, from: data) else { return ProfileModel() }
        return user
    }

}
