//
//  Webservices+ClientConfigure.swift
//  VenusDriver
//
//  Created by Amit on 20/07/23.
//

import Foundation

extension WebServices {
    // MARK: - To Get FAQ Sub-Category List
    static func getClientConfig(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .getClientConfig, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json[APIKeys.data.rawValue].rawData()
                let model = try! JSONDecoder().decode(ClientModel.self, from: data)
                ClientModel.currentClientData = model
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
