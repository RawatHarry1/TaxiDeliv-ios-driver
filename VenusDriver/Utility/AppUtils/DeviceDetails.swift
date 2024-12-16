//
//  DeviceDetails.swift
//  VenusDriver
//
//  Created by Amit on 23/08/23.
//

import Foundation
import UIKit

struct DeviceDetail {
    enum IPhoneModel {
        case sE
        case plus
        case regular
        case iPhoneX
    }
    /// Enum - NetworkTypes
    enum NetworkType: String {
        case _2G = "2G"
        case _3G = "3G"
        case _4G = "4G"
        case lte = "LTE"
        case wifi = "Wifi"
        case none = ""
    }

    /// Device Model
    static let deviceModel : String = {
        return UIDevice.current.model
    }()

    /// OS Version
    static let osVersion : String = {
        return UIDevice.current.systemVersion
    }()

    /// Platform
    static let platform : String = {
        return UIDevice.current.systemName
    }()

    /// Device Id
    static let deviceId : String = {
        return UIDevice.current.identifierForVendor!.uuidString
    }()

    static let ipaddress : String = {
        return getWiFiAddress()
    }()

    static let model : IPhoneModel = {
        let device = UIDevice.current
        if device.userInterfaceIdiom == .phone {
            switch UIScreen.main.bounds.height {
            case 568:
                return .sE

            case 667:
                return .regular

            case 960,1104,736:
                return .plus

            case 2436,2688,1792,812,896,780,844,926:
                return .iPhoneX

            default:
                return .regular
            }
        }
        return .sE
    }()

    private static func getWiFiAddress() -> String {
        var address : String = ""

        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        if getifaddrs(&ifaddr) == 0 {

            // For each interface ...
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                let interface = ptr?.pointee

                // Check for IPv4 or IPv6 interface:
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {

                    // Check interface name:
                    if let name = String(validatingUTF8: (interface?.ifa_name)!), name == "en0" {

                        // Convert interface address to a human readable string:
                        var addr = interface?.ifa_addr.pointee
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        if let val = try? socklen_t((interface?.ifa_addr.pointee.sa_len)!) {
                            getnameinfo(&addr!, val,
                                        &hostname, socklen_t(hostname.count),
                                        nil, socklen_t(0), NI_NUMERICHOST)
                            address = String(cString: hostname)
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }

        return address
    }

    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()

    static let countryLocale : String = {
        (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as? String ?? "US"
    }()

    static var deviceToken : String = "123456" {
        didSet {
            updateDeviceToken(deviceToken)
        }
    }

    static func aspectSize(ratio: CGFloat = 16/9) -> CGSize {
        let width = 22.2 // UIDevice.width
        let height = width/ratio

        return CGSize(width: width, height: height)
    }

    private static func updateDeviceToken(_ deviceToken:String) {
        VDUserDefaults.save(value: deviceToken, forKey:.deviceToken)
    }

    static let deviceType : String = {
        return "1"
    }()
}
