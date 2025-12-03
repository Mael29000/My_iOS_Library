//
//  Validator.swift
//  My iOS library
//
//  Comprehensive validation utility for input validation
//

import Foundation

/// Main validation utility
enum Validator {

    // MARK: - Email Validation

    /// Validates email address
    static func validate(email: String, allowEmpty: Bool = false) -> ValidationResult {
        if email.isEmpty {
            return allowEmpty ? .valid : .invalid("Email cannot be empty")
        }

        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        if !emailPredicate.evaluate(with: email) {
            return .invalid("Invalid email format")
        }

        // Additional checks
        if email.contains("..") {
            return .invalid("Email cannot contain consecutive dots")
        }

        if email.hasPrefix(".") || email.hasSuffix(".") {
            return .invalid("Email cannot start or end with a dot")
        }

        let parts = email.split(separator: "@")
        if parts.count != 2 {
            return .invalid("Email must contain exactly one @ symbol")
        }

        return .valid
    }

    // MARK: - Password Validation

    /// Validates password with configurable rules
    static func validate(
        password: String,
        minLength: Int = 8,
        requireUppercase: Bool = true,
        requireLowercase: Bool = true,
        requireDigit: Bool = true,
        requireSpecialCharacter: Bool = false,
        allowedSpecialCharacters: String = "!@#$%^&*()_+-=[]{}|;:'\",.<>?/"
    ) -> ValidationResult {
        if password.isEmpty {
            return .invalid("Password cannot be empty")
        }

        if password.count < minLength {
            return .invalid("Password must be at least \(minLength) characters long")
        }

        if requireUppercase && !password.contains(where: { $0.isUppercase }) {
            return .invalid("Password must contain at least one uppercase letter")
        }

        if requireLowercase && !password.contains(where: { $0.isLowercase }) {
            return .invalid("Password must contain at least one lowercase letter")
        }

        if requireDigit && !password.contains(where: { $0.isNumber }) {
            return .invalid("Password must contain at least one digit")
        }

        if requireSpecialCharacter {
            let specialCharacterSet = CharacterSet(charactersIn: allowedSpecialCharacters)
            if password.rangeOfCharacter(from: specialCharacterSet) == nil {
                return .invalid("Password must contain at least one special character")
            }
        }

        return .valid
    }

    /// Calculates password strength
    static func passwordStrength(_ password: String) -> PasswordStrength {
        var strength = 0

        // Length
        if password.count >= 8 { strength += 1 }
        if password.count >= 12 { strength += 1 }
        if password.count >= 16 { strength += 1 }

        // Character variety
        if password.contains(where: { $0.isUppercase }) { strength += 1 }
        if password.contains(where: { $0.isLowercase }) { strength += 1 }
        if password.contains(where: { $0.isNumber }) { strength += 1 }

        let specialCharacters = "!@#$%^&*()_+-=[]{}|;:'\",.<>?/"
        if password.contains(where: { specialCharacters.contains($0) }) { strength += 1 }

        // No common patterns
        let commonPatterns = ["123", "abc", "password", "qwerty", "admin"]
        if !commonPatterns.contains(where: { password.lowercased().contains($0) }) {
            strength += 1
        }

        switch strength {
        case 0...2:
            return .weak
        case 3...5:
            return .medium
        case 6...7:
            return .strong
        default:
            return .veryStrong
        }
    }

    // MARK: - Phone Number Validation

    /// Validates phone number
    static func validate(
        phoneNumber: String,
        country: String = "US",
        allowEmpty: Bool = false
    ) -> ValidationResult {
        if phoneNumber.isEmpty {
            return allowEmpty ? .valid : .invalid("Phone number cannot be empty")
        }

        // Remove common formatting characters
        let cleaned = phoneNumber.replacingOccurrences(of: "[^0-9+]", with: "", options: .regularExpression)

        switch country.uppercased() {
        case "US":
            return validateUSPhoneNumber(cleaned)
        case "UK", "GB":
            return validateUKPhoneNumber(cleaned)
        case "FR":
            return validateFRPhoneNumber(cleaned)
        default:
            // Generic international format
            return validateInternationalPhoneNumber(cleaned)
        }
    }

    private static func validateUSPhoneNumber(_ phone: String) -> ValidationResult {
        // US phone: +1 XXX XXX XXXX or XXX XXX XXXX
        let patterns = [
            "^\\+1[0-9]{10}$",  // +1XXXXXXXXXX
            "^1[0-9]{10}$",     // 1XXXXXXXXXX
            "^[0-9]{10}$"       // XXXXXXXXXX
        ]

        for pattern in patterns {
            if phone.range(of: pattern, options: .regularExpression) != nil {
                return .valid
            }
        }

        return .invalid("Invalid US phone number format")
    }

