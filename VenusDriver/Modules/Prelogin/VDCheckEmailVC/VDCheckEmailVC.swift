//
//  VDCheckEmailVC.swift
//  VenusDriver
//
//  Created by Amit on 13/06/23.
//

import UIKit

class VDCheckEmailVC: VDBaseVC {

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDCheckEmailVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {

    }

    @IBAction func btnResetPassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDResetPasswordVC.create(), animated: true)
    }
}
