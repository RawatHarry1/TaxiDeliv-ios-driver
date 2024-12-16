//
//  Date+Extension.swift
//  VenusDriver
//
//  Created by Amit on 24/07/23.
//

import Foundation

extension Date {

    var elapsedTime: String {
        var component: Set<Calendar.Component> = [.year]
        var interval = Calendar.current.dateComponents(component, from: self, to: Date()).year ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + "year":
                "\(interval) " + "years"
        }
        component = [.month]
        interval = Calendar.current.dateComponents(component, from: self, to: Date()).month ?? 0
        if interval > 0 {
            return interval == 1 ? "\(interval) " + "month":
                "\(interval) " + "months"
        }
        return ""
    }

//    var elapsedTimeForNotification: String {
//        var component: Set<Calendar.Component> = [.year]
//        var interval = Calendar.current.dateComponents(component, from: self, to: Date()).year ?? 0
//        if interval > 0 {
//            return interval == 1 ? "\(interval) " + TDStringConstants.yearAgo.value :
//                "\(interval) " + TDStringConstants.yearAgo.value
//        }
//        component = [.month]
//        interval = Calendar.current.dateComponents(component, from: self, to: Date()).month ?? 0
//        if interval > 0 {
//            return interval == 1 ? "\(interval) " + TDStringConstants.monthAgo.value:
//                "\(interval) " + TDStringConstants.monthAgo.value
//        }
//        component = [.day]
//        interval = Calendar.current.dateComponents(component, from: self, to: Date()).day ?? 0
//        if interval > 0 {
//            return interval == 1 ? "\(interval) " + TDStringConstants.dayAgo.value :
//                "\(interval) " + TDStringConstants.dayAgo.value
//        }
//        component = [.hour]
//        interval = Calendar.current.dateComponents(component, from: self, to: Date()).hour ?? 0
//        if interval > 0 {
//            return interval == 1 ? "\(interval) " + TDStringConstants.hourAgo.value :
//                "\(interval) " + TDStringConstants.hourAgo.value
//        }
//        component = [.minute]
//        interval = Calendar.current.dateComponents(component, from: self, to: Date()).minute ?? 0
//        if interval > 0 {
//            return interval == 1 ? "\(interval) " + TDStringConstants.minAgo.value :
//                "\(interval) " + TDStringConstants.minAgo.value
//        }
//        component = [.second]
//        interval = Calendar.current.dateComponents(component, from: self, to: Date()).second ?? 0
//        return TDStringConstants.now.value
//    }

    var isToday:Bool {
        return Calendar.current.isDateInToday(self)
    }
    var isYesterday:Bool {
        return Calendar.current.isDateInYesterday(self)
    }
    var isTomorrow:Bool {
        return Calendar.current.isDateInTomorrow(self)
    }
    var isWeekend:Bool {
        return Calendar.current.isDateInWeekend(self)
    }
    var year:Int {
        return (Calendar.current as NSCalendar).components(.year, from: self).year!
    }
    var month:Int {
        return (Calendar.current as NSCalendar).components(.month, from: self).month!
    }
    var weekOfYear:Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: self).weekOfYear!
    }
    var weekday:Int {
        return (Calendar.current as NSCalendar).components(.weekday, from: self).weekday!
    }
    var weekdayOrdinal:Int {
        return (Calendar.current as NSCalendar).components(.weekdayOrdinal, from: self).weekdayOrdinal!
    }
    var weekOfMonth:Int {
        return (Calendar.current as NSCalendar).components(.weekOfMonth, from: self).weekOfMonth!
    }

    var timeStamp: Int64 {
        return Int64(self.timeIntervalSince1970)
    }

    var timeIntervalInMiliSeconds: Int {
        return Int(self.timeIntervalSince1970*1000)
    }

    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    func equalToDate(_ dateToCompare: Date) -> Bool {
        // Declare Variables
        var isEqualTo = false

        // Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        // Return Result
        return isEqualTo
    }

    func compareDate(from date: Date) -> Bool {
        let order = NSCalendar.current.compare(self, to: date, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }

    func addDays(_ daysToAdd: Int) -> Date {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays)

        // Return Result
        return dateWithDaysAdded
    }

    func addHours(_ hoursToAdd: Int) -> Date {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours)

        // Return Result
        return dateWithHoursAdded
    }

    func addYear(_ yearsToAdd: Int) -> Date? {
        var dateComponent = DateComponents()
        dateComponent.year = yearsToAdd
        return Calendar.current.date(byAdding: dateComponent, to: self)
    }

    var nextQuarter: Date {
        let minutes = Calendar.current.component(.minute, from: self)
        var roundedMinute = minutes
        if minutes < 15 {
            roundedMinute = 15
        } else if minutes < 30 {
            roundedMinute = 30
        } else if minutes < 45 {
            roundedMinute = 45
        } else {
            roundedMinute = 60
        }
        return Calendar.current.date(byAdding: .minute, value: roundedMinute - minutes, to: self)!
    }

    func timeString(dateFormat:String = DateFormatter.hmma, timeZone:TimeZone = TimeZone.current) -> String {
        let frmtr = DateFormatter()
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        frmtr.locale = Locale(identifier: "en_US_POSIX")
        frmtr.calendar = NSCalendar.current
        return frmtr.string(from: self)
    }

    func toDateTimeString(dateFormat:String = DateFormatter.yyyyMMddHHmmss, timeZone:TimeZone = TimeZone.current) -> String {
        let frmtr = DateFormatter()
        frmtr.dateFormat = dateFormat
        frmtr.timeZone = timeZone
        frmtr.calendar = NSCalendar.current
        return frmtr.string(from: self)
    }

    func setMinimumMaximumDate(maxYear: Int,
                               maxMonth: Int,
                               maxDays: Int,
                               minYear: Int,
                               minMonth: Int,
                               minDays: Int) -> (Date, Date) {
        let calendar = Calendar(identifier: .gregorian)
        let currentDate = Date().startOfDay
        var components = DateComponents()
        components.calendar = calendar
        components.year = maxYear
        components.month = maxMonth
        components.day = maxDays
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        components.year = -minYear
        components.month = -minMonth
        components.day = -minDays

        let minDate = calendar.date(byAdding: components, to: currentDate)!
        return (minDate, maxDate)
    }
}

