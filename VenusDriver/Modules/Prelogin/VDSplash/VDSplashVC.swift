//
//  VDSplashVC.swift
//  VenusDriver
//
//  Created by Amit on 05/06/23.
//

import UIKit
import CoreLocation

class VDSplashVC: VDBaseVC {
    //  To create ViewModel
    var window: UIWindow?
    var timer: Timer?
    var counter = 15.0
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    static func create() -> VDSplashVC {
        let obj = VDSplashVC.instantiate(fromAppStoryboard: .main)
        return obj
    }
}

// MARK: - Lifecycle fuction
extension VDSplashVC {
    override func initialSetup() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkLocationServices()
        if sharedAppDelegate.walletUpdateNotificationClicked {
            sharedAppDelegate.walletUpdateNotificationClicked = false
            return
        }
        //callAPIs()
        addObservers()
    }
    
    
    
    @objc func appWillEnterForeground() {
        checkLocationServices()
    }
}

// MARK: - Custom Methods
extension VDSplashVC{
    private func callAPIs() {
        if let login = UserModel.currentUser.login {
            if UserModel.currentUser.access_token != "" &&  UserModel.isAllStepsCompleted(login.registration_step_completed ?? Registration_step_completed(), login.mandatory_registration_steps ?? Mandatory_registration_steps()) {
                delay(withSeconds: 1.0) {
                    self.loginWithAccessToken()
                    self.apiClientConfigure2()
                }
            } else {
                apiClientConfigure()
            }
        } else {
            apiClientConfigure()
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateAccessTokenAPI(notification:)), name: .updateAccessTokenAPI, object: nil)
    }
    
    @objc func updateAccessTokenAPI( notification: Notification) {
        self.loginWithAccessToken()
    }
}