    private static func validateUKPhoneNumber(_ phone: String) -> ValidationResult {
        // UK phone: +44 XXXX XXXXXX or 0XXXX XXXXXX
        let patterns = [
            "^\\+44[0-9]{10}$",  // +44XXXXXXXXXX
            "^44[0-9]{10}$",     // 44XXXXXXXXXX
            "^0[0-9]{10}$"       // 0XXXXXXXXXX
        ]

        for pattern in patterns {
            if phone.range(of: pattern, options: .regularExpression) != nil {
                return .valid
            }
        }

        return .invalid("Invalid UK phone number format")
    }

    private static func validateFRPhoneNumber(_ phone: String) -> ValidationResult {
        // French phone: +33 X XX XX XX XX or 0X XX XX XX XX
        let patterns = [
            "^\\+33[0-9]{9}$",   // +33XXXXXXXXX
            "^33[0-9]{9}$",      // 33XXXXXXXXX
            "^0[0-9]{9}$"        // 0XXXXXXXXX
        ]

        for pattern in patterns {
            if phone.range(of: pattern, options: .regularExpression) != nil {
                return .valid
            }
        }

        return .invalid("Invalid French phone number format")
    }

    private static func validateInternationalPhoneNumber(_ phone: String) -> ValidationResult {
        // International: +XX... (between 7 and 15 digits total)
        let pattern = "^\\+[0-9]{7,15}$"
        if phone.range(of: pattern, options: .regularExpression) != nil {
            return .valid
        }
        return .invalid("Invalid international phone number format")
    }

    // MARK: - URL Validation

    /// Validates URL
    static func validate(url urlString: String, requireHTTPS: Bool = false) -> ValidationResult {
        if urlString.isEmpty {
            return .invalid("URL cannot be empty")
        }

        guard let url = URL(string: urlString) else {
            return .invalid("Invalid URL format")
        }

        guard let scheme = url.scheme?.lowercased() else {
            return .invalid("URL must have a scheme (http:// or https://)")
        }

        if requireHTTPS && scheme != "https" {
            return .invalid("URL must use HTTPS")
        }

        if !["http", "https"].contains(scheme) {
            return .invalid("URL scheme must be HTTP or HTTPS")
        }

        guard let host = url.host, !host.isEmpty else {
            return .invalid("URL must have a valid host")
        }

        return .valid
    }

    // MARK: - Credit Card Validation

    /// Validates credit card number using Luhn algorithm
    static func validate(creditCard: String) -> ValidationResult {
        let cleaned = creditCard.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)

        if cleaned.isEmpty {
            return .invalid("Credit card number cannot be empty")
        }

        if cleaned.count < 13 || cleaned.count > 19 {
            return .invalid("Credit card number must be between 13 and 19 digits")
        }

        // Luhn algorithm
        var sum = 0
        let reversedCharacters = cleaned.reversed().map { String($0) }
        for (index, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else {
                return .invalid("Credit card number must contain only digits")
            }

            if index % 2 == 1 {
                switch digit {
                case 0...4:
                    sum += digit * 2
                default:
                    sum += digit * 2 - 9
                }
            } else {
                sum += digit
            }
        }

        if sum % 10 != 0 {
            return .invalid("Invalid credit card number")
        }

