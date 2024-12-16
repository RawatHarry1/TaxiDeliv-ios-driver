//
//  VCLogoutVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/07/23.
//

import UIKit

class VDLogoutVC: VDBaseVC {

    // MARK: -> Variables
    private var loginViewModel: VDLoginViewModel = VDLoginViewModel()

    // MARK: -> Outlets
    var cancelCallBack : ((Bool) -> ()) = { _ in }


    //  To create ViewModel
    static func create() -> VDLogoutVC {
        let obj = VDLogoutVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        // Show Error Alert
        self.loginViewModel.showAlertClosure = {
            if let error = self.loginViewModel.error {
                CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
            }
        }


//        self.dismiss(animated: true) {
//            self.cancelCallBack(true)
//        }
    }

    @IBAction func cancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.cancelCallBack(false)
        }

    }

    @IBAction func logoutBtn(_ sender: UIButton) {
        loginViewModel.logoutApi()
    }
}