// The date components available to be retrieved or modifed
public enum DateComponentType {
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}

extension Calendar {
    static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {

    internal static func componentFlags() -> Set<Calendar.Component> { return [.year,.month,.day,.weekOfYear,.hour,.minute,.second, .weekday, .weekdayOrdinal,.weekOfYear]
    }

    var components: DateComponents {
        return Calendar.gregorian.dateComponents(Date.componentFlags(), from: self)
    }

    var numberOfDaysInMonth:Int {
        return Calendar.gregorian.range(of: .day, in: .month, for: self)?.count ?? 0
    }

    var numberOfWeeksInMonth: Int {
        return Calendar.gregorian.range(of: .weekOfYear, in: .month, for: self)?.count ?? 0
    }

    var getWeekDayOfDayOfMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dowFDOM = dateFormatter.string(from: self)
        return dowFDOM
    }

    static func + (lhs: inout Date,rhs: Date) {}

    var monthStart: Date {
        return Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.year,.month], from: self))!
    }

    var monthEnd: Date {
        return monthStart.addingTimeInterval(TimeInterval((self.numberOfDaysInMonth - 1)*24*60*60))
    }

    var weekStart: Date {
        return Calendar.gregorian.date(from: Calendar.gregorian.dateComponents([.yearForWeekOfYear,.weekOfYear], from: self))!
    }

    var weekEnd: Date {
        return weekStart.adjustedDate(.day, offset: 6)
    }

    func isBetweenDates(beginDate: Date, endDate: Date) -> Bool {
        if self.compare(beginDate) == .orderedAscending {
            return false
        }

        if self.compare(endDate) == .orderedDescending {
            return false
        }

        return true
    }

    func adjustedDate(_ component:DateComponentType, offset:Int) -> Date {
        var dateComp = DateComponents()
        switch component {
        case .second:
            dateComp.second = offset
        case .minute:
            dateComp.minute = offset
        case .hour:
            dateComp.hour = offset
        case .day:
            dateComp.day = offset
        case .weekday:
            dateComp.weekday = offset
        case .nthWeekday:
            dateComp.weekdayOrdinal = offset
        case .week:
            dateComp.weekOfYear = offset
        case .month:
            dateComp.month = offset
        case .year:
            dateComp.year = offset
        }
        return Calendar.gregorian.date(byAdding: dateComp, to: self)!
    }

    func component(_ component:DateComponentType) -> Int {
        let components = self.components
        switch component {
        case .second:
            return components.second ?? 0
        case .minute:
            return components.minute ?? 0
        case .hour:
            return components.hour ?? 0
        case .day:
            return components.day ?? 0
        case .weekday:
            return components.weekday ?? 0
        case .nthWeekday:
            return components.weekdayOrdinal ?? 0
        case .week:
            return components.weekOfYear ?? 0
        case .month:
            return components.month ?? 0
        case .year:
            return components.year ?? 0
        }
    }

    var day:Int {
        return (Calendar.current as NSCalendar).components(.day, from: self).day!
    }
    var hour:Int {
        return (Calendar.current as NSCalendar).components(.hour, from: self).hour!
    }

    var minute:Int {
        return (Calendar.current as NSCalendar).components(.minute, from: self).minute!
    }
    var second:Int {
        return (Calendar.current as NSCalendar).components(.second, from: self).second!
    }
    var numberOfWeeks:Int {
        let weekRange = (Calendar.current as NSCalendar).range(of: .weekOfYear, in: .month, for: Date())
        return weekRange.length
    }
    var unixTimestamp:Double {
        return self.timeIntervalSince1970
    }

    func yearsFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    func monthsFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    func weeksFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    func weekdayFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekday, from: date, to: self, options: []).weekday!
    }
    func weekdayOrdinalFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekdayOrdinal, from: date, to: self, options: []).weekdayOrdinal!
    }
    func weekOfMonthFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfMonth, from: date, to: self, options: []).weekOfMonth!
    }
    func daysFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    func hoursFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    func minutesFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    func secondsFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }

    func toLocalTime() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.string(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        return dateFormatter.date(from: dt) ?? Date()
    }

    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        // Declare Variables
        var isGreater = false

        // Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }

        // Return Result
        return isGreater
    }

    func isLessThanDate(_ dateToCompare: Date) -> Bool {
        // Declare Variables
        var isLess = false

        // Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        // Return Result
        return isLess
    }

    func calculateAge(date: Date) -> (year:Int, month: Int, day: Int) {
        //        let df = DateFormatter()
        //        df.dateFormat = format
        //        let date = df.date(from: dob)
        //        guard let val = date else {
        //            return (0, 0, 0)
        //        }
        var years = 0
        var months = 0
        var days = 0

        let cal = Calendar.current
        years = cal.component(.year, from: Date()) -  cal.component(.year, from: date)

        let currMonth = cal.component(.month, from: Date())
        let birthMonth = cal.component(.month, from: date)

        // get difference between current month and birthMonth
        months = currMonth - birthMonth
        // if month difference is in negative then reduce years by one and calculate the number of months.
        if months < 0 {
            years -= 1
            months = 12 - birthMonth + currMonth
            if cal.component(.day, from: Date()) < cal.component(.day, from: date) {
                months -= 1
            }
        } else if months == 0 && cal.component(.day, from: Date()) < cal.component(.day, from: date) {
            years -= 1
            months = 11
        }

        // Calculate the days
        if cal.component(.day, from: Date()) > cal.component(.day, from: date) {
            days = cal.component(.day, from: Date()) - cal.component(.day, from: date)
        } else if cal.component(.day, from: Date()) < cal.component(.day, from: date) {
            let today = cal.component(.day, from: Date())
            let date = cal.date(byAdding: .month, value: -1, to: Date())

            days = self.startOfDay.numberOfDaysInMonth - cal.component(.day, from: date!) + today
        } else {
            days = 0
            if months == 12 {
                years += 1
                months = 0
            }
        }
        return (years, months, days)
    }

    func calculateExp(date: Date) -> (year:Int, month: Int) {
        var years = 0
        var months = 0

        let cal = Calendar.current
        years = cal.component(.year, from: Date()) -  cal.component(.year, from: date)

        let currMonth = cal.component(.month, from: Date())
        let birthMonth = cal.component(.month, from: date)

        // get difference between current month and birthMonth
        months = currMonth - birthMonth
        // if month difference is in negative then reduce years by one and calculate the number of months.
        if months < 0 {
            years -= 1
            months = 12 - birthMonth + currMonth
            if cal.component(.day, from: Date()) < cal.component(.day, from: date) {
                months -= 1
            }
        } else if months == 0 && cal.component(.day, from: Date()) < cal.component(.day, from: date) {
            years -= 1
            months = 11
        }

        return (years, months)
    }

    func getMonthYearOnly() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormatter.mmmmyyyy
        return dateFormatter.string(from: self as Date)
    }
}

extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.gregorian.startOfDay(for: self)
    }

    var endOfDay : Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
    }

    var isoString: String {
        let iso8601DateFormatter = ISO8601DateFormatter()
        iso8601DateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let string = iso8601DateFormatter.string(from: self)
        return string
    }

    var convertedDate:Date {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: self)
        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        dateFormatter.dateFormat = dateFormat as String
        let sourceDate = dateFormatter.date(from: formattedDate as String)
        return sourceDate!
    }
}

extension DateFormatter {
    static let hmma       = "hh:mm a"
    static let hmm        = "h:mm"
    static let ddMMMMyyyy = "dd MMMM yyyy"
    static let yyyyMMdd   = "yyyy-MM-dd"
    static let ddMMyyyy   = "dd/MM/yyyy"
    static let yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    static let ddMMMyyyyhhmma = "dd MMMM yyyy hh:mm a"
    static let hhmm         = "hh:mm"
    static let ddMMMyyyy    = "dd MMM yyyy"
    static let MMMddyyyy    = "MMM dd, yyyy"
    static let dMMMyyyy     = "d MMM, yyyy"
    static let dMMMM        = "d MMMM"
    static let mmss         = "mm:ss"
    static let mmmm         = "MMMM"
    static let tZFormat     = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    static let isoFormat    = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    static let hmm24Hour    = "H:mm"
    static let ddMMMyyyyHHmm    = "dd MMM yyyy · HH:mm"
    static let ddMMM    = "dd MMM"
    static let mmm        = "MMM"
    static let yyyy        = "yyyy"
    static let mmmmyyyy        = "MMMM yyyy"
    static let mm        = "MM"
    static let updatedisoFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
}
