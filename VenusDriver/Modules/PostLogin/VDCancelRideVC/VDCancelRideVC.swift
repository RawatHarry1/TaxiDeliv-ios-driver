//
//  VCCancelRideVC.swift
//  VenusCustomer
//
//  Created by Amit on 13/07/23.
//

import UIKit

class VDCancelRideVC: VDBaseVC {

    var onConfirm:((Int) -> Void)?

    @IBOutlet var btnNo: VDButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var lblCancel: UILabel!
    //  To create ViewModel
    static func create() -> VDCancelRideVC {
        let obj = VDCancelRideVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }
    override func viewDidLoad() {
       if UserModel.currentUser.login?.service_type == 2
        {
           lblCancel.text = "Cancel the delivery Request?"
           btnCancel.setTitle("Cancel delivery", for: .normal)
//           btnNo.setTitle("Don’t reject", for: .normal)
       }
    }
    @IBAction func btnNo(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onConfirm?(0)
        }
    }

    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true) {
            self.onConfirm?(1)
        }
    }
}
