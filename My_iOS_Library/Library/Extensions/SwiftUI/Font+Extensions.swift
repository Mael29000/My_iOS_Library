//
//  Font+Extensions.swift
//  My iOS library
//
//  Essential Font extensions for productivity
//

import SwiftUI

extension Font {

    // MARK: - Custom Fonts

    /// Creates a custom font with size
    static func custom(_ name: String, size: CGFloat) -> Font {
        return Font.custom(name, size: size)
    }

    /// Creates a custom font with dynamic size
    static func custom(_ name: String, size: CGFloat, relativeTo textStyle: Font.TextStyle) -> Font {
        return Font.custom(name, size: size, relativeTo: textStyle)
    }

    /// Creates a custom font that scales with Dynamic Type
    static func customScalable(_ name: String, size: CGFloat) -> Font {
        return Font.custom(name, size: size, relativeTo: .body)
    }

    // MARK: - System Font Weights

    /// System font with specific weight
    static func system(_ style: Font.TextStyle, weight: Font.Weight) -> Font {
        switch style {
        case .largeTitle:
            return .system(size: 34, weight: weight)
        case .title:
            return .system(size: 28, weight: weight)
        case .title2:
            return .system(size: 22, weight: weight)
        case .title3:
            return .system(size: 20, weight: weight)
        case .headline:
            return .system(size: 17, weight: weight)
        case .body:
            return .system(size: 17, weight: weight)
        case .callout:
            return .system(size: 16, weight: weight)
        case .subheadline:
            return .system(size: 15, weight: weight)
        case .footnote:
            return .system(size: 13, weight: weight)
        case .caption:
            return .system(size: 12, weight: weight)
        case .caption2:
            return .system(size: 11, weight: weight)
        @unknown default:
            return .system(size: 17, weight: weight)
        }
    }

    /// System font with specific size and design
    static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        return Font.system(size: size, weight: weight, design: design)
    }

    // MARK: - Rounded System Font

    /// Creates a rounded system font
    static func roundedSystem(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight, design: .rounded)
    }

    /// Creates a rounded system font with text style
    static func roundedSystem(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> Font {
        switch style {
        case .largeTitle:
            return roundedSystem(size: 34, weight: weight)
        case .title:
            return roundedSystem(size: 28, weight: weight)
        case .title2:
            return roundedSystem(size: 22, weight: weight)
        case .title3:
            return roundedSystem(size: 20, weight: weight)
        case .headline:
            return roundedSystem(size: 17, weight: weight)
        case .body:
            return roundedSystem(size: 17, weight: weight)
        case .callout:
            return roundedSystem(size: 16, weight: weight)
        case .subheadline:
            return roundedSystem(size: 15, weight: weight)
        case .footnote:
            return roundedSystem(size: 13, weight: weight)
        case .caption:
            return roundedSystem(size: 12, weight: weight)
        case .caption2:
            return roundedSystem(size: 11, weight: weight)
        @unknown default:
            return roundedSystem(size: 17, weight: weight)
        }
    }

    // MARK: - Monospaced Font

    /// Creates a monospaced system font
    static func monospacedSystem(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight, design: .monospaced)
    }

    /// Creates a monospaced digit font
    static func monospacedDigit(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight).monospacedDigit()
    }

    // MARK: - Serif Font

    /// Creates a serif system font
    static func serifSystem(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight, design: .serif)
    }

    // MARK: - Common Font Sizes

    struct Size {
        /// Extra extra large title (48pt)
        static let xxxLarge: CGFloat = 48

        /// Extra large title (40pt)
        static let xxLarge: CGFloat = 40

        /// Large title (34pt)
        static let xLarge: CGFloat = 34

        /// Title (28pt)
        static let large: CGFloat = 28

        /// Title 2 (22pt)
        static let medium: CGFloat = 22

        /// Title 3 (20pt)
        static let regular: CGFloat = 20

        /// Body/Headline (17pt)
        static let body: CGFloat = 17

        /// Callout (16pt)
        static let callout: CGFloat = 16

        /// Subheadline (15pt)
        static let subheadline: CGFloat = 15

        /// Footnote (13pt)
        static let footnote: CGFloat = 13

        /// Caption (12pt)
        static let caption: CGFloat = 12

        /// Caption 2 (11pt)
        static let small: CGFloat = 11

        /// Extra small (10pt)
        static let xSmall: CGFloat = 10

        /// Extra extra small (9pt)
        static let xxSmall: CGFloat = 9
    }

    // MARK: - Dynamic Type Helpers

    /// Scales a font size based on the user's preferred content size
    static func scaledSize(_ size: CGFloat, relativeTo textStyle: Font.TextStyle = .body) -> CGFloat {
        let metrics = UIFontMetrics(forTextStyle: textStyle.uiTextStyle)
        return metrics.scaledValue(for: size)
    }

    /// Creates a font that respects Dynamic Type with min and max sizes
    static func scaledSystem(
        size: CGFloat,
        weight: Font.Weight = .regular,
        design: Font.Design = .default,
        minSize: CGFloat? = nil,
        maxSize: CGFloat? = nil
    ) -> Font {
        let scaledSize = scaledSize(size)
        var finalSize = scaledSize

        if let min = minSize {
            finalSize = max(finalSize, min)
        }
        if let max = maxSize {
            finalSize = min(finalSize, max)
        }

        return Font.system(size: finalSize, weight: weight, design: design)
    }
}

