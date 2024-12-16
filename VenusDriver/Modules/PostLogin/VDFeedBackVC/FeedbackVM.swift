//
//  FeedbackVM.swift
//  VenusDriver
//
//  Created by Gurinder Singh on 04/07/24.
//

import UIKit
import Foundation
class FeedbackVM: NSObject {

    var objRateCustomerModal : RateCustomerModal?
    
    func rateCustomer(_ attributes: [String:Any],completion:@escaping (() -> Void)) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.rateCustomer(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
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
    
    func generateSupportTicket(_ attributes: [String:Any],completion:@escaping (() -> Void)) {
        var paramToModifyVehicleDetails: JSONDictionary {
            return attributes
        }

        WebServices.generateTicket(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                printDebug(data)
                //objRateCustomerModal = data
                completion()
             
            case .failure(let error):
                printDebug(error.localizedDescription)
                Proxy.shared.displayStatusCodeAlert(error.localizedDescription, title: "")
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }


}
