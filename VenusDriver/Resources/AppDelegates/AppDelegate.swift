//
//  AppDelegate.swift
//  VenusDriver
//
//  Created by Amit on 05/06/23.
//

import UIKit
import CoreData
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import AVKit
var audioPlayer: AVAudioPlayer?
var objDelivery_packages = [DeliveryPackageData]()
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var player: AVAudioPlayer?
    var window:UIWindow?
    var appEnvironment: AppEnvironment = .dev
    var isFromNotification = false
    var walletUpdateNotificationClicked = false
    var notficationDetails: PushNotification?
   
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let isLogin = "\(UserDefaults.standard.value(forKey: "isLogin") ?? "")"
        if isLogin == "true"{
            let storyboard = UIStoryboard(name: "PostLogin", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "VDHomeVC") as! VDHomeVC
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.navigationBar.isHidden = true
            self.window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        
        
        // IQKeyboardManager setup
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true

        GMSServices.provideAPIKey("AIzaSyA12Rbcs3mWSpYuJkkSODZameeQRmlXR4U")
        LocationTracker.shared.checkLocationEnableStatus()
        if LocationTracker.shared.isLocationPermissionGranted() {
            LocationTracker.shared.enableLocationServices()
        }else {
            DispatchQueue.main.async {
                LocationTracker.shared.enableLocationServices()
            }
        }
        getGlobalPropertyList()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForPushNotification()

        isFromNotification = false
        if launchOptions?[.remoteNotification] != nil {
            isFromNotification = true
        } else {
//            VDRouter.setInitialViewController()
        }

        VCSocketIOManager.shared.closeConnection()
        VCSocketIOManager.shared = VCSocketIOManager()
        VCSocketIOManager.shared.connectSocket {
//            VCSocketServices.shared.listenForCallAndChatEvents()
        }
        
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10.0, *){
           
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, error) in
                if !accepted {
                    print("Notification access denied.")
                }
                else {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        }
        application.registerForRemoteNotifications()
        //************************************************************************
        //Push Notification method *************************************
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            //***************************************************************
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func scheduleNotification() {
            let content = UNMutableNotificationContent()
            content.title = "Custom Sound Notification"
            content.body = "This is a notification with a custom sound!"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "custom_sound.caf"))
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error adding notification: \(error.localizedDescription)")
                }
            }
        }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillResignActive(_ application: UIApplication) {
        isFromNotification = false
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        isFromNotification = false
        startBackgroundTask()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
          endBackgroundTask()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "VenusDriver")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    private func startBackgroundTask() {
         backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "SocketBackgroundTask") {
             self.endBackgroundTask()
         }
     }

     private func endBackgroundTask() {
         if backgroundTask != .invalid {
             UIApplication.shared.endBackgroundTask(backgroundTask)
             backgroundTask = .invalid
         }
     }
}

extension AppDelegate {
    
    func playSound() {
           if let soundURL = Bundle.main.url(forResource: "sound", withExtension: "mp3") {
               do {
                   audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                   audioPlayer?.numberOfLoops = -1  // Loop indefinitely
                   audioPlayer?.play()
               } catch {
                   print("Error playing custom sound: \(error.localizedDescription)")
               }
           }
       }
}
