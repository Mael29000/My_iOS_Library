//
//  Typography.swift
//  My_iOS_Library
//
//  Typography system with semantic text styles and custom font support
//

import SwiftUI

// MARK: - Typography Protocol

public protocol TypographyProtocol {
    // Font Family
    var fontFamily: FontFamily { get }

    // Text Styles
    var title: Font { get }
    var heading1: Font { get }
    var heading2: Font { get }
    var heading3: Font { get }
    var body1: Font { get }
    var body2: Font { get }
    var label1: Font { get }
    var label2: Font { get }

    // Additional Styles
    var caption: Font { get }
    var button: Font { get }
    var link: Font { get }
    var code: Font { get }
}

// MARK: - Font Family

public struct FontFamily {
    let regular: String
    let medium: String
    let semibold: String
    let bold: String
    let black: String

    // Optional italic variants
    let italic: String?
    let mediumItalic: String?
    let semiboldItalic: String?
    let boldItalic: String?

    // System font
    public static let system = FontFamily(
        regular: ".SFUI-Regular",
        medium: ".SFUI-Medium",
        semibold: ".SFUI-Semibold",
        bold: ".SFUI-Bold",
        black: ".SFUI-Black",
        italic: ".SFUI-RegularItalic",
        mediumItalic: ".SFUI-MediumItalic",
        semiboldItalic: ".SFUI-SemiboldItalic",
        boldItalic: ".SFUI-BoldItalic"
    )

    // Example custom font family (Inter)
    public static let inter = FontFamily(
        regular: "Inter-Regular",
        medium: "Inter-Medium",
        semibold: "Inter-SemiBold",
        bold: "Inter-Bold",
        black: "Inter-Black",
        italic: "Inter-Italic",
        mediumItalic: "Inter-MediumItalic",
        semiboldItalic: "Inter-SemiBoldItalic",
        boldItalic: "Inter-BoldItalic"
    )
}

// MARK: - Default Typography

public struct DefaultTypography: TypographyProtocol {
    public let fontFamily: FontFamily

    public init(fontFamily: FontFamily = .system) {
        self.fontFamily = fontFamily
    }

    // MARK: - Text Styles

    public var title: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .largeTitle.weight(.bold)
        }
        return .custom(fontFamily.bold, size: 34, relativeTo: .largeTitle)
    }

    public var heading1: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .title.weight(.bold)
        }
        return .custom(fontFamily.bold, size: 28, relativeTo: .title)
    }

    public var heading2: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .title2.weight(.semibold)
        }
        return .custom(fontFamily.semibold, size: 22, relativeTo: .title2)
    }

    public var heading3: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .title3.weight(.semibold)
        }
        return .custom(fontFamily.semibold, size: 20, relativeTo: .title3)
    }

    public var body1: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .body
        }
        return .custom(fontFamily.regular, size: 17, relativeTo: .body)
    }

    public var body2: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .subheadline
        }
        return .custom(fontFamily.regular, size: 15, relativeTo: .subheadline)
    }

    public var label1: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .caption.weight(.medium)
        }
        return .custom(fontFamily.medium, size: 12, relativeTo: .caption)
    }

    public var label2: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .caption2.weight(.medium)
        }
        return .custom(fontFamily.medium, size: 11, relativeTo: .caption2)
    }

    // MARK: - Additional Styles

    public var caption: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .footnote
        }
        return .custom(fontFamily.regular, size: 13, relativeTo: .footnote)
    }

    public var button: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .body.weight(.semibold)
        }
        return .custom(fontFamily.semibold, size: 17, relativeTo: .body)
    }

    public var link: Font {
        if fontFamily.regular == FontFamily.system.regular {
            return .body.weight(.medium)
        }
        return .custom(fontFamily.medium, size: 17, relativeTo: .body)
    }

    public var code: Font {
        return .system(size: 14, design: .monospaced)
    }
}

// MARK: - Typography Environment Key

private struct TypographyKey: EnvironmentKey {
    static let defaultValue: any TypographyProtocol = DefaultTypography()
}

extension EnvironmentValues {
    public var typography: any TypographyProtocol {
        get { self[TypographyKey.self] }
        set { self[TypographyKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    /// Sets the typography for this view hierarchy
    public func typography(_ typography: any TypographyProtocol) -> some View {
        environment(\.typography, typography)
    }

    /// Applies a semantic text style
    public func textStyle(_ style: TextStyle) -> some View {
        self.modifier(TextStyleModifier(style: style))
    }
}

// MARK: - Text Style Enum

public enum TextStyle {
    case title
    case heading1
    case heading2
    case heading3
    case body1
    case body2
    case label1
    case label2
    case caption
    case button
    case link
    case code
}

// MARK: - Text Style Modifier

struct TextStyleModifier: ViewModifier {
    @Environment(\.typography) private var typography
    @Environment(\.theme) private var theme

    let style: TextStyle

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(textColor)
    }

    private var font: Font {
        switch style {
        case .title: return typography.title
        case .heading1: return typography.heading1
        case .heading2: return typography.heading2
        case .heading3: return typography.heading3
        case .body1: return typography.body1
        case .body2: return typography.body2
        case .label1: return typography.label1
        case .label2: return typography.label2
        case .caption: return typography.caption
        case .button: return typography.button
        case .link: return typography.link
        case .code: return typography.code
        }
    }

    private var textColor: Color {
        switch style {
        case .title, .heading1, .heading2, .heading3:
            return theme.textPrimary
        case .body1, .button:
            return theme.textPrimary
        case .body2, .caption:
            return theme.textSecondary
        case .label1, .label2:
            return theme.textSecondary
        case .link:
            return theme.primaryColor
        case .code:
            return theme.textPrimary
        }
    }
}

// MARK: - Font Registration Helper

public struct FontRegistration {
    /// Registers custom fonts with the system
    /// Place your font files in the app's bundle and add them to Info.plist
    public static func registerCustomFonts() {
        // This is typically not needed in SwiftUI as fonts in the bundle are auto-registered
        // But keeping this for reference if manual registration is needed

        // Example fonts to register
        let fonts = [
            "Inter-Regular",
            "Inter-Medium",
            "Inter-SemiBold",
            "Inter-Bold",
            "Inter-Black",
            "Inter-Italic",
            "Inter-MediumItalic",
            "Inter-SemiBoldItalic",
            "Inter-BoldItalic"
        ]

        for fontName in fonts {
            registerFont(named: fontName, withExtension: "ttf")
        }
    }

    private static func registerFont(named name: String, withExtension ext: String) {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: ext),
              let fontData = try? Data(contentsOf: fontURL) as CFData,
              let provider = CGDataProvider(data: fontData),
              let font = CGFont(provider) else {
            print("Failed to register font: \(name)")
            return
        }

        CTFontManagerRegisterGraphicsFont(font, nil)
    }
}

// MARK: - Text Extensions

extension Text {
    /// Applies a semantic text style to the text
    public func style(_ style: TextStyle) -> some View {
        self.modifier(TextStyleModifier(style: style))
    }
}