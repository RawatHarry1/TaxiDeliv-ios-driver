//
//  TCNotificationActionController.swift
//  TaxiCoinUser
//
//  Created by Appinventiv on 04/03/22.
//  Copyright © 2022 Bhavya. All rights reserved.
//
import Foundation
import UIKit

class VDNotificationActionController : NSObject {
    
    static let shared = VDNotificationActionController()

    private override init () {
        super.init()
    }
    
    // MARK: - Navigate To Chat VC
    func updateHomeScreenFromUI() {
        switch UIApplication.shared.applicationState {
        case .active :
            printDebug("App is in background mode")

        case .inactive, .background :
            if let login = UserModel.currentUser.login {
                if UserModel.currentUser.access_token != "" &&  UserModel.isAllStepsCompleted(login.registration_step_completed ?? Registration_step_completed(), login.mandatory_registration_steps ?? Mandatory_registration_steps()) {
                    VDRouter.goToSaveUserVC()
                }
            }
            printDebug("App is in background mode")
        @unknown default: break
        }
    }

    func goToWalletScreen() {
        if sharedAppDelegate.isFromNotification {
            VDRouter.goToWalletVC()
        } else {
            if let currentVc = sharedAppDelegate.window?.currentViewController as? VDLGMainVC {
                if let _ = currentVc.rootViewController as? VDWalletVC {
                    // DO Nothing
                } else {
                    let vc = VDWalletVC.create()
                    vc.fromNotificationClick = true
                    self.navigationVC?.pushViewController(vc, animated: true)
                }
            } else {
                let vc = VDWalletVC.create()
                vc.fromNotificationClick = true
                self.navigationVC?.pushViewController(vc, animated: true)
            }
        }

    }

}

extension VDNotificationActionController {
    
    var navigationVC: UINavigationController? {
        var navigationVC: UINavigationController?
        if let currentVc = sharedAppDelegate.window?.currentViewController {
            navigationVC = currentVc.navigationController
        }
        navigationVC?.delegate = nil
        return navigationVC
    }
}
