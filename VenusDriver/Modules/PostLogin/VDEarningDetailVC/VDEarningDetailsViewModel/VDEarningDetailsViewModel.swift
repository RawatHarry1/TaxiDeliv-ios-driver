//
//  VDEarningDetailsViewModel.swift
//  VenusDriver
//
//  Created by Amit on 03/08/23.
//

import Foundation


class VDEarningDetailViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var bookingHistorysuccessCallBack : ((BookingDetailModel) -> ()) = { _ in }

    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var bookingdetails : BookingDetailModel! {
        didSet {
            self.bookingHistorysuccessCallBack(bookingdetails)
        }
    }

    override init() {
        super.init()
    }
}


// MARK: - API's
extension VDEarningDetailViewModel {
    func fetchBookingHistory(_ attributes: [String:Any]) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.getBookingDetail(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data as? BookingDetailModel else { return }
                self?.bookingdetails = data
                printDebug(data)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
