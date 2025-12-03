//
//  Date+Extensions.swift
//  My iOS library
//
//  Essential Date extensions for productivity
//

import Foundation

extension Date {

    // MARK: - Time Ago

    /// Returns a user-friendly time ago string (e.g., "2 hours ago", "Yesterday")
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// Returns a short time ago string (e.g., "2h", "1d")
    var timeAgoShort: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    /// Returns time ago with custom formatting
    func timeAgo(style: RelativeDateTimeFormatter.UnitsStyle) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = style
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    // MARK: - Comparisons

    /// Checks if date is today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }

    /// Checks if date is yesterday
    var isYesterday: Bool {
        return Calendar.current.isDateInYesterday(self)
    }

    /// Checks if date is tomorrow
    var isTomorrow: Bool {
        return Calendar.current.isDateInTomorrow(self)
    }

    /// Checks if date is in the past
    var isPast: Bool {
        return self < Date()
    }

    /// Checks if date is in the future
    var isFuture: Bool {
        return self > Date()
    }

    /// Checks if date is in the current week
    var isThisWeek: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .weekOfYear)
    }

    /// Checks if date is in the current month
    var isThisMonth: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .month)
    }

    /// Checks if date is in the current year
    var isThisYear: Bool {
        return Calendar.current.isDate(self, equalTo: Date(), toGranularity: .year)
    }

    /// Checks if date is on weekend
    var isWeekend: Bool {
        return Calendar.current.isDateInWeekend(self)
    }

    /// Checks if date is on weekday
    var isWeekday: Bool {
        return !isWeekend
    }

    // MARK: - Components

    /// Year component
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    /// Month component
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    /// Day component
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    /// Hour component
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    /// Minute component
    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    /// Second component
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }

    /// Weekday component (1 = Sunday, 7 = Saturday)
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }

    /// Week of year component
    var weekOfYear: Int {
        return Calendar.current.component(.weekOfYear, from: self)
    }

    /// Week of month component
    var weekOfMonth: Int {
        return Calendar.current.component(.weekOfMonth, from: self)
    }

    /// Quarter component
    var quarter: Int {
        let month = Calendar.current.component(.month, from: self)
        return Int(ceil(Double(month) / 3.0))
    }

    // MARK: - Date Manipulation

    /// Adds days to the date
    func adding(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }

    /// Adds weeks to the date
    func adding(weeks: Int) -> Date {
        return Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self)!
    }

    /// Adds months to the date
    func adding(months: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: months, to: self)!
    }

    /// Adds years to the date
    func adding(years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: years, to: self)!
    }

    /// Adds hours to the date
    func adding(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }

    /// Adds minutes to the date
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }

    /// Adds seconds to the date
    func adding(seconds: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: seconds, to: self)!
    }

    /// Adds component to the date
    func adding(_ component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    // MARK: - Start/End of Period

    /// Beginning of day
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    /// End of day
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }

    /// Beginning of week
    var startOfWeek: Date {
        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return Calendar.current.date(from: components)!
    }

    /// End of week
    var endOfWeek: Date {
        var components = DateComponents()
        components.weekOfYear = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfWeek)!
    }

    /// Beginning of month
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components)!
    }

    /// End of month
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }

    /// Beginning of year
    var startOfYear: Date {
        let components = Calendar.current.dateComponents([.year], from: self)
        return Calendar.current.date(from: components)!
    }

    /// End of year
    var endOfYear: Date {
        var components = DateComponents()
        components.year = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfYear)!
    }

    // MARK: - Formatting

    /// Converts date to string with format
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

    /// Converts date to string with style
    func toString(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style = .none) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        return formatter.string(from: self)
    }

    /// Returns ISO8601 formatted string
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }

    /// Common date format strings
    struct Format {
        static let iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
        static let dateOnly = "yyyy-MM-dd"
        static let timeOnly = "HH:mm:ss"
        static let dateTime = "yyyy-MM-dd HH:mm:ss"
        static let shortDate = "MM/dd/yy"
        static let longDate = "MMMM d, yyyy"
        static let monthYear = "MMMM yyyy"
        static let dayMonth = "d MMMM"
        static let weekday = "EEEE"
        static let shortWeekday = "EEE"
        static let time12Hour = "h:mm a"
        static let time24Hour = "HH:mm"
    }

    // MARK: - Time Intervals

    /// Time interval since now
    var timeIntervalSinceNow: TimeInterval {
        return -timeIntervalSinceNow
    }

    /// Time interval until now
    var timeIntervalUntilNow: TimeInterval {
        return timeIntervalSinceNow
    }

    /// Days between two dates
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }

    /// Hours between two dates
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }

    /// Minutes between two dates
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }

    /// Seconds between two dates
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    // MARK: - Convenience Initializers

    /// Creates a date from components
    init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second

        guard let date = Calendar.current.date(from: components) else { return nil }
        self = date
    }

    /// Creates a date from a string with format
    init?(string: String, format: String = "yyyy-MM-dd") {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = formatter.date(from: string) else { return nil }
        self = date
    }

    // MARK: - Static Helpers

    /// Returns dates between two dates
    static func dates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates: [Date] = []
        var currentDate = startDate

        while currentDate <= endDate {
            dates.append(currentDate)
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return dates
    }

    /// Random date between two dates
    static func random(between startDate: Date, and endDate: Date) -> Date {
        let timeInterval = endDate.timeIntervalSince(startDate)
        let randomTimeInterval = TimeInterval.random(in: 0...timeInterval)
        return startDate.addingTimeInterval(randomTimeInterval)
    }
}