        return .valid
    }

    /// Detects credit card type
    static func creditCardType(from number: String) -> CreditCardType {
        let cleaned = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)

        if cleaned.hasPrefix("4") {
            return .visa
        } else if cleaned.hasPrefix("5") && ["51", "52", "53", "54", "55"].contains(where: { cleaned.hasPrefix($0) }) {
            return .mastercard
        } else if ["34", "37"].contains(where: { cleaned.hasPrefix($0) }) {
            return .amex
        } else if cleaned.hasPrefix("6011") || cleaned.hasPrefix("65") {
            return .discover
        } else {
            return .unknown
        }
    }

    // MARK: - Username Validation

    /// Validates username
    static func validate(
        username: String,
        minLength: Int = 3,
        maxLength: Int = 20,
        allowedCharacters: CharacterSet = .alphanumerics.union(CharacterSet(charactersIn: "_-"))
    ) -> ValidationResult {
        if username.isEmpty {
            return .invalid("Username cannot be empty")
        }

        if username.count < minLength {
            return .invalid("Username must be at least \(minLength) characters long")
        }

        if username.count > maxLength {
            return .invalid("Username cannot exceed \(maxLength) characters")
        }

        if username.rangeOfCharacter(from: allowedCharacters.inverted) != nil {
            return .invalid("Username contains invalid characters")
        }

        if username.hasPrefix("_") || username.hasPrefix("-") ||
           username.hasSuffix("_") || username.hasSuffix("-") {
            return .invalid("Username cannot start or end with special characters")
        }

        return .valid
    }

    // MARK: - Other Validations

    /// Validates age
    static func validate(age: Int, minimum: Int = 0, maximum: Int = 150) -> ValidationResult {
        if age < minimum {
            return .invalid("Age must be at least \(minimum)")
        }

        if age > maximum {
            return .invalid("Age cannot exceed \(maximum)")
        }

        return .valid
    }

    /// Validates date
    static func validate(date: Date, notBefore: Date? = nil, notAfter: Date? = nil) -> ValidationResult {
        if let notBefore = notBefore, date < notBefore {
            return .invalid("Date cannot be before \(notBefore)")
        }

        if let notAfter = notAfter, date > notAfter {
            return .invalid("Date cannot be after \(notAfter)")
        }

        return .valid
    }

    /// Validates postal/zip code
    static func validate(postalCode: String, country: String = "US") -> ValidationResult {
        if postalCode.isEmpty {
            return .invalid("Postal code cannot be empty")
        }

        let patterns: [String: String] = [
            "US": "^[0-9]{5}(-[0-9]{4})?$",       // XXXXX or XXXXX-XXXX
            "CA": "^[A-Za-z][0-9][A-Za-z] [0-9][A-Za-z][0-9]$", // X#X #X#
            "UK": "^[A-Z]{1,2}[0-9][0-9A-Z]? [0-9][A-Z]{2}$",  // XX## #XX
            "FR": "^[0-9]{5}$",                    // #####
            "DE": "^[0-9]{5}$",                    // #####
            "JP": "^[0-9]{3}-[0-9]{4}$"           // ###-####
        ]

        guard let pattern = patterns[country.uppercased()] else {
            // Generic pattern for unknown countries
            return postalCode.count >= 3 && postalCode.count <= 10 ? .valid : .invalid("Invalid postal code length")
        }

        if postalCode.range(of: pattern, options: .regularExpression) != nil {
            return .valid
        }

        return .invalid("Invalid postal code format for \(country)")
    }
}

// MARK: - Supporting Types

/// Validation result
public enum ValidationResult {
    case valid
    case invalid(String)

    public var isValid: Bool {
        switch self {
        case .valid:
            return true
        case .invalid:
            return false
        }
    }

    public var errorMessage: String? {
        switch self {
        case .valid:
            return nil
        case .invalid(let message):
            return message
        }
    }
}

/// Password strength levels
enum PasswordStrength: String, CaseIterable {
    case weak = "Weak"
    case medium = "Medium"
    case strong = "Strong"
    case veryStrong = "Very Strong"

    var color: String {
        switch self {
        case .weak:
            return "#FF0000"      // Red
        case .medium:
            return "#FFA500"      // Orange
        case .strong:
            return "#32CD32"      // Lime Green
        case .veryStrong:
            return "#228B22"      // Forest Green
        }
    }

    var progress: Double {
        switch self {
        case .weak:
            return 0.25
        case .medium:
            return 0.5
        case .strong:
            return 0.75
        case .veryStrong:
            return 1.0
        }
    }
}

/// Credit card types
enum CreditCardType: String {
    case visa = "Visa"
    case mastercard = "Mastercard"
    case amex = "American Express"
    case discover = "Discover"
    case unknown = "Unknown"

    var icon: String {
        switch self {
        case .visa:
            return "creditcard.fill"
        case .mastercard:
            return "creditcard.fill"
        case .amex:
            return "creditcard.fill"
        case .discover:
            return "creditcard.fill"
        case .unknown:
            return "creditcard"
        }
    }
}

// MARK: - Validation Rules Builder

/// Builder for creating custom validation rules
struct ValidationRuleBuilder<T> {
    private var rules: [(T) -> ValidationResult] = []

    mutating func addRule(_ rule: @escaping (T) -> ValidationResult) {
        rules.append(rule)
    }

    mutating func addRule(_ rule: @escaping (T) -> Bool, errorMessage: String) {
        rules.append { value in
            rule(value) ? .valid : .invalid(errorMessage)
        }
    }

    func validate(_ value: T) -> ValidationResult {
        for rule in rules {
            let result = rule(value)
            if case .invalid = result {
                return result
            }
        }
        return .valid
    }
}

// MARK: - Batch Validation

extension Validator {
    /// Validates multiple fields at once
    static func validateAll(_ validations: [(String, ValidationResult)]) -> (isValid: Bool, errors: [String: String]) {
        var errors: [String: String] = [:]

        for (field, result) in validations {
            if case .invalid(let message) = result {
                errors[field] = message
            }
        }

        return (errors.isEmpty, errors)
    }
}