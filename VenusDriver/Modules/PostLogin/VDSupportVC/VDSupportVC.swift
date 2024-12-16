//
//  VDSupportVC.swift
//  VenusDriver
//
//  Created by Amit on 18/06/23.
//

import UIKit

class VDSupportVC: VDBaseVC {

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDSupportVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    override func initialSetup() {

    }

    @IBAction func btnSideMenu(_ sender: UIButton) {
        NotificationCenter.default.post(name: .openSideMenu, object: nil)
    }

    @IBAction func btnContactUs(_ sender: UIButton) {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.rootViewController = VDContactusVC.create()
    }

    @IBAction func btnFAQ(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDFAQVC.create(), animated: true)
    }
}
