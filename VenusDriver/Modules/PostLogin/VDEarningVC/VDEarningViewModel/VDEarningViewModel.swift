//
//  VDEarningViewModel.swift
//  VenusDriver
//
//  Created by Amit on 03/08/23.
//

import Foundation


class VDEarningViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var bookingHistorysuccessCallBack : (([BookingHistoryModel]) -> ()) = { _ in }
    var earningHistorysuccessCallBack : ((VDEarningListModel) -> ()) = { _ in }


    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var bookingHistoryArr : [BookingHistoryModel]! {
        didSet {
            self.bookingHistorysuccessCallBack(bookingHistoryArr)
        }
    }

    private(set) var earningHistoryDetails : VDEarningListModel! {
        didSet {
            self.earningHistorysuccessCallBack(earningHistoryDetails)
        }
    }

    override init() {
        super.init()
    }
}


// MARK: - API's
extension VDEarningViewModel {
    func fetchBookingHistory() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.getBookingHistoryList(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data as? [BookingHistoryModel] else { return }
                self?.bookingHistoryArr = data
                printDebug(data)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }

    func fetchEarningList(filter : Int? = 0,paymentMode : Int? = 0) {
        var paramToModifyVehicleDetails: JSONDictionary {
            var attributes = [String : Any]()
            attributes["filter"] = filter
            attributes["payment_mode"] = paymentMode
            return attributes
        }

        WebServices.getEarningList(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data as? VDEarningListModel else { return }
                self?.earningHistoryDetails = data
                printDebug(data)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
