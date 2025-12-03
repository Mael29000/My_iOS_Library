//
//  String+Extensions.swift
//  My iOS library
//
//  Essential String extensions for productivity
//

import Foundation
import UIKit

extension String {

    // MARK: - Validation

    /// Validates if the string is a valid email
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    /// Validates if the string is a valid URL
    var isValidURL: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil && url.host != nil
    }

    /// Validates if the string is a valid phone number
    var isValidPhoneNumber: Bool {
        let phoneRegex = "^[+]?[0-9]{1,3}?[-.\\s]?\\(?[0-9]{1,3}\\)?[-.\\s]?[0-9]{1,4}[-.\\s]?[0-9]{1,4}[-.\\s]?[0-9]{1,9}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phonePredicate.evaluate(with: self)
    }

    /// Validates if the string contains only numbers
    var isNumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }

    /// Validates if the string contains only letters
    var isAlphabetic: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }

    /// Validates if the string contains only alphanumeric characters
    var isAlphanumeric: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil
    }

    // MARK: - Localization

    /// Returns localized string
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }

    /// Returns localized string with format
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: self.localized(), arguments: arguments)
    }

    // MARK: - Trimming

    /// Returns string with whitespace and newlines trimmed
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Removes all whitespace from string
    var withoutWhitespace: String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }

    // MARK: - Subscript

    /// Access character at index
    subscript(i: Int) -> Character? {
        guard i >= 0 && i < count else { return nil }
        return self[index(startIndex, offsetBy: i)]
    }

    /// Access substring with range
    subscript(range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start..<end])
    }

    /// Access substring with closed range
    subscript(range: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start...end])
    }

    // MARK: - Case Conversion

    /// Converts string to camelCase
    var camelCased: String {
        let words = components(separatedBy: CharacterSet.alphanumerics.inverted)
        let first = words.first?.lowercased() ?? ""
        let rest = words.dropFirst().map { $0.capitalized }
        return ([first] + rest).joined()
    }

    /// Converts string to snake_case
    var snakeCased: String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: count)
        let snakeCase = regex?.stringByReplacingMatches(
            in: self,
            options: [],
            range: range,
            withTemplate: "$1_$2"
        )
        return snakeCase?.lowercased() ?? self.lowercased()
    }

    /// Converts string to kebab-case
    var kebabCased: String {
        return snakeCased.replacingOccurrences(of: "_", with: "-")
    }

    /// Converts string to Title Case
    var titleCased: String {
        return components(separatedBy: " ")
            .map { $0.capitalized }
            .joined(separator: " ")
    }

    // MARK: - Encoding/Decoding

    /// Base64 encodes the string
    var base64Encoded: String? {
        return data(using: .utf8)?.base64EncodedString()
    }

    /// Base64 decodes the string
    var base64Decoded: String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    /// URL encodes the string
    var urlEncoded: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }

    /// URL decodes the string
    var urlDecoded: String? {
        return removingPercentEncoding
    }

    // MARK: - HTML

    /// Removes HTML tags from string
    var withoutHtmlTags: String {
        return replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

    /// Converts HTML to attributed string
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        return try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }

    // MARK: - Helpers

    /// Returns the string reversed
    var reversed: String {
        return String(self.reversed())
    }

    /// Checks if string contains substring (case insensitive)
    func containsIgnoringCase(_ substring: String) -> Bool {
        return lowercased().contains(substring.lowercased())
    }

    /// Returns the number of words in the string
    var wordCount: Int {
        let words = components(separatedBy: .whitespacesAndNewlines)
        return words.filter { !$0.isEmpty }.count
    }

    /// Returns array of words
    var words: [String] {
        return components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
    }

    /// Returns array of lines
    var lines: [String] {
        return components(separatedBy: .newlines)
    }

    /// Truncates string to specified length
    func truncated(to length: Int, trailing: String = "...") -> String {
        guard count > length else { return self }
        return String(prefix(length)) + trailing
    }

    /// Pads string to specified length
    func padded(to length: Int, with character: Character = " ", alignment: Alignment = .left) -> String {
        guard count < length else { return self }
        let padding = String(repeating: character, count: length - count)

        switch alignment {
        case .left:
            return self + padding
        case .right:
            return padding + self
        case .center:
            let half = padding.count / 2
            let leftPadding = String(padding.prefix(half))
            let rightPadding = String(padding.suffix(padding.count - half))
            return leftPadding + self + rightPadding
        }
    }

    enum Alignment {
        case left, right, center
    }

    // MARK: - Regex

    /// Returns all matches for a regex pattern
    func matches(for pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch {
            return []
        }
    }

    /// Checks if string matches a regex pattern
    func matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression) != nil
    }

    /// Replaces regex matches
    func replacingMatches(of pattern: String, with replacement: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            return regex.stringByReplacingMatches(
                in: self,
                range: NSRange(self.startIndex..., in: self),
                withTemplate: replacement
            )
        } catch {
            return self
        }
    }

    // MARK: - Date Conversion

    /// Converts string to Date with format
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }

    // MARK: - Numeric Conversion

    /// Safely converts to Int
    var toInt: Int? {
        return Int(self)
    }

    /// Safely converts to Double
    var toDouble: Double? {
        return Double(self)
    }

    /// Safely converts to Float
    var toFloat: Float? {
        return Float(self)
    }

    /// Safely converts to Bool
    var toBool: Bool? {
        switch self.lowercased() {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }

    // MARK: - File Path

    /// Returns the file name without extension
    var fileNameWithoutExtension: String {
        return (self as NSString).deletingPathExtension
    }

    /// Returns the file extension
    var fileExtension: String {
        return (self as NSString).pathExtension
    }

    /// Returns the last path component
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }

    /// Returns the path without last component
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
}