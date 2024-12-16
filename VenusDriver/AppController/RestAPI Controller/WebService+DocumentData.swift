//
//  WebService+DocumentData.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import Foundation

extension WebServices {
    // MARK: - To FetchDocumentList
    static func getDocumentList(parameters: JSONDictionary, response: @escaping ((Result<(Any?), Error>) -> Void)) {
        commonGetAPI(parameters: parameters, endPoint: .fetchRequiredDocs, loader: true) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(DocumentList.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }


    // MARK: - To uploadDocument
    static func uploadDocumentApi(parameters: [String: Any], image: [String : UIImage], response: @escaping ((Result<(Any?), Error>) -> Void)) {

        commonPostAPIWithImage(endPoint: .uploadDocument, parameters: parameters, image: image) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
//                let data = try! json[APIKeys.data.rawValue].rawData()
                response(.success(json))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
    
    static func uploadPackageImageApi(parameters: [String: Any], image: [String : UIImage], response: @escaping ((Result<(Any?), Error>) -> Void)) {

        commonPostAPIWithImage(endPoint: .upload_file_driver, parameters: parameters, image: image) { (result) in
            switch result {
            case .success(let json):
                printDebug(json)
                let data = try! json.rawData()
                let model = try! JSONDecoder().decode(UplodPhotoModal.self, from: data)
                response(.success(model))
            case .failure(let error):
                response(.failure(error))
            }
        }
    }
}
