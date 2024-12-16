//
//  VDWalletViewModel.swift
//  VenusDriver
//
//  Created by Amit on 27/08/23.
//

import Foundation


class VDWalletViewModel: NSObject {

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var successCallBack : ((Bool) -> ()) = { _ in }
    var updateWalletDetails : ((VDWalletModel) -> ()) = { _ in }
    var updateWalletTransactions : ((VDTransactionsModel) -> ()) = { _ in }


    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var walletDetail : VDWalletModel! {
        didSet {
            self.updateWalletDetails(walletDetail)
        }
    }

    private(set) var walletDetails : VDTransactionsModel! {
        didSet {
            self.updateWalletTransactions(walletDetails)
        }
    }


    override init() {
        super.init()
    }
}


    // MARK: - API's
extension VDWalletViewModel {
    func fetchWalletBalance() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.fetchWalletBalance(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data as? VDWalletModel else { return }
                self?.walletDetail = data
                printDebug(data)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func fetchwalletTransactions() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.fetchWalletTransaction(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data as? VDTransactionsModel else { return }
//                guard let transactions = data.transactions else {return}
                self?.walletDetails = data
                printDebug(data)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
    
    
    func addAmountApi(cardID: String,amount:String,currency:String,completion:@escaping() -> Void) {
        var attributes : JSONDictionary {
            var att = [String: Any]()
            att["stripe_3d_enabled"] = "1"
            att["card_id"] = cardID
            att["amount"] = amount
            att["currency"] = currency
            return att
        }
        WebServices.addMoney(parameters: attributes, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
//                guard let dataModel = data as? WalletHistoryModal else { return }
//                print(dataModel)
//                self?.objWalletModal = dataModel
                completion()
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
