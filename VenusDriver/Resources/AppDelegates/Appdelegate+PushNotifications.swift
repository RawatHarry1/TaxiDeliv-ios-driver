//
//  Appdelegate+PushNotifications.swift
//  VenusDriver
//
//  Created by Amit on 12/08/23.
//

import Foundation
import UIKit
import os.log
import UserNotifications
import FirebaseMessaging
import AVFAudio

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content.mutableCopy() as! UNMutableNotificationContent
              content.sound = UNNotificationSound(named: UNNotificationSoundName("sound.mp3"))
        let navigation = (window?.rootViewController as? UINavigationController)
        NSLog("User Info didReceive = ",response.notification.request.content.userInfo)
        if let userInfo = response.notification.request.content.userInfo as NSDictionary? as? [String: Any] {
            switch notificationTypes(rawValue: (userInfo["notification_type"] as? String) ?? "0") {
            case .new_ride_request, .scheduleRide :
                
                if let data = (userInfo["notificationDetails"] as? String)?.data(using: .utf8), let model = try? JSONDecoder().decode(PushNotification.self, from: data)  {
                    printDebug(model)
                    DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                        objDelivery_packages = model.delivery_packages ?? []
                              
                    }
                    let notificationFireTime = ConvertDateToLocalTimeZone(date: model.date ?? "")
                    if (notificationFireTime + 30) < Date() {
                        printDebug("Notification Expire.")
                    } else {
                       //
                        sharedAppDelegate.notficationDetails = model
                        if let login = UserModel.currentUser.login {
                            if UserModel.currentUser.access_token != "" &&  UserModel.isAllStepsCompleted(login.registration_step_completed ?? Registration_step_completed(), login.mandatory_registration_steps ?? Mandatory_registration_steps()) {
                                VDRouter.goToSaveUserVC()
                            }
                        }
                        let notificationType: [AnyHashable: String] = ["notificationType" : (userInfo["notificationDetails"] as? String ?? "")]
                        NotificationCenter.default.post(name: .newRideRequest, object: notificationType)
                    }
                }
                return completionHandler()
            case .wallet_update :
                if let _ = UserModel.currentUser.access_token {
                    sharedAppDelegate.walletUpdateNotificationClicked = true
                    
                    if let data = (userInfo["notificationDetails"] as? String)?.data(using: .utf8), let model = try? JSONDecoder().decode(PushNotification.self, from: data)  {
                        var currentUser = UserModel.currentUser
                        currentUser.login?.actual_credit_balance = model.driverBalanceData?.wallet_balance
                        currentUser.login?.min_driver_balance = model.driverBalanceData?.min_driver_balance
                        UserModel.currentUser = currentUser
                    }
                    NotificationCenter.default.post(name: .updateWalletBalance, object: nil, userInfo: nil)
                    VDNotificationActionController.shared.goToWalletScreen()
                } else {
                    
                }
                
                completionHandler()
            case .message :
                
                if let topVC = UIApplication.topViewController() {
                    print("Current top view controller: \(topVC)")
                    
                    // Check if the top view controller is of the type you are interested in
                    if topVC is VDChatVC {
                        print("ChatViewController is currently visible")
                    } else {
                        navigateToChatOnce = true
                        navigateToChat = true
                        NotificationCenter.default.post(name: .newMessage, object: nil, userInfo: userInfo)
                        print("ChatViewController is not visible")
                    }
                } else {
                    print("No view controller found")
                }
                
                
                
            
                
//                
//                if navigation?.visibleViewController?.isKind(of: VDChatVC.self) ?? false   {
//                    //  NotificationCenter.default.post(name: NSNotification.Name("NotificationRefresh"), object: nil, userInfo: userInfo as? [AnyHashable : Any])
//                    print("nai banni gal")
//                }else{
//                  
//                }
//                if !isChatViewController() {
//                    NotificationCenter.default.post(name: .newMessage, object: nil, userInfo: nil)
//                       }
               
            case .request_timeout, .request_cancelled :
                sharedAppDelegate.notficationDetails = nil
                RideStatus = .none
                NotificationCenter.default.post(name: .clearNotification, object: nil)
            default : return completionHandler()
            }
        } else {

        }
        completionHandler()
    }


    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        NSLog("User Info didReceive = ",notification)
        let userInfo = notification.request.content.userInfo //notification.request.content.userInfo
        printDebug(userInfo)
        switch notificationTypes(rawValue: (userInfo["notification_type"] as? String) ?? "0") {
        case .new_ride_request, .scheduleRide :
            if let data = (userInfo["notificationDetails"] as? String)?.data(using: .utf8), let model = try? JSONDecoder().decode(PushNotification.self, from: data)  {
                printDebug(model)
                DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    objDelivery_packages = model.delivery_packages ?? []
                          
                }
               
                playSound()
                
                objDelivery_packages = model.delivery_packages ?? []
                sharedAppDelegate.notficationDetails = model
                let notificationType: [AnyHashable: String] = ["notificationType" : (userInfo["notificationDetails"] as? String ?? "")]
               // NotificationCenter.default.post(name: .newRideRequest, object: notificationType)
            }
            
            if let data = (userInfo["notificationDetails"] as? String)?.data(using: .utf8), let model = try? JSONDecoder().decode(PushNotification.self, from: data)  {
                printDebug(model)
                let notificationFireTime = ConvertDateToLocalTimeZone(date: model.date ?? "")
//                if (notificationFireTime + 30) < Date() {
//                    printDebug("Notification Expire.")
//                } else {
                objDelivery_packages = model.delivery_packages ?? []
                    sharedAppDelegate.notficationDetails = model
                    if let login = UserModel.currentUser.login {
                        if UserModel.currentUser.access_token != "" &&  UserModel.isAllStepsCompleted(login.registration_step_completed ?? Registration_step_completed(), login.mandatory_registration_steps ?? Mandatory_registration_steps()) {
                            VDRouter.goToSaveUserVC()
                        }
                    }
                    let notificationType: [AnyHashable: String] = ["notificationType" : (userInfo["notificationDetails"] as? String ?? "")]
                    NotificationCenter.default.post(name: .newRideRequest, object: notificationType)
               // }
            }
            
