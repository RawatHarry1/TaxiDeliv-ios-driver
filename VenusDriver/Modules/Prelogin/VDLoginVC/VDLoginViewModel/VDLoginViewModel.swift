//
//  VDLoginViewModel.swift
//  VenusDriver
//
//  Created by Amit on 24/07/23.
//

import Foundation
import CoreLocation


class VDLoginViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var otpVerifiedCallBack: ((UserModel) -> ()) = { _ in}

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    override init() {
        super.init()
    }
}


//MARK: LOGIN API'S
extension VDLoginViewModel {
    func validateLoginDetails(_ dial_code: String, _ phone: String, _ location: CLLocation?,passcode : String? = ""){
        if phone == "" {
            error = CustomError(title: "", description: Const_Str.phone_invalid, code: 0)
            return
        } 
//        else if phone.count < 10 || phone.count > 10{
//            error = CustomError(title: "", description: Const_Str.phone_invalid, code: 0)
//            return
//        } 
        else if location == nil {
            error = CustomError(title: "", description: Const_Str.notabletoGetLocation, code: 0)
            return
        } else {
            var attributes = [String:Any]()
            attributes["countryCode"] = dial_code
            attributes["phoneNo"] = phone
            attributes["longitude"] = location?.coordinate.longitude
            attributes["latitude"] = location?.coordinate.latitude
            if passcode != ""
            {
                attributes["passcode"] = passcode

            }
            loginWithPhoneNumber(attributes)
        }
    }

    func loginWithPhoneNumber(_ attributes: [String:Any]) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.generateOtpWithLogin(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                self?.successCallBack(true)
            case .failure(let error2):
                printDebug(error2.localizedDescription)
                self?.error = CustomError(title: "", description: error2.localizedDescription, code: 0)
//                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }

    func loginWithOtp(_ attributes: [String:Any],failer:@escaping ((String) -> Void)) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.verifyLoginOTP(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                self?.otpVerifiedCallBack(data as! UserModel)
            case .failure(let error):
                printDebug(error.localizedDescription)
                failer(error.localizedDescription)
                //  SKToast.show(withMessage: error.localizedDescription)
                
            }
        }
    }

    func logoutApi() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.logoutDriver(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                RideStatus = .none
                VDUserDefaults.removeAllValues()
                VDRouter.loadPreloginScreen()
                UserDefaults.standard.set("false", forKey: "isLogin")
                
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    // TODO: - Login with access token
    func loginWithAccessToken() {
        if let _ = LocationTracker.shared.lastLocation {
        } else {
            failedToFetchLocation = true
            SKToast.show(withMessage: "Not able to fetch your location")
            return
        }
        var paramToModifyVehicleDetails: JSONDictionary {
            if let location = LocationTracker.shared.lastLocation {
                let param = [
                    "latitude": location.coordinate.latitude ,
                    "longitude": location.coordinate.longitude
                ] as [String: Any]
                return param
            } else {
                return [String:Any]()
            }
        }

        WebServices.loginWithAccessToken(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let _):
                VDRouter.goToSaveUserVC()
            case .failure(let error):
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
