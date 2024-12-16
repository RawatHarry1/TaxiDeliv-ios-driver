//
//  VDForgotPasswordVC.swift
//  VenusDriver
//
//  Created by Amit on 10/06/23.
//

import UIKit

class VDForgotPasswordVC: VDBaseVC {

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDForgotPasswordVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func btnResetPassword(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDCheckEmailVC.create(), animated: true)
    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
