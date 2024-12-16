//
//  VDPayoutInfoViewModel.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import Foundation


class VDPayoutInfoViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var updateDocumentList : ((VehicleFeatures) -> ()) = { _ in }

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var vehicleFeatures : VehicleFeatures! {
        didSet {
            self.updateDocumentList(vehicleFeatures)
        }
    }

    override init() {
        super.init()
    }
}


//MARK: LOGIN API'S
extension VDPayoutInfoViewModel {

    func validatePayoutDetails(_ name: String, _ iban: String, _ bankName: String, _ mobileWallet: String){
        if bankName == "" {
            error = CustomError(title: "", description: Const_Str.emptyBankName, code: 0)
            return
        } else if iban == "" {
            error = CustomError(title: "", description: Const_Str.emptyAccountNumber, code: 0)
            return
        } else if name == "" {
            error = CustomError(title: "", description: Const_Str.emptyAccountHoldername, code: 0)
            return
        } else if mobileWallet == "" {
            error = CustomError(title: "", description: Const_Str.emptyMobileWallet, code: 0)
            return
        } else {
            var attributes = [String:Any]()
            attributes["name"] = name
            attributes["iban"] = iban
            attributes["mobile_wallet"] = mobileWallet
            addPayoutInformation(attributes)
        }
    }

    func addPayoutInformation(_ attributes: [String: Any]) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.addAccountApi(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                self?.successCallBack(true)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
