//
//  WebServices+Wallet.swift
//  VenusDriver
//
//  Created by Amit on 12/09/23.
//

import Foundation

extension WebServices {
    // MARK: - To fetch wallet Balance
    static func fetchWalletBalance(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .fetchWalletBalance, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode(VDWalletModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    
    static func addMoney(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostWithRawJSONAPI(parameters: parameters, endPoint: .add_money_via_stripe, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(cancelScheduleModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }

    // MARK: - To fetch wallet transactions
    static func fetchWalletTransaction(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonPostAPI(parameters: parameters, endPoint: .getTransactionHistory, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode(VDTransactionsModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
