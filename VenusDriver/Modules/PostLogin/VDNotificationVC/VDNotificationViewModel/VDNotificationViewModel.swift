//
//  VDNotificationViewModel.swift
//  VenusDriver
//
//  Created by Amit on 28/08/23.
//

import Foundation


class VDNotificationViewModel: NSObject{

    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var notificationListSuccessCallBack : (([NotificationDetails]) -> ()) = { _ in }


    var error: CustomError? {
        didSet { self.showAlertClosure?() }
    }

    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }

    private(set) var notificationArr : [NotificationDetails]! {
        didSet {
            self.notificationListSuccessCallBack(notificationArr)
        }
    }

    override init() {
        super.init()
    }
}

// MARK: - API's
extension VDNotificationViewModel {
    func fetchNotificationList() {
        var paramToModifyVehicleDetails: JSONDictionary {
            return [String: Any]()
        }

        WebServices.fetchNotificationList(parameters: paramToModifyVehicleDetails, response: { [weak self] (result) in
            switch result {
            case .success(let data):
                guard let data = data as? [NotificationDetails] else { return }
                self?.notificationArr = data
                printDebug(data)
            case .failure(let error):
                printDebug(error.localizedDescription)
                SKToast.show(withMessage: error.localizedDescription)
            }
        })
    }
}
