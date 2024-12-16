//
//  Notification.name+Extension.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import Foundation

extension Notification.Name {
    static let gpsStatus = Notification.Name("gpsStatus")
    static let openSideMenu = Notification.Name("openSideMenu")
    static let closeSideMenu = Notification.Name("closeSideMenu")

    static let newRideRequest = Notification.Name("new_ride_request")
    static let clearNotification = Notification.Name("clear_ongoing_notification")
    static let updateAccessTokenAPI = Notification.Name("updateAccessTokenAPI")
    static let updateWalletBalance = Notification.Name("updateWalletBalance")
    static let newMessage = Notification.Name("newMessage")
    static let messageReceiver = Notification.Name("messageReceiver")
    static let screenRefresh = Notification.Name("screenRefresh")
}
