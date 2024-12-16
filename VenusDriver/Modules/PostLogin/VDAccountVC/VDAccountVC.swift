//
//  VDAccountVC.swift
//  VenusDriver
//
//  Created by Amit on 18/06/23.
//

import UIKit

class VDAccountVC: VDBaseVC {

    @IBOutlet weak var lblAccountType: UILabel!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var userNameLbl: UILabel!
    

    //  To create ViewModel
    static func create() -> UIViewController {
        let obj = VDAccountVC.instantiate(fromAppStoryboard: .postLogin)
        return obj
    }

    private var accountViewModel: VDAccountViewModel = VDAccountViewModel()


    override func initialSetup() {
       
        if UserModel.currentUser.login?.service_type == 1 {
           lblAccountType.text = "Ride"
        }else{
            lblAccountType.text = "Delivery"
        }
        childView.cornerRadius = 40
        childView.addShadowView(radius: 15)

        profileImageView.image = profileImageView.image?.withRenderingMode(.alwaysTemplate)
        profileImageView.tintColor = VDColors.buttonSelectedOrange.color

        accountViewModel.successCallBack = { obj in
            printDebug(obj)
            self.firstNameLbl.text = obj.first_name ?? ""
            self.lastNameLbl.text = obj.last_name ?? ""
            if obj.address == ",," || obj.address == "" {
                self.addressLbl.text = "-"
            } else {
                self.addressLbl.text = obj.address ?? ""
            }
            self.phoneLbl.text = obj.phone_no ?? ""
            self.emailLabel.text = obj.email ?? ""
            self.userNameLbl.text = obj.name ?? ""
            if let urlStr = obj.driver_image {
                self.profileImageView.setImage(urlStr)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        accountViewModel.getAccountDetail()
    }

    func showAppUpdateVC() {
        guard let currentVC  = sharedAppDelegate.window?.currentViewController else { return }
        let controller =  VDLGMainVC.instantiate(fromAppStoryboard: .postLogin)
        let navController = UINavigationController(rootViewController: controller)
        navController.view.backgroundColor = UIColor.clear
        navController.modalPresentationStyle = .overFullScreen
        currentVC.present(navController, animated: false, completion: nil)

    }

    @IBAction func BtneditProfile(_ sender: UIButton) {
        let vc = VDCreateProfileVC.create(1)
        vc.userProfileModel = self.accountViewModel.accountDetails
        vc.comesFromEditProfile = true
        vc.didPressDismiss = {
            self.accountViewModel.getAccountDetail()
        }
        self.present(vc, animated: true)
       // self.navigationController?.pushViewController(vc, animated: true)
    }


    @IBAction func btnChangePass(_ sender: UIButton) {
        self.navigationController?.pushViewController(VDChangePasswordVC.create(), animated: true)
    }

    @IBAction func btnClose(_ sender: UIButton) {
        guard let sideMenuController = sideMenuController else { return }
        sideMenuController.showLeftView()
//        self.navigationController?.pushViewController(VDLGMainVC.create() , animated: true)
    }
}
