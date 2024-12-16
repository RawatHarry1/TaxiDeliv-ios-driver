//
//  VDSideMenuViewModel.swift
//  VenusDriver
//
//  Created by Amit on 10/09/23.
//

import Foundation


class VDSideMenuViewModel: NSObject {

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var updateWaalletDetails : ((VDWalletModel) -> ()) = { _ in }
    var vehicleListCallBack : (([VehiclesList]) -> ()) = {_ in }
    var informationUrlsCallback : ((InformationURLModel) -> ()) = { _ in }

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var walletDetail : VDWalletModel! {
        didSet {
            self.updateWaalletDetails(walletDetail)
        }
    }

    private(set) var vehicleList : [VehiclesList]! {
        didSet {
            self.vehicleListCallBack(vehicleList)
        }
    }

    private(set) var informationUrls : InformationURLModel! {
        didSet {
            self.informationUrlsCallback(informationUrls)
        }
    }

    override init() {
        super.init()
    }
}

// MARK: - APIs
extension VDSideMenuViewModel {

    func fetchDriverDocuments() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.getDriverVehicleList(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data as? VehicleDetailModel else { return }
                if let docStatus = data.docStatus {
                    if docStatus.lowercased() == "approved" {
                        guard let vehicleArray = data.vehicle_array else {
                            SKToast.show(withMessage: "Vehicle not found.")
                            return
                        }
                        self?.vehicleList = vehicleArray
                    } else {
                        Proxy.shared.documentsNotUploadedCodeAlert("Your documents are not approved from admin.",title: "Documents")
                       // SKToast.show(withMessage: "Your documents are not approved from admin.")
                    }
                }
                printDebug(data)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func fetchUrlInformation() {
        var paramToModifyVehicleDetails: JSONDictionary {
            var attributes = [String: Any]()
            attributes["cityId"] = UserModel.currentUser.login?.city ?? 0
            attributes["operatorId"] = ClientModel.currentClientData.operator_id ?? 0
            return attributes
        }

        WebServices.getInformationUrls(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                guard let urls = data as? InformationURLModel else { return }
                self?.informationUrls = urls
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
    
    func deleteAccount(_ attributes: [String:Any],completion:@escaping (() -> Void)) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.deleteAccount(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                //objRateCustomerModal = data
                completion()
             
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
}