//            return completionHandler([.alert, .sound])
        case .wallet_update :
            if let data = (userInfo["notificationDetails"] as? String)?.data(using: .utf8), let model = try? JSONDecoder().decode(PushNotification.self, from: data)  {
                var currentUser = UserModel.currentUser
                currentUser.login?.actual_credit_balance = model.driverBalanceData?.wallet_balance
                currentUser.login?.min_driver_balance = model.driverBalanceData?.min_driver_balance
                UserModel.currentUser = currentUser
            }
            NotificationCenter.default.post(name: .updateWalletBalance, object: nil, userInfo: nil)
            completionHandler( [.alert, .sound,.badge])
        case .request_timeout, .request_cancelled :
            sharedAppDelegate.notficationDetails = nil
            RideStatus = .none
            NotificationCenter.default.post(name: .clearNotification, object: nil)
            completionHandler( [.alert, .sound,.badge])
        case.message:
           
            NotificationCenter.default.post(name: .messageReceiver, object: nil, userInfo: nil)
            completionHandler( [.alert, .sound,.badge])
        default: printDebug("")
      //  default : return completionHandler([.alert, .sound])
        }
        return completionHandler([.alert,.badge])
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        NSLog("User Info didReceive = ",userInfo)
        let userInfo = userInfo //notification.request.content.userInfo
        printDebug(userInfo)
        switch notificationTypes(rawValue: (userInfo["notification_type"] as? String) ?? "0") {
        case .new_ride_request, .scheduleRide :
            if let data = (userInfo["notificationDetails"] as? String)?.data(using: .utf8), let model = try? JSONDecoder().decode(PushNotification.self, from: data)  {
                printDebug(model)
                DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                    objDelivery_packages = model.delivery_packages ?? []
                          
                }
                
                playSound()
                
                
                sharedAppDelegate.notficationDetails = model
                let notificationType: [AnyHashable: String] = ["notificationType" : (userInfo["notificationDetails"] as? String ?? "")]
               // NotificationCenter.default.post(name: .newRideRequest, object: notificationType)
            }
            
            if let data = (userInfo["notificationDetails"] as? String)?.data(using: .utf8), let model = try? JSONDecoder().decode(PushNotification.self, from: data)  {
                printDebug(model)
                let notificationFireTime = ConvertDateToLocalTimeZone(date: model.date ?? "")
                if (notificationFireTime + 30) < Date() {
                    printDebug("Notification Expire.")
                } else {
                    sharedAppDelegate.notficationDetails = model
                    if let login = UserModel.currentUser.login {
                        if UserModel.currentUser.access_token != "" &&  UserModel.isAllStepsCompleted(login.registration_step_completed ?? Registration_step_completed(), login.mandatory_registration_steps ?? Mandatory_registration_steps()) {
                            VDRouter.goToSaveUserVC()
                        }
                    }
                    let notificationType: [AnyHashable: String] = ["notificationType" : (userInfo["notificationDetails"] as? String ?? "")]
                    NotificationCenter.default.post(name: .newRideRequest, object: notificationType)
                }
            }
            
