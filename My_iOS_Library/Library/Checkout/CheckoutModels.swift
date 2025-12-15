//
//  CheckoutModels.swift
//  My_iOS_Library
//
//  Models for checkout and pricing plans
//

import SwiftUI

// MARK: - Subscription Plan

public struct SubscriptionPlan: Identifiable, Equatable {
    public let id: String
    public let name: String
    public let price: Price
    public let interval: BillingInterval
    public let features: [PlanFeature]
    public let isPopular: Bool
    public let colorTheme: PlanColorTheme

    public init(
        id: String,
        name: String,
        price: Price,
        interval: BillingInterval = .monthly,
        features: [PlanFeature],
        isPopular: Bool = false,
        colorTheme: PlanColorTheme = .default
    ) {
        self.id = id
        self.name = name
        self.price = price
        self.interval = interval
        self.features = features
        self.isPopular = isPopular
        self.colorTheme = colorTheme
    }
}

// MARK: - Price

public struct Price: Equatable {
    public let amount: Double
    public let currency: Currency
    public let displayPrice: String

    public init(amount: Double, currency: Currency = .usd) {
        self.amount = amount
        self.currency = currency
        self.displayPrice = currency.format(amount)
    }

    public static let free = Price(amount: 0, currency: .usd)
}

// MARK: - Currency

public enum Currency: String {
    case usd = "USD"
    case eur = "EUR"
    case gbp = "GBP"

    public var symbol: String {
        switch self {
        case .usd: return "$"
        case .eur: return "€"
        case .gbp: return "£"
        }
    }

    public func format(_ amount: Double) -> String {
        if amount == 0 {
            return "Free"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = self.rawValue
        formatter.currencySymbol = self.symbol
        formatter.maximumFractionDigits = amount.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
        return formatter.string(from: NSNumber(value: amount)) ?? "\(symbol)\(amount)"
    }
}

// MARK: - Billing Interval

public enum BillingInterval: String, CaseIterable {
    case monthly = "month"
    case yearly = "year"
    case lifetime = "lifetime"

    public var displayName: String {
        switch self {
        case .monthly: return "Monthly"
        case .yearly: return "Yearly"
        case .lifetime: return "Lifetime"
        }
    }

    public var shortName: String {
        switch self {
        case .monthly: return "/mo"
        case .yearly: return "/yr"
        case .lifetime: return ""
        }
    }
}

// MARK: - Plan Feature

public struct PlanFeature: Identifiable, Equatable {
    public let id = UUID()
    public let title: String
    public let isIncluded: Bool
    public let tooltip: String?

    public init(title: String, isIncluded: Bool = true, tooltip: String? = nil) {
        self.title = title
        self.isIncluded = isIncluded
        self.tooltip = tooltip
    }
}

// MARK: - Plan Color Theme

public struct PlanColorTheme: Equatable {
    public let primary: Color
    public let secondary: Color
    public let gradient: LinearGradient

