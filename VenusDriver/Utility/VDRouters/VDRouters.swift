//
//  VDRouters.swift
//  VenusDriver
//
//  Created by Amit on 25/07/23.
//

import Foundation


struct VDRouter {

    // MARK: - To Set Initial ViewController
    static func setInitialViewController() {
        let navigationController = UINavigationController(rootViewController: VDSplashVC.create())
        navigationController.navigationBar.isHidden = true
        sharedAppDelegate.window?.rootViewController = navigationController
        sharedAppDelegate.window?.makeKeyAndVisible()
    }

    // MARK: - To Check Initial App Flow
    static func checkAppinitializationFlow() {
        if UserModel.currentUser.access_token != "" &&  UserModel.currentUser.access_token != nil && (UserModel.currentUser.login?.is_registration_complete ?? false) == true {
            goToSaveUserVC()
        } else {
            loadPreloginScreen()
        }
    }

    // MARK: - Go To Splash Screen
    static func loadPreloginScreen(_ shouldRetainUserDefaults: Bool = false) {
        VDUserDefaults.removeAllValues()
        let landingScene = VDWelcomeVC.create()
        let navigationController = UINavigationController(rootViewController: landingScene)
        navigationController.navigationBar.isHidden = true
        setRoot(viewController: navigationController)

    }

    // MARK: - Set Root VC
    private static func setRoot(viewController: UIViewController?) {
//        sharedAppDelegate.window?.rootViewController = viewController
//        sharedAppDelegate.window?.makeKeyAndVisible()
        
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    static func goToSaveUserVC() {
    //   let navigationController = UINavigationController(rootViewController: VDLGMainVC.create())
//        navigationController.navigationBar.isHidden = true
//        setRoot(viewController: navigationController)
        let story = UIStoryboard(name: "PostLogin", bundle:nil)
                let vc = story.instantiateViewController(withIdentifier: "VDLGMainVC") as! VDLGMainVC
                UIApplication.shared.windows.first?.rootViewController = vc
                UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    static func goToWalletVC() {
        let vc = VDWalletVC.create()
        vc.fromNotificationClick = true
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.isHidden = true
        setRoot(viewController: navigationController)
    }
}