//            return completionHandler([.alert, .sound])
        case .wallet_update :
            if let data = (userInfo["notificationDetails"] as? String)?.data(using: .utf8), let model = try? JSONDecoder().decode(PushNotification.self, from: data)  {
                var currentUser = UserModel.currentUser
                currentUser.login?.actual_credit_balance = model.driverBalanceData?.wallet_balance
                currentUser.login?.min_driver_balance = model.driverBalanceData?.min_driver_balance
                UserModel.currentUser = currentUser
            }
            NotificationCenter.default.post(name: .updateWalletBalance, object: nil, userInfo: nil)
        case .request_timeout, .request_cancelled :
            sharedAppDelegate.notficationDetails = nil
            RideStatus = .none
            NotificationCenter.default.post(name: .clearNotification, object: nil)
            
        case.message:
           
            NotificationCenter.default.post(name: .messageReceiver, object: nil, userInfo: nil)
        default: printDebug("")
      //  default : return completionHandler([.alert, .sound])
        }
      //  completionHandler( [.alert, .sound])
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        printDebug(token)
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)

    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        printDebug(error.localizedDescription)
        SKToast.show(withMessage: "FCM tokem Failed!!! \(error.localizedDescription)")

    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        DeviceDetail.deviceToken = fcmToken!
    }
    
   


    func registerForPushNotification() {
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            guard error == nil else {
                return
            }
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    //                    NotificationCenter.default.post(name: .notficationIdentifier, object: [true])
                }
            } else {
                //                NotificationCenter.default.post(name: .notficationIdentifier, object: [false])
            }
        }
    }
    
//    func topViewController(_ rootViewController: UIViewController? = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
//        if let navigationController = rootViewController as? UINavigationController {
//            return topViewController(navigationController.visibleViewController)
//        }
//        
//        // Replace this with your own way to find the currently visible view controller within VDLGMainVC
//        if let sideMenuController = rootViewController as? VDLGMainVC {
//            // Assuming VDLGMainVC has a method or property to get the visible view controller
//            // This is a placeholder; adjust according to your actual implementation
//            if let visibleVC = sideMenuController.rootViewController {
//                return topViewController(visibleVC)
//            }
//        }
//        
//        if let presented = rootViewController?.presentedViewController {
//            return topViewController(presented)
//        }
//        
//        return rootViewController
//    }
    
    
   
//    func isChatViewController() -> Bool {
//        if let currentVC = topViewController() {
//            return currentVC is VDChatVC
//        }
//        return false
//    }
    func isChatViewControllerActive() -> Bool {
        if let topController = UIApplication.topViewController() {
            if topController is VDChatVC {
                return true
            }
            // Check if ChatViewController is in the navigation stack
            if let navigationController = topController.navigationController {
                return navigationController.viewControllers.contains { $0 is VDChatVC }
            }
        }
        return false
    }
    

}
import UIKit

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter { $0.isKeyWindow }.first?.rootViewController) -> UIViewController? {
        guard let controller = controller else { return nil }
        
        // Debug information
        print("Checking view controller: \(controller)")

        if let navController = controller as? UINavigationController {
            return topViewController(controller: navController.visibleViewController)
        }

        if let tabController = controller as? UITabBarController {
            return topViewController(controller: tabController.selectedViewController)
        }

       // if let presentedController = controller {
            // Handle custom side menu controller if needed
            if let sideMenuController = controller as? VDLGMainVC {
                return topViewController(controller: sideMenuController.rootViewController)
            }
          //  return topViewController(controller: presentedController)
       // }

        return controller
    }
}
