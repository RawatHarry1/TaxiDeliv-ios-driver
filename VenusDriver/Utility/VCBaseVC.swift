//
//  VCBaseVC.swift
//  VenusCustomer
//
//  Created by Amit on 05/06/23.
//

import UIKit
import CoreLocation
class VCBaseVC: UIViewController {

    let barAppearance = UINavigationBarAppearance()
    var locationManager: CLLocationManager!
    override var prefersStatusBarHidden: Bool {
        return false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // Properties
    var setNavigationBarHidden = true {
        didSet {
            navigationController?.setNavigationBarHidden(setNavigationBarHidden, animated: true)
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
        }
    }

    var isIQKeyboardEnabled = true {
        didSet {
             IQKeyboardManager.shared.enable = isIQKeyboardEnabled
        }
    }
}

// MARK: - ViewController Life Cycle
extension VCBaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the location manager
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            
            // Request location permissions
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
        DispatchQueue.main.async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
            }
        }
            // Start updating location
            
        
        initialSetup()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: - Setup functions
extension VCBaseVC {
    /// The initial setup function called from viewDidLoad()
    @objc func initialSetup() {
        // Initial setup for the class, is called in view did load
    }
    @objc func getCurrentLocation(lat: CLLocationDegrees,long:CLLocationDegrees) {
        // Initial setup for the class, is called in view did load
    }
}
extension VCBaseVC:CLLocationManagerDelegate{
    // Delegate method to receive location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        
        // Get the current latitude and longitude
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        
        print("Current location: \(latitude), \(longitude)")
        getCurrentLocation(lat: latitude, long: longitude)
        // Stop updating location to save battery life
        locationManager.stopUpdatingLocation()
    }
    
    // Delegate method to handle authorization status changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            // Location permission not determined
            print("Location permission not determined")
        case .restricted, .denied:
            // Location services restricted or denied
            print("Location services restricted or denied")
        case .authorizedWhenInUse, .authorizedAlways:
            // Location services authorized
            print("Location services authorized")
            locationManager.startUpdatingLocation()
        @unknown default:
            fatalError("Unexpected authorization status")
        }
    }
    
    // Delegate method to handle location manager errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}
extension Notification.Name {
    static let getAllMessages = Notification.Name("getAllMessages")
    static let getSingleMessage = Notification.Name("getSingleMessage")
}
