//
//  Webservices+EndPoints.swift
//
//
//  Created by Admin on 03/11/21.
//

import Foundation

extension WebServices {
    
    enum EndPoint: String {
        
        case getClientConfig = "/getClientConfig"
        case generateLoginOtp = "/driver/generateLoginOtp"
        case login = "/driver/login"
        case rate_the_customer = "/rate_the_customer"
        case generateSupportTicket = "/generate_support_ticket"
        case loginViaAccessToken = "/loginViaAccessToken"
        case update_driver_location = "/update_driver_location"
        case updateDriverProfile = "/updateDriverProfile"
        case fetchRequiredDocs = "/fetchRequiredDocs"
        case uploadDocument = "/uploadDocument"
        case logout_driver = "/logout_driver"
        case getCityVehicles = "/getCityVehicles"
        case updateVehicle = "/driver/add_new_vehicle"
        case addAccount = "/payouts/addAccount"
        case accountDetail = "/driver/profile"
        case bookingHistory = "/driver/bookingHistory"
        case bookingDetail = "/driver/getTripSummary"
        case getAllEarning = "/getDriverAllEarningsV2"
        case acceptTrip = "/driver/acceptTripRequest"
        case rejectTrip = "/driver/rejectTripRequest"
        case cancelTrip = "/cancelTheTrip"
        case srartTrip = "/driver/startTrip"
        case markArrived = "/driver/markArrived"
        case changeDriverAvailability = "/changeAvailability"
        case fetchWalletBalance = "/driver/walletBalance"
        case fetchNotifications = "/driver/notifications"
        case fetchOngoingTrip = "/driver/fetchOngoingTrip"
        case endRide = "/driver/endTrip"
        case fetchVehicleDetails = "/driver/fetch_driver_vehicles"
        case getInformationUrls = "/getInformationUrls"
        case getTransactionHistory = "/get_transaction_history"
        case newRidePolyline = "maps/api/directions/json"
        case deleteAccount = "/removeAccount"
        case addCard = "/stripe/add_card_3d"
        case confirmCard = "/stripe/confirm_card_3d"
        case getCard = "/fetch/cardDetails?payment_method_type=1"
        case deleteCard = "/removeCard"
        case add_money_via_stripe = "/add_money_via_stripe"
        case upload_file_driver = "/upload_file_driver"
        case update_delivery_package_status = "/update_delivery_package_status"
        case generate_ticket = "/generate_ticket"
        case list_support_tickets = "/list_support_tickets"
        case generate_ride_end_otp = "/generate_ride_end_otp"
        
        // MARK: - API url path
        var path: String {
            return sharedAppDelegate.appEnvironment.baseURL + rawValue
        }

        var googlePlacePath : String {
            return sharedAppDelegate.appEnvironment.googlePlaceURL + rawValue
        }
    }
}
