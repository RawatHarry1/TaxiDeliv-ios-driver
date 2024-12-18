//
//  VDImageAssets.swift
//  VenusDriver
//
//  Created by Amit on 07/06/23.
//

import UIKit

enum VDImageAsset: String {


    case chooselogin
    case splashbackgroundLogo
    case splashLogo
    case checkBoxOrange
    case cross
    case facebook
    case googleLogo
    case appleLogo
    case backbutton
    case checkEmail
    case check
    case camera
    case imgPlaceholder
    case introFirst
    case introSecond
    case introThird
    case menu
    case offline
    case currentlocation
    case switchEnable
    case switchDisable
    case account
    case bookings
    case contactUs
    case documents
    case earnings
    case logout
    case notifications
    case ratings
    case removeDoc
    case dummyDoc
    case documentAdd
    case countryFlag
    case arrowDown
    case navBackground
    case rideDemo
    case star
    case radioDisable
    case radioEnable
    case addOrange
    case carchair
    case drivinglicense
    case xmlid359
    case unchecked
    case sendMessage
    case introFourth
    case introSalone1
    case introSalone2
    case introSalone3
    case introSalone4
    case walletMask
    case roundCloseBlack
    case topUpWhite
    case topUpArrowBlack
    case wallet
    case home
    case document
    case clock
    case profileImgDummy
    case rateUs
    case ticket
    case likeus
    case legal
    case settingsAboutApp
    case privacyPolicy
    case emailAboutUs
    case arrowRight
    case aboutUs
    case timeIcon
    case alertIcon
    case warningIcon
    case insufficientBalance
    case documentError
    case userBlocked
    case vehicleMarker
    case locationMarker
    case delete
    case creditCard
    var asset: UIImage? {
        return UIImage(named: self.rawValue)
    }
}
