//
//  Webservices+Login.swift
//  VenusDriver
//
//  Created by Amit on 24/07/23.
//

import Foundation

extension WebServices {
    // MARK: - To Get OTP For Login
    static func generateOtpWithLogin(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .generateLoginOtp, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
//                let data = try! json[APIKeys.data.rawValue].rawData()
//                let model = try! JSONDecoder().decode(ClientModel.self, from: data)
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Verify OTP
    static func verifyLoginOTP(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .login, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(UserModel.self, from: data)
                UserModel.currentUser = model
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func raiseTicketApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .generate_ticket, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(TicketModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func getTicketList(url: String,parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .list_support_tickets,toAppend: url, loader: true) { (result) in
      
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(TicketListModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func rateCustomer(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .rate_the_customer, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(RateCustomerModal.self, from: data)
               
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func deleteAccount(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .deleteAccount, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(RateCustomerModal.self, from: data)
               
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    
    static func generateTicket(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .generateSupportTicket, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(RateCustomerModal.self, from: data)
               
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Login Via Access tokem
    static func loginWithAccessToken(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .loginViaAccessToken, loader: true) { (result) in
            switch result {
            case .success(let json):
                let data = try! json[APIKeys.data.rawValue].rawData()
                var model = try! JSONDecoder().decode(UserModel.self, from: data)
                model.passcode = UserModel.currentUser.passcode
                UserModel.currentUser = model
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func updateDriverLocation(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .update_driver_location, loader: false) { (result) in
            switch result {
            case .success(let json):
//               
                print("success",json)
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Create profile
    static func createProfileWithImage(parameters: [String: Any], image: [String : UIImage], response: @escaping ((Result<(Any?), Error>) -> Void)) {

        commonPostAPIWithImage(endPoint: .updateDriverProfile, parameters: parameters, image: image) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(ProfileModel.self, from: data)
                ProfileModel.currentUserProfile = model
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - Add BANK Account API
    static func addAccountApi(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .addAccount, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
//                let data = try! json[APIKeys.data.rawValue].rawData()
//                let model = try! JSONDecoder().decode(UserModel.self, from: data)
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Logout
    static func logoutDriver(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonDeleteRawJsonAPI(parameters: parameters, endPoint: .logout_driver) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(UserModel.self, from: data)
                UserModel.currentUser = model
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Get User Profile detail
    static func getAccountDetails(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .accountDetail, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode(UserProfileModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}

