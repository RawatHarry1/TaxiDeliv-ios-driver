//
//  VDGlobals.swift
//  VenusDriver
//
//  Created by Amit on 11/06/23.
//

import Foundation
import UIKit

var googleAPIKey = ClientModel.currentClientData.google_map_keys
typealias JSONDictionary = [String: Any]
typealias HTTPHeaders = [String:String]
typealias APIResponse = (Result<JSON,NSError>) -> Void
let sharedAppDelegate = UIApplication.shared.delegate as! AppDelegate
typealias ImageCompletionHandlerWithStatus = ((_ status: Bool, _ image: UIImage?) -> Void)?
var whiteLabelProperties: WhiteLabelProperties!
var CountryList = CountriesData.fetchCountries()
var RideStatus: rideStatus = .none
var AvailabilityStatus = false
var failedToFetchLocation = false

var CancelReasons = ["Unable to contact customer", "Vehicle not working", "Pickup distance is more than expected", "Wrong customer pickup location", "More customer to onboard than specified", "Customer taking too much time after arrival"]

func printDebug <T> (_ object1: T , _ object2: T? = nil) {
    #if DEBUG
    if let object2 = object2 {
       print(object1 , object2)
    } else {
        print(object1)
    }
    #endif
}

func delay(withSeconds seconds: Double,_ completion: @escaping (() -> Void)) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: completion)
}

func getGlobalPropertyList() {
    if let url = Bundle.main.url(forResource: "GlobalValuesPropertyList", withExtension: "plist") {
        do {
            let data = try Data(contentsOf: url)
            if let dict = try PropertyListSerialization.propertyList(from: data, format: nil) as? [String : Any]{
                printDebug(dict)
                whiteLabelProperties = try WhiteLabelProperties.init(dict: dict)

            }
            else {
//                return nil
            }

        } catch {
//            return nil
            printDebug("============Error in format properties==============")
        }
    } else {
//        return nil
    }
}



struct WhiteLabelProperties:Codable {

    var appButtonGradient: Bool
    var appName: String
    var packageName: String

    enum CodingKeys: String, CodingKey {
        case appName = "appName"
        case appButtonGradient = "appButtonGradient"
        case packageName = "packageName"
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        appName = try value.decodeIfPresent(String.self, forKey: .appName) ?? ""
        appButtonGradient = try value.decodeIfPresent(Bool.self, forKey: .appButtonGradient) ?? false
        packageName = try value.decodeIfPresent(String.self, forKey: .packageName) ?? ""
    }

    init() {
        appButtonGradient = false
        appName = ""
        packageName = ""
    }

    init(dict: [String: Any]) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
        let decoder = JSONDecoder()
        self = try decoder.decode(Self.self, from: jsonData)
    }
}


let currentDate = Date()
let calendar = Calendar.current
let currentYear = calendar.component(.year, from: currentDate)
var years = (2000...currentYear).reversed().map { String($0) }


func ConvertDateFormater(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

    guard let date = dateFormatter.date(from: date) else {
//            assert(false, "no date from string")
        return ""
    }

    dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"//"yyyy MMM EEEE HH:mm"
    dateFormatter.timeZone = TimeZone.current//NSTimeZone(name: "UTC") as TimeZone?
    dateFormatter.amSymbol = "am"
    dateFormatter.pmSymbol = "pm"

    let timeStamp = dateFormatter.string(from: date)

    return timeStamp
}

func ConvertDateFormaterRideDetail(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

    guard let date = dateFormatter.date(from: date) else {
//            assert(false, "no date from string")
        return ""
    }

    dateFormatter.dateFormat = "dd/MM/yyyy, h:mm a"//"yyyy MMM EEEE HH:mm"
    dateFormatter.timeZone = TimeZone.current//NSTimeZone(name: "UTC") as TimeZone?
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"

    let timeStamp = dateFormatter.string(from: date)

    return timeStamp
}

func ConvertDateToLocalTimeZone(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.timeZone = TimeZone(identifier: "UTC")
    let strDate = dateFormatter.date(from: date)
    return strDate ?? Date()
    let localDateFormatter = DateFormatter()
    localDateFormatter.timeZone = .current
    localDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    if let finalStrDate = strDate {
        let utcDateFormatter = DateFormatter()
        let convertUTCToLocalStr = localDateFormatter.string(from: finalStrDate)
        utcDateFormatter.timeZone = TimeZone(identifier: "UTC")
        utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let convertLocalStrToUTCTimezone = utcDateFormatter.date(from: convertUTCToLocalStr) else {
            return Date()
        }
        return convertLocalStrToUTCTimezone
    } else {
        return Date()
    }
}


func getTimeFromUTCDate( date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        guard let date = dateFormatter.date(from: date) else {
    //            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "hh:mm a"//"yyyy MMM EEEE HH:mm"
        dateFormatter.timeZone = TimeZone.current//NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"

        let timeStamp = dateFormatter.string(from: date)

        return timeStamp
}

func getDateFromUTCDate( date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?

        guard let date = dateFormatter.date(from: date) else {
    //            assert(false, "no date from string")
            return ""
        }

        dateFormatter.dateFormat = "MMM dd, yyyy"//"yyyy MMM EEEE HH:mm"
        dateFormatter.timeZone = TimeZone.current//NSTimeZone(name: "UTC") as TimeZone?

        let timeStamp = dateFormatter.string(from: date)

        return timeStamp


}
