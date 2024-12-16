//
//  VDWalletTCPopUp.swift
//  VenusCustomer
//
//  Created by Amit on 11/07/23.
//

import UIKit

class VDWalletTCPopUp: VDBaseVC {

    var onAccept:((Bool) -> Void)?


    //  To create ViewModel
    static func create() -> VDWalletTCPopUp {
        let obj = VDWalletTCPopUp.instantiate(fromAppStoryboard: .wallet)
        return obj
    }

    @IBAction func btnAccept(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.onAccept?(true)
        }
    }
}
