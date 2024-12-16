//
//  VCCancelRideVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit

class VDCancelRideVC: VDBaseVC {

    var onConfirm:((Int) -> Void)?

    //  To create ViewModel
    static func create() -> VDCancelRideVC {
        let obj = VDCancelRideVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    @IBAction func btnNo(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onConfirm?(0)
        }
    }

    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onConfirm?(1)
        }
    }
}