    public init(primary: Color, secondary: Color) {
        self.primary = primary
        self.secondary = secondary
        self.gradient = LinearGradient(
            colors: [primary, secondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public static func == (lhs: PlanColorTheme, rhs: PlanColorTheme) -> Bool {
        // Compare colors by their description since Color doesn't conform to Equatable
        lhs.primary.description == rhs.primary.description &&
        lhs.secondary.description == rhs.secondary.description
    }

    public static let `default` = PlanColorTheme(
        primary: Color.gray,
        secondary: Color.gray.opacity(0.8)
    )

    public static let free = PlanColorTheme(
        primary: Color.gray,
        secondary: Color.gray.opacity(0.8)
    )

    public static let pro = PlanColorTheme(
        primary: Color.blue,
        secondary: Color.blue.opacity(0.8)
    )

    public static let premium = PlanColorTheme(
        primary: Color.purple,
        secondary: Color.pink
    )
}

// MARK: - Payment Method

public enum PaymentMethod: String, CaseIterable {
    case creditCard = "Credit Card"
    case applePay = "Apple Pay"
    case googlePay = "Google Pay"
    case paypal = "PayPal"

    public var icon: String {
        switch self {
        case .creditCard: return "creditcard"
        case .applePay: return "applelogo"
        case .googlePay: return "g.circle"
        case .paypal: return "p.circle"
        }
    }

    public var isAvailable: Bool {
        switch self {
        case .applePay:
            // Check if Apple Pay is available
            return true // Simplified for UI demo
        case .googlePay:
            return false // Not available on iOS
        default:
            return true
        }
    }
}

// MARK: - Card Details

public struct CardDetails {
    public var number: String = ""
    public var holderName: String = ""
    public var expiryMonth: String = ""
    public var expiryYear: String = ""
    public var cvv: String = ""

    public init() {}

    public var last4Digits: String {
        guard number.count >= 4 else { return "" }
        return String(number.suffix(4))
    }

    public var formattedNumber: String {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        let groups = stride(from: 0, to: cleaned.count, by: 4).map {
            let start = cleaned.index(cleaned.startIndex, offsetBy: $0)
            let end = cleaned.index(start, offsetBy: min(4, cleaned.count - $0))
            return String(cleaned[start..<end])
        }
        return groups.joined(separator: " ")
    }

    public var isValid: Bool {
        let cleanedNumber = number.replacingOccurrences(of: " ", with: "")
        return cleanedNumber.count >= 13 &&
               cleanedNumber.count <= 19 &&
               !holderName.isEmpty &&
               expiryMonth.count == 2 &&
               expiryYear.count == 2 &&
               cvv.count >= 3
    }
}

// MARK: - Checkout State

public enum CheckoutStep: Int, CaseIterable {
    case selectPlan = 0
    case payment = 1
    case confirmation = 2

    public var title: String {
        switch self {
        case .selectPlan: return "Choose Your Plan"
        case .payment: return "Payment Details"
        case .confirmation: return "Confirmation"
        }
    }
}

// MARK: - Sample Plans

public extension SubscriptionPlan {
    static let samplePlans: [SubscriptionPlan] = [
        SubscriptionPlan(
            id: "free",
            name: "Free",
            price: .free,
            features: [
                PlanFeature(title: "5 Projects", isIncluded: true),
                PlanFeature(title: "Basic Support", isIncluded: true),
                PlanFeature(title: "1GB Storage", isIncluded: true),
                PlanFeature(title: "Advanced Features", isIncluded: false),
                PlanFeature(title: "Priority Support", isIncluded: false),
                PlanFeature(title: "Custom Domain", isIncluded: false)
            ],
            colorTheme: .free
        ),
        SubscriptionPlan(
            id: "pro",
            name: "Pro",
            price: Price(amount: 9.99),
            features: [
                PlanFeature(title: "Unlimited Projects", isIncluded: true),
                PlanFeature(title: "Priority Support", isIncluded: true),
                PlanFeature(title: "10GB Storage", isIncluded: true),
                PlanFeature(title: "Advanced Features", isIncluded: true),
                PlanFeature(title: "Analytics Dashboard", isIncluded: true),
                PlanFeature(title: "Custom Domain", isIncluded: false)
            ],
            isPopular: true,
            colorTheme: .pro
        ),
        SubscriptionPlan(
            id: "premium",
            name: "Premium",
            price: Price(amount: 29.99),
            features: [
                PlanFeature(title: "Everything in Pro", isIncluded: true),
                PlanFeature(title: "Unlimited Storage", isIncluded: true),
                PlanFeature(title: "Custom Domain", isIncluded: true),
                PlanFeature(title: "White Label", isIncluded: true),
                PlanFeature(title: "API Access", isIncluded: true),
                PlanFeature(title: "Dedicated Support", isIncluded: true)
            ],
            colorTheme: .premium
        )
    ]
}