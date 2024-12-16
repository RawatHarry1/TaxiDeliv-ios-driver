//
//  VersionUpdateVC.swift
//  VenusCustomer
//
//  Created by Gurinder Singh on 06/08/24.
//

import UIKit

class VersionUpdateVC: UIViewController {
    
    @IBOutlet weak var btnLater: UIButton!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let obj = UserModel.currentUser.login?.popup
        if obj?.is_force == 0{
            self.btnLater.isHidden = false
        }else{
            self.btnLater.isHidden = true
        }
        
        lblDescription.text = obj?.popup_text ?? ""
    }
    
    
    @IBAction func btnLaterAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func btnUpdateNowAction(_ sender: Any) {
        if let url = URL(string: UserModel.currentUser.login?.popup?.download_link ?? "") {
            // Check if the URL can be opened
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: { (success) in
                    if success {
                        print("Opened URL: \(url)")
                    } else {
                        print("Failed to open URL: \(url)")
                    }
                })
            } else {
                print("Cannot open URL: \(url)")
            }
        }
    }
}
    

