//
//  Color+Extensions.swift
//  My iOS library
//
//  Essential Color extensions for productivity
//

import SwiftUI

extension Color {

    // MARK: - Hex Initialization

    /// Creates a color from a hex string
    /// - Parameter hex: A hex string like "#FF5733" or "FF5733"
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// Returns the hex string representation of the color
    var hexString: String {
        let components = UIColor(self).cgColor.components ?? [0, 0, 0, 1]
        let r = components[0]
        let g = components.count > 1 ? components[1] : 0
        let b = components.count > 2 ? components[2] : 0

        return String(format: "#%02lX%02lX%02lX",
                      lroundf(Float(r * 255)),
                      lroundf(Float(g * 255)),
                      lroundf(Float(b * 255)))
    }

    // MARK: - UIColor Conversion

    /// Converts Color to UIColor
    var uiColor: UIColor {
        UIColor(self)
    }

    // MARK: - Random Color

    /// Returns a random color
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }

    // MARK: - Color Manipulation

    /// Makes the color lighter by a percentage
    func lighter(by percentage: Double = 0.3) -> Color {
        return self.adjust(by: abs(percentage))
    }

    /// Makes the color darker by a percentage
    func darker(by percentage: Double = 0.3) -> Color {
        return self.adjust(by: -abs(percentage))
    }

    /// Adjusts brightness by a percentage
    private func adjust(by percentage: Double) -> Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return Color(
            red: Double(min(red + percentage, 1.0)),
            green: Double(min(green + percentage, 1.0)),
            blue: Double(min(blue + percentage, 1.0)),
            opacity: Double(alpha)
        )
    }

    /// Returns the color with modified opacity
    func opacity(_ value: Double) -> Color {
        return self.opacity(value)
    }

    // MARK: - Contrast Color

    /// Returns white or black depending on the color's luminance
    var contrastingColor: Color {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: nil)

        let luminance = 0.299 * red + 0.587 * green + 0.114 * blue

        return luminance > 0.5 ? .black : .white
    }

    // MARK: - Components

    /// Returns RGB components as a tuple
    var rgbComponents: (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        return (Double(red), Double(green), Double(blue), Double(alpha))
    }

    /// Returns HSB components as a tuple
    var hsbComponents: (hue: Double, saturation: Double, brightness: Double, alpha: Double) {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0

        UIColor(self).getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

        return (Double(hue), Double(saturation), Double(brightness), Double(alpha))
    }
}

// MARK: - Gradient Extensions

extension LinearGradient {
    /// Creates a vertical gradient
    static func vertical(colors: [Color]) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Creates a horizontal gradient
    static func horizontal(colors: [Color]) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    /// Creates a diagonal gradient
    static func diagonal(colors: [Color]) -> LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: colors),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Semantic Colors

extension Color {
    /// Custom semantic colors that adapt to light/dark mode
    struct Semantic {
        /// Primary brand color
        static let primary = Color("PrimaryColor", bundle: .main)
            .defaulting(to: .blue)

        /// Secondary brand color
        static let secondary = Color("SecondaryColor", bundle: .main)
            .defaulting(to: .purple)

        /// Success color (usually green)
        static let success = Color("SuccessColor", bundle: .main)
            .defaulting(to: .green)

        /// Warning color (usually yellow/orange)
        static let warning = Color("WarningColor", bundle: .main)
            .defaulting(to: .orange)

        /// Error/danger color (usually red)
        static let error = Color("ErrorColor", bundle: .main)
            .defaulting(to: .red)

        /// Info color (usually blue)
        static let info = Color("InfoColor", bundle: .main)
            .defaulting(to: .blue)

        // Text colors
        static let textPrimary = Color("TextPrimary", bundle: .main)
            .defaulting(to: Color(UIColor.label))

        static let textSecondary = Color("TextSecondary", bundle: .main)
            .defaulting(to: Color(UIColor.secondaryLabel))

        static let textTertiary = Color("TextTertiary", bundle: .main)
            .defaulting(to: Color(UIColor.tertiaryLabel))

        // Background colors
        static let backgroundPrimary = Color("BackgroundPrimary", bundle: .main)
            .defaulting(to: Color(UIColor.systemBackground))

        static let backgroundSecondary = Color("BackgroundSecondary", bundle: .main)
            .defaulting(to: Color(UIColor.secondarySystemBackground))

        static let backgroundTertiary = Color("BackgroundTertiary", bundle: .main)
            .defaulting(to: Color(UIColor.tertiarySystemBackground))

        // Border colors
        static let border = Color("BorderColor", bundle: .main)
            .defaulting(to: Color(UIColor.separator))
    }
}

// Helper to provide default color if asset is missing
private extension Color {
    func defaulting(to defaultColor: Color) -> Color {
        // Check if the color exists in assets
        if UIColor(named: self.description, in: .main, compatibleWith: nil) != nil {
            return self
        } else {
            return defaultColor
        }
    }
}

// MARK: - Convenience Colors

extension Color {
    /// Common social media brand colors
    struct Brand {
        static let facebook = Color(hex: "#1877F2")
        static let twitter = Color(hex: "#1DA1F2")
        static let instagram = Color(hex: "#E4405F")
        static let linkedin = Color(hex: "#0A66C2")
        static let youtube = Color(hex: "#FF0000")
        static let whatsapp = Color(hex: "#25D366")
        static let snapchat = Color(hex: "#FFFC00")
        static let pinterest = Color(hex: "#E60023")
        static let reddit = Color(hex: "#FF4500")
        static let tiktok = Color(hex: "#000000")
        static let discord = Color(hex: "#5865F2")
        static let spotify = Color(hex: "#1DB954")
    }

    /// Material Design colors
    struct Material {
        static let red = Color(hex: "#F44336")
        static let pink = Color(hex: "#E91E63")
        static let purple = Color(hex: "#9C27B0")
        static let deepPurple = Color(hex: "#673AB7")
        static let indigo = Color(hex: "#3F51B5")
        static let blue = Color(hex: "#2196F3")
        static let lightBlue = Color(hex: "#03A9F4")
        static let cyan = Color(hex: "#00BCD4")
        static let teal = Color(hex: "#009688")
        static let green = Color(hex: "#4CAF50")
        static let lightGreen = Color(hex: "#8BC34A")
        static let lime = Color(hex: "#CDDC39")
        static let yellow = Color(hex: "#FFEB3B")
        static let amber = Color(hex: "#FFC107")
        static let orange = Color(hex: "#FF9800")
        static let deepOrange = Color(hex: "#FF5722")
        static let brown = Color(hex: "#795548")
        static let grey = Color(hex: "#9E9E9E")
        static let blueGrey = Color(hex: "#607D8B")
    }
}