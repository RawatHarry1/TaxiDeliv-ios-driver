//
//  VDPayoutInfoVC.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import UIKit

class VDPayoutInfoVC: VDBaseVC {

    @IBOutlet weak var bankNameTF: SkyfieldTF!
    @IBOutlet weak var accountNumberTF: SkyfieldTF!
    @IBOutlet weak var accountHolderNameTF: SkyfieldTF!
    @IBOutlet weak var mobileWalletTF: SkyfieldTF!
    
    var viewModel = VDPayoutInfoViewModel()
    var loginViewModel = VDLoginViewModel()

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDPayoutInfoVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        viewModel.successCallBack = { status in
            var userData = UserModel.currentUser
            userData.login?.registration_step_completed?.is_bank_details_completed = true
            UserModel.currentUser = userData
            self.loginViewModel.loginWithAccessToken()
            VDRouter.goToSaveUserVC() // Set Root View As VDLGMainVC
            self.navigationController?.pushViewController(VDLGMainVC.create() , animated: true)
        }

        UserModel.currentUser.login?.registration_step_completed?.is_document_uploaded = true

        // Show Error Alert
        self.viewModel.showAlertClosure = {
            if let error = self.viewModel.error {
                CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
            }
        }
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnSubmit(_ sender: UIButton) {
        self.view.endEditing(true)
        if (accountHolderNameTF.text ?? "") == "" && (accountNumberTF.text ?? "").trimmed == "" && (bankNameTF.text ?? "") == "" {
            var userData = UserModel.currentUser
            userData.login?.registration_step_completed?.is_bank_details_completed = true
            UserModel.currentUser = userData
            self.loginViewModel.loginWithAccessToken()
//            VDRouter.goToSaveUserVC()
//            self.navigationController?.pushViewController(VDLGMainVC.create() , animated: true)
        } else {
            self.viewModel.validatePayoutDetails((accountHolderNameTF.text ?? ""), (accountNumberTF.text ?? "").trimmed, (bankNameTF.text ?? "").trimmed, (mobileWalletTF.text ?? "").trimmed)
        }
    }
    
    @IBAction func btnSkipAction(_ sender: Any) {
        var userData = UserModel.currentUser
        userData.login?.registration_step_completed?.is_bank_details_completed = true
        UserModel.currentUser = userData
        self.loginViewModel.loginWithAccessToken()
    }
    
}
