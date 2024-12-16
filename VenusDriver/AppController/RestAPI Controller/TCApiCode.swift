//
//  TDApiCode.swift
//  
//
//  Created by Admin on 03/11/21.
//

import Foundation

enum TDApiCode: Int {
    case success = 143
    case resourceCreated = 201
    case unauthorized = 401
    case badRequest = 400
    case undetermined = -224
    case actionDeclined = 422
    case resourceDeleted = 204
    case userExists = 405
    case emailExists = 406
    case passwordNotSet = 403
    case invalidSeession = 113
    case blockUser = 441
    case appUpdate = 426
    case trasactionNotApproved = 412
//    case walletAlreadyRegistered = 427
    case documentsNotApproved = 144
    case lowBalance = 427
    case userBlocked = 600
}

enum TDAPIErrorCode: Int {
    case notAllowed = 4220
    case resourceDeleted = 422
}
