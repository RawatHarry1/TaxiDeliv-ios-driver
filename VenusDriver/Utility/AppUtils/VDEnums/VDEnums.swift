//
//  VDEnums.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import Foundation

enum GPSStatus {
    case always
    case whenInUse
    case never
}

enum bundleIdentifiers : String,CaseIterable {
    case venus = "com.venus.driverr"
    case salone = "com.venus.driver"
}

enum signUpSteps: Int {
    case profile = 1
    case document_upload = 2
    case vehicle_info = 3
    case bank_details = 4
    case none = 0
}

enum notificationTypes: String {
    case new_ride_request = "0"
    case request_timeout = "1"
    case request_cancelled = "2"
    case ride_started = "3"
    case ride_ended = "4"
    case ride_accepted_by_other_driver = "6"
    case ride_rejected_by_driver = "7"
    case wallet_update = "120"
    case message = "600"
    case scheduleRide = "126"
}


enum rideStatus: String {
    case none = "4"
    case availableRide = "0"
    case acceptedRide = "1"
    case customerPickedUp = "2"
    case rideCompleted = "3"
    case markArrived = "14"
}


enum selectionTypeVehicleList: Int {
    //0 for colors, 1 for models, 2 for years // 3 for vehicle types
    case colors = 0
    case models = 1
    case years = 2
    case vehicleType = 3
    case cityList = 4
}

enum TxnEventTypes : Int {
    case default_status = 0
    case topup = 1
    case cash_refund = 2
    case driver_commission = 3
    case driver_add_money_view_panel = 24
    case driver_credit_visa_panel = 25
}

enum DocumentStatus : String {
    case pending = "PENDING"
    case approved = "APPROVED"
    case rejected = "REJECTED"
    case notUploaded = "NOT_UPLOADED"
    case uploaded = "UPLOADED"
    case expired = "EXPIRED"
}


enum ValidationFailedPopUpType : String {
    case pendingVerification = "pendingVerification"
    case failedVarification = "failedVarification"
    case lowBalance = "lowBalance"
    case userBlocked = "userBlocked"
    case thresholdReached = "thresholdReached"
    
    var icon : UIImage? {
        switch self {
        case .failedVarification : return VDImageAsset.documentError.asset
        case .pendingVerification : return VDImageAsset.clock.asset
        case .lowBalance : return VDImageAsset.insufficientBalance.asset
        case .userBlocked : return VDImageAsset.userBlocked.asset
        case .thresholdReached : return VDImageAsset.userBlocked.asset
        }
    }
    
    var desc : String {
        switch self {
        case .failedVarification : return "Need to take action on your documents. Please check Documents in menu."
        case .pendingVerification : return "Your Document Verification is in process. Please wait until it's verified."
        case .lowBalance :  return "Your wallet balance is currently running low. Please recharge your wallet."
        case .userBlocked : return "Your account has been blocked. Please contact Admin."
        case .thresholdReached : return "You will not receive any rides due to threshold reached."
        }
    }
    
    var showButton: Bool {
        switch self {
        case .failedVarification : return false
        case .pendingVerification : return true
        case .lowBalance : return true
        case .userBlocked : return true
        case .thresholdReached : return true
        }
    }
    
    var buttonText  : String {
        switch self {
        case .failedVarification : return "Upload"
        case .pendingVerification : return ""
        case .lowBalance : return "Recharge"
        case .userBlocked : return ""
        case .thresholdReached : return ""
        }
    }
}
