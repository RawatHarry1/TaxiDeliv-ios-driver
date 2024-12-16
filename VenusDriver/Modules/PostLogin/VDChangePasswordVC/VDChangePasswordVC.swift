//
//  VDChangePasswordVC.swift
//  VenusDriver
//
//  Created by Amit on 18/06/23.
//

import UIKit

class VDChangePasswordVC: VDBaseVC {

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDChangePasswordVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {

    }

    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