// MARK: - Text Style to UIKit

private extension Font.TextStyle {
    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title1
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .body:
            return .body
        case .callout:
            return .callout
        case .subheadline:
            return .subheadline
        case .footnote:
            return .footnote
        case .caption:
            return .caption1
        case .caption2:
            return .caption2
        @unknown default:
            return .body
        }
    }
}

// MARK: - Font Weight Extensions

extension Font.Weight {
    /// Returns the next heavier weight
    var heavier: Font.Weight {
        switch self {
        case .ultraLight:
            return .thin
        case .thin:
            return .light
        case .light:
            return .regular
        case .regular:
            return .medium
        case .medium:
            return .semibold
        case .semibold:
            return .bold
        case .bold:
            return .heavy
        case .heavy:
            return .black
        case .black:
            return .black
        default:
            return .regular
        }
    }

    /// Returns the next lighter weight
    var lighter: Font.Weight {
        switch self {
        case .black:
            return .heavy
        case .heavy:
            return .bold
        case .bold:
            return .semibold
        case .semibold:
            return .medium
        case .medium:
            return .regular
        case .regular:
            return .light
        case .light:
            return .thin
        case .thin:
            return .ultraLight
        case .ultraLight:
            return .ultraLight
        default:
            return .regular
        }
    }
}

// MARK: - View Extensions for Font

extension View {
    /// Applies a custom font with size
    func customFont(_ name: String, size: CGFloat) -> some View {
        self.font(.custom(name, size: size))
    }

    /// Applies a system font with size and weight
    func systemFont(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
        self.font(.system(size: size, weight: weight, design: design))
    }

    /// Applies a rounded system font
    func roundedFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.font(.roundedSystem(size: size, weight: weight))
    }

    /// Applies a monospaced font
    func monospacedFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.font(.monospacedSystem(size: size, weight: weight))
    }

    /// Applies font weight
    func weight(_ weight: Font.Weight) -> some View {
        self.fontWeight(weight)
    }

    /// Makes text bold
    func bold(_ isBold: Bool = true) -> some View {
        self.fontWeight(isBold ? .bold : .regular)
    }

    /// Applies italic style conditionally
    func italicText(_ isItalic: Bool = true) -> some View {
        if isItalic {
            return AnyView(self.italic())
        } else {
            return AnyView(self)
        }
    }
}

// MARK: - Typography Presets

extension Font {
    /// Common typography presets for consistent styling
    struct Typography {
        // Headers
        static let h1 = Font.system(size: 48, weight: .bold)
        static let h2 = Font.system(size: 40, weight: .bold)
        static let h3 = Font.system(size: 34, weight: .semibold)
        static let h4 = Font.system(size: 28, weight: .semibold)
        static let h5 = Font.system(size: 22, weight: .medium)
        static let h6 = Font.system(size: 20, weight: .medium)

        // Body text
        static let bodyLarge = Font.system(size: 18, weight: .regular)
        static let bodyMedium = Font.system(size: 16, weight: .regular)
        static let bodySmall = Font.system(size: 14, weight: .regular)

        // UI elements
        static let button = Font.system(size: 16, weight: .semibold)
        static let buttonSmall = Font.system(size: 14, weight: .medium)
        static let label = Font.system(size: 12, weight: .medium)
        static let labelSmall = Font.system(size: 10, weight: .medium)

        // Special
        static let code = Font.system(size: 14, weight: .regular, design: .monospaced)
        static let quote = Font.system(size: 16, weight: .regular, design: .serif)
    }
}