//
//  VDResetPasswordVC.swift
//  VenusDriver
//
//  Created by Amit on 13/06/23.
//

import UIKit

class VDResetPasswordVC: VDBaseVC {

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDResetPasswordVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {

    }

    @IBAction func btnUpdatePassword(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }

}
