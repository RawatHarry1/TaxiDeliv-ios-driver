//
//  VDAccountViewModel.swift
//  VenusDriver
//
//  Created by Amit on 02/08/23.
//

import Foundation


class VDAccountViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((UserProfileModel) -> ()) = { _ in }

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var accountDetails : UserProfileModel! {
        didSet {
            self.successCallBack(accountDetails)
        }
    }

    override init() {
        super.init()
    }
}

// MARK: - API's
extension VDAccountViewModel {

    func getAccountDetail() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.getAccountDetails(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                if let obj = data as? UserProfileModel {
                    self?.accountDetails = obj
                }
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }

}