// MARK: - API's
extension VDSplashVC {
    // TODO: - Configure client
    
    
    private func apiClientConfigure2() {
        var paramToModifyVehicleDetails: JSONDictionary {
            var param = [
                "packageName": "com.app.earthDriver",
            ] as [String: Any]
            
            if let passcode = UserModel.currentUser.passcode
            {
                param["passcode"] = passcode
            }
            return param
        }
        
        
        WebServices.getClientConfig(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                if let update_location_timmer = ClientModel.currentClientData.update_location_timmer {
                    self?.timer = Timer.scheduledTimer(timeInterval: ClientModel.currentClientData.update_location_timmer!, target: self!, selector: #selector(self!.updateDriverLocation), userInfo: nil, repeats: true)
                }else{
                    self?.timer = Timer.scheduledTimer(timeInterval: self!.counter, target: self!, selector: #selector(self!.updateDriverLocation), userInfo: nil, repeats: true)
                }
                
                let isLogin = "\(UserDefaults.standard.value(forKey: "isLogin") ?? "")"
             //   if isLogin == "true"{
                    
                    //self?.loginWithAccessToken()
//                }else{
//                    if whiteLabelProperties.packageName == bundleIdentifiers.venus.rawValue {
//                        self?.navigationController?.pushViewController(VDIntroVC.create(), animated: true)
//                    } else {
//                        let showIntroScreens = VDUserDefaults.value(forKey: .showIntroScreens)
//                        if showIntroScreens == true{
//                            VDRouter.loadPreloginScreen()
//                        }else{
//                            self?.navigationController?.pushViewController(SIIntroScreensVC.create(), animated: true)
//                        }
//                    }
//                }
                
            case .failure(let error):
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    
    private func apiClientConfigure() {
        var paramToModifyVehicleDetails: JSONDictionary {
            var param = [
                "packageName": "com.app.earthDriver",
            ] as [String: Any]
            if let passcode = UserModel.currentUser.passcode
            {
                param["passcode"] = passcode
            }
            
            return param
        }
        
        
        WebServices.getClientConfig(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let data):
                if let update_location_timmer = ClientModel.currentClientData.update_location_timmer {
                    self?.timer = Timer.scheduledTimer(timeInterval: ClientModel.currentClientData.update_location_timmer!, target: self!, selector: #selector(self!.updateDriverLocation), userInfo: nil, repeats: true)
                }else{
                    self?.timer = Timer.scheduledTimer(timeInterval: self!.counter, target: self!, selector: #selector(self!.updateDriverLocation), userInfo: nil, repeats: true)
                }
                
                let isLogin = "\(UserDefaults.standard.value(forKey: "isLogin") ?? "")"
                if isLogin == "true"{
                    
                    self?.loginWithAccessToken()
                }else{
                    if whiteLabelProperties.packageName == bundleIdentifiers.venus.rawValue {
                        self?.navigationController?.pushViewController(VDIntroVC.create(), animated: true)
                    } else {
                        let showIntroScreens = VDUserDefaults.value(forKey: .showIntroScreens)
                        if showIntroScreens == true{
                            VDRouter.loadPreloginScreen()
                        }else{
                            self?.navigationController?.pushViewController(SIIntroScreensVC.create(), animated: true)
                        }
                    }
                }
                
            case .failure(let error):
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    
    // TODO: - Login with access token
    private func loginWithAccessToken() {
        if let _ = LocationTracker.shared.lastLocation {
        } else {
            failedToFetchLocation = true
            SKToast.show(withMessage: "Not able to fetch your location")
            return
        }
        var paramToModifyVehicleDetails: JSONDictionary {
            if let location = LocationTracker.shared.lastLocation {
                let param = [
                    "latitude": location.coordinate.latitude ,
                    "longitude": location.coordinate.longitude
                ] as [String: Any]
                return param
            } else {
                return [String:Any]()
            }
        }
        
        WebServices.loginWithAccessToken(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
            switch result {
            case .success(let _):
                if let update_location_timmer = ClientModel.currentClientData.update_location_timmer {
                    self?.timer = Timer.scheduledTimer(timeInterval: ClientModel.currentClientData.update_location_timmer!, target: self!, selector: #selector(self!.updateDriverLocation), userInfo: nil, repeats: true)
                }else{
                    self?.timer = Timer.scheduledTimer(timeInterval: self!.counter, target: self!, selector: #selector(self!.updateDriverLocation), userInfo: nil, repeats: true)
                }
                VDRouter.goToSaveUserVC()
            case .failure(let error):
                SKToast.show(withMessage: error.localizedDescription)
            }
        }
    }
    
    @objc func updateDriverLocation() {
        print("\(counter) seconds to the end of the world")
        if let _ = LocationTracker.shared.lastLocation {
            
        }else {
            failedToFetchLocation = true
            SKToast.show(withMessage: "Not able to fetch your location")
            return
        }
        var paramToModifyVehicleDetails: JSONDictionary {
            if let location = LocationTracker.shared.lastLocation {
                let param = [
                    "latitude": location.coordinate.latitude ,
                    "longitude": location.coordinate.longitude
                ] as [String: Any]
                return param
            } else {
                return [String:Any]()
            }
        }
        
        if let accessToken = UserModel.currentUser.access_token {
            WebServices.updateDriverLocation(parameters: paramToModifyVehicleDetails) { [weak self] (result) in
                switch result {
                case .success(let _):
                    // VDRouter.goToSaveUserVC()
                    print("Success Driver Location")
                case .failure(let error):
                    SKToast.show(withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    @objc func appWillResignActive() {
        // Register a background task to keep the app running
        registerBackgroundTask()
    }
    
    @objc func appDidBecomeActive() {
        // End the background task
        endBackgroundTask()
    }
    
    func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "updateDriverLocation") {
            self.endBackgroundTask()
        }
        assert(backgroundTask != .invalid)
    }
    
    func endBackgroundTask() {
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        // Invalidate the timer when the view disappears to stop the network requests
        // timer?.invalidate()
        
        // End the background task if the view is no longer visible
        endBackgroundTask()
    }
}

extension VDSplashVC{
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // Location services are enabled
            checkLocationAuthorization()
        } else {
            // Location services are not enabled, show alert
            showAlertForLocationSettings()
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            // Location is authorized, you can start getting location updates
            locationManager.startUpdatingLocation()
            callAPIs()
        case .denied, .restricted:
            // User denied location services, show alert
            showAlertForLocationSettings()
        case .notDetermined:
            // First-time permission request
            locationManager.requestWhenInUseAuthorization()
            callAPIs()
        @unknown default:
            break
        }
    }
    
    func showAlertForLocationSettings() {
        let alertController = UIAlertController(
            title: "Location Services Off",
            message: "Please enable location services to continue using the app.",
            preferredStyle: .alert
        )
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        //let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(settingsAction)
        // alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
