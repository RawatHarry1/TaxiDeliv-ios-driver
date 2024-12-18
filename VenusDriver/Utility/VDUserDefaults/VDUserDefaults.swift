//
//  VDUserDefaults.swift
//  VenusDriver
//
//  Created by Amit on 24/07/23.
//

import Foundation

import UIKit

enum VDUserDefaults {

    static func value(forKey key: Key,
                      file: String = #file,
                      line: Int = #line,
                      function: String = #function) -> JSON {

        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            printDebug("No Value Found in UserDefaults\nFile: \(file) \nLine Number: \(line) \nFunction: \(function)")
            return JSON.null
        }

        return JSON(value)
    }

    static func value<T>(forKey key: Key,
                         fallBackValue: T,
                         file: String = #file,
                         line: Int = #line,
                         function: String = #function) -> JSON {

        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {

            printDebug("No Value Found in UserDefaults\nFile: \(file) \nFunction: \(function)")
            return JSON(fallBackValue)
        }

        return JSON(value)
    }

    static func save(value: Any, forKey key: Key) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    static func removeValue(forKey key: Key) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    static func register(defaults: JSONDictionary) {
        UserDefaults.standard.register(defaults: defaults)
    }

    static func removeAllValues() {
        UIApplication.shared.applicationIconBadgeNumber = 0
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        LocationTracker.shared.stopTracking()
        let deviceToken = VDUserDefaults.value(forKey: .deviceToken)
        UserDefaults.standard.synchronize()
        save(value: false, forKey: .isLoggedIn)
        save(value: deviceToken.stringValue, forKey: .deviceToken)
        resetStaticValues()
        removeValue(forKey: .userData)
        removeValue(forKey: .userProfile)
        removeValue(forKey: .isDriverAvailable)
        removeValue(forKey: .currentLocation)
        removeValue(forKey: .oldDriverCoordinates)
        removeValue(forKey: .mapType)
        removeValue(forKey: .mapDetail)
        RideStatus = .none
        sharedAppDelegate.notficationDetails = nil
//        removeValue(forKey: .clientData)
    }
    /// Reset all static values of shared object stored in user defaults
    private static func resetStaticValues() {
        UserModel.currentUser = UserModel()
//        ClientModel.currentClientData = ClientModel()
//        TDSaveRideModel.currentRide = TDSaveRideModel()
    }
}

// MARK: Keys
extension VDUserDefaults {

    enum Key: String {
        case isLoggedIn
        case currentLocation
        case isGuestUser
        case authorization
        case isPushNotificationEnabled
        case appLanguage = "AppleLanguages"
        case environment
        case versionInfo
        case buildNumber
        case countryCollectionData
        case deviceToken
        case rideData
        case clientData
        case userData
        case userProfile
        case isDriverAvailable
        case oldDriverCoordinates
        case google_map_keys
        case showIntroScreens
        case service_type
        case mapType
        case mapDetail
        
    }
}
