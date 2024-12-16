//
//  WebServices+AboutUs.swift
//  VenusDriver
//
//  Created by Amit on 12/09/23.
//

import Foundation

extension WebServices {

    // MARK: - To Get Information URL's
    static func getInformationUrls(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .getInformationUrls, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json["data"].rawData()
                let model = try! JSONDecoder().decode(InformationURLModel.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
