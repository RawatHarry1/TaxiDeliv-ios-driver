//
//  SignUpCompleteVC.swift
//  VenusDriver
//
//  Created by Amit on 10/06/23.
//

import UIKit
import LGSideMenuController

class VDSignUpCompleteVC: VDBaseVC {

    @IBOutlet weak var imgCheck: UIImageView!
    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDSignUpCompleteVC.instantiate(fromAppStoryboard: .preLogin)
        return obj
    }

    override func initialSetup() {
        imgCheck.image = imgCheck.image?.withRenderingMode(.alwaysTemplate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            var vc = VDElectricVC.create(0)
            vc.fromWelcome = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
