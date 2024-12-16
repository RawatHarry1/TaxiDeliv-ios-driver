//
//  VDAddMunicipleCardVC.swift
//  VenusDriver
//
//  Created by Amit on 20/06/23.
//

import UIKit

class VDAddMunicipleCardVC: VDBaseVC {
    var screenType = 0

    //  To create ViewModel
    static func create(_ type: Int = 0) -> UIViewController {
        let obj = VDAddMunicipleCardVC.instantiate(fromAppStoryboard: .documents)
        obj.screenType = type
        return obj
    }

    @IBAction func btnNext(_ sender: UIButton) {
        if screenType != 0 {
            self.navigationController?.pushViewController(VDElectricVC.create(), animated: true)
        } else {
        }
    }


    @IBAction func btnBack(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
    }
}
