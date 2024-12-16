//
//  LocationTracker.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import Foundation
import CoreLocation

typealias LocateMeCallback = (_ location: CLLocation?) -> Void

/*
 LocationTracker to track the user in while navigating from one place to other and store new locations in locations array.
 **/
class LocationTracker: NSObject {

    static let shared = LocationTracker()
    var lastLocation: CLLocation?
    var previousLocation: CLLocation?

    var locationManager: CLLocationManager = {
       let locationManager = CLLocationManager()
       locationManager.activityType = .automotiveNavigation
       locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
       locationManager.distanceFilter = 10
       return locationManager
    }()

    var locateMeCallback: LocateMeCallback?

    var isCurrentLocationAvailable: Bool {
        if lastLocation != nil, lastLocation!.timestamp.timeIntervalSinceNow < 10 {
          return true
        }
        return false
    }

    func isLocationPermissionGranted() -> Bool {
        guard CLLocationManager.locationServicesEnabled() else { return false }
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        return [.authorizedAlways, .authorizedWhenInUse].contains(CLLocationManager.authorizationStatus())
    }

    func isLocationAccuracyPermissionGranted() -> Bool {
        if #available(iOS 14.0, *) {
            switch locationManager.accuracyAuthorization {
            case .fullAccuracy:
               return true
            case .reducedAccuracy:
                return false
            @unknown default:
                return false
            }
        } else {
            return false
        }
    }

    func checkLocationEnableStatus() {
        switch CLLocationManager.authorizationStatus() {
        case .restricted, .denied:
            NotificationCenter.default.post(name: .gpsStatus, object: nil, userInfo: ["status" : GPSStatus.never])
        case .authorizedWhenInUse:
            NotificationCenter.default.post(name: .gpsStatus, object: nil, userInfo: ["status" : GPSStatus.whenInUse])
        case .authorizedAlways:
            NotificationCenter.default.post(name: .gpsStatus, object: nil, userInfo: ["status" : GPSStatus.always])
        default:
            printDebug("No issue")
        }
    }

    func enableLocationServices() {
        locationManager.delegate = self
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            printDebug("Fail permission to get current location of user")
        case .authorizedWhenInUse:
            enableMyWhenInUseFeatures()
        case .authorizedAlways:
            enableMyAlwaysFeatures()
        @unknown default:
            break
        }
    }

    func enableMyWhenInUseFeatures() {
       locationManager.startUpdatingLocation()
       locationManager.delegate = self
       escalateLocationServiceAuthorization()
    }

    func escalateLocationServiceAuthorization() {
        // Escalate only when the authorization is set to when-in-use
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func enableMyAlwaysFeatures() {
       locationManager.allowsBackgroundLocationUpdates = true
       locationManager.showsBackgroundLocationIndicator = true
       locationManager.pausesLocationUpdatesAutomatically = true
       locationManager.startUpdatingLocation()
       locationManager.delegate = self
    }

    func locateMeOnLocationChange(callback: @escaping LocateMeCallback) {
        self.locateMeCallback = callback
        if lastLocation == nil {
            enableLocationServices()
        } else {
           callback(lastLocation)
        }
    }

    func startTracking() {
         enableLocationServices()
    }

    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    private override init() {}
}

// MARK: - CLLocationManagerDelegate
extension LocationTracker: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
//        guard location.timestamp.timeIntervalSinceNow < 10 || location.horizontalAccuracy > 0 else {
//            printDebug("invalid location received")
//            return
//        }
        if failedToFetchLocation {
            failedToFetchLocation = false
            NotificationCenter.default.post(name: .updateAccessTokenAPI, object: nil)
        }
        previousLocation = lastLocation
        lastLocation = location
        locateMeCallback?(location)
      //  NotificationCenter.default.post(name: .liveLocation, object: nil, userInfo: ["current":lastLocation,"previous":previousLocation])
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        printDebug(error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        enableLocationServices()
    }
}

extension CLLocationCoordinate2D {

//    var coordinatesDictionary: JSONDictionary {
//        return ["coordinates": [longitude, latitude]]
//    }
    var isZero : Bool {
        return longitude == 0 && latitude == 0
    }
}
