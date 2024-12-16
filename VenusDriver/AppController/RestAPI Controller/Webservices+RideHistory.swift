//
//  Webservices+RideHistory.swift
//  VenusDriver
//
//  Created by Amit on 03/08/23.
//

import Foundation

extension WebServices {
    // MARK: - To Fetch booking list
    static func getBookingHistoryList(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .bookingHistory, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode([BookingHistoryModel].self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Fetch booking details
    static func getBookingDetail(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .bookingDetail, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode(BookingDetailModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To Fetch Earning list
    static func getEarningList(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostAPI(parameters: parameters, endPoint: .getAllEarning, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode(VDEarningListModel.self, from: data)
                response(.success(data))
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    //MARK: - To fetch notifications
    static func fetchNotificationList(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .fetchNotifications, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode([NotificationDetails].self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
