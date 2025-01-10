//
//  VCLogoutVC.swift
//  VenusCustomer
//
//  Created by Amit on 10/07/23.
//

import UIKit

class VDLogoutVC: VDBaseVC {

    // MARK: -> Variables
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    private var loginViewModel: VDLoginViewModel = VDLoginViewModel()

    // MARK: -> Outlets
    var cancelCallBack : ((Bool) -> ()) = { _ in }
    // MARK: -> Outlets
    var sucessCallback : ((Bool) -> ()) = { _ in }

    var descriptionText = "";
    var rejectPackage = false
    //  To create ViewModel
    static func create() -> VDLogoutVC {
        let obj = VDLogoutVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {
        // Show Error Alert
        if rejectPackage == false
        {
            self.loginViewModel.showAlertClosure = {
                if let error = self.loginViewModel.error {
                    CustomAlertView.showAlertControllerWith(title: error.title ?? "", message: error.errorDescription, onVc: self, buttons: ["OK"], completion: nil)
                }
            }
        }
        if rejectPackage == true
        {
            
            lblDescription.text = descriptionText
            lblDescription.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            btnLogout.setTitle("Reject/ Cancel Delivery", for: .normal)
            btnLogout.setTitleColor(UIColor.black, for: .normal)
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
        
        if rejectPackage == true{
            self.dismiss(animated: true) {
                self.sucessCallback(true)
            }
        }
        else
        {
            loginViewModel.logoutApi()

        }
    }
}
