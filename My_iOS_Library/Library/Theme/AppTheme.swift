//
//  AppTheme.swift
//  My_iOS_Library
//
//  Central theme system for colors, typography, spacing, and styling
//

import SwiftUI

// MARK: - Theme Protocol

public protocol AppThemeProtocol {
    // Typography
    var typography: any TypographyProtocol { get }

    // Spacing
    var spacing: any SpacingProtocol { get }

    // Core Colors
    var primaryColor: Color { get }
    var secondaryColor: Color { get }

    // Text Colors
    var textPrimary: Color { get }
    var textSecondary: Color { get }
    var textTertiary: Color { get }

    // Semantic Colors
    var successColor: Color { get }
    var errorColor: Color { get }
    var warningColor: Color { get }
    var infoColor: Color { get }

    // Background Colors
    var backgroundPrimary: Color { get }
    var backgroundSecondary: Color { get }
    var backgroundTertiary: Color { get }

    // Surface Colors
    var surfaceColor: Color { get }
    var surfaceSecondary: Color { get }

    // Border & Divider
    var borderColor: Color { get }
    var dividerColor: Color { get }

    // Gradients
    var primaryGradient: LinearGradient { get }
    var secondaryGradient: LinearGradient { get }
    var accentGradient: LinearGradient { get }
    var backgroundGradient: LinearGradient { get }
}

// MARK: - Default Theme

public struct DefaultTheme: AppThemeProtocol {

    // MARK: - Typography & Spacing

    public let typography: any TypographyProtocol
    public let spacing: any SpacingProtocol

    public init(
        typography: any TypographyProtocol = DefaultTypography(),
        spacing: any SpacingProtocol = DefaultSpacing()
    ) {
        self.typography = typography
        self.spacing = spacing
    }

    // MARK: - Core Colors

    public var primaryColor: Color {
        Color("Primary", bundle: .main)
            .opacity(1.0)
    }

    public var secondaryColor: Color {
        Color("Secondary", bundle: .main)
            .opacity(1.0)
    }

    // Fallback colors if not defined in Assets
    private var fallbackPrimary: Color {
        Color(light: .init(hex: 0x007AFF), dark: .init(hex: 0x0A84FF))
    }

    private var fallbackSecondary: Color {
        Color(light: .init(hex: 0x5856D6), dark: .init(hex: 0x5E5CE6))
    }

    // MARK: - Text Colors

    public var textPrimary: Color {
        Color(light: .init(hex: 0x000000), dark: .init(hex: 0xFFFFFF))
    }

    public var textSecondary: Color {
        Color(light: .init(hex: 0x3C3C43, opacity: 0.6),
              dark: .init(hex: 0xEBEBF5, opacity: 0.6))
    }

    public var textTertiary: Color {
        Color(light: .init(hex: 0x3C3C43, opacity: 0.3),
              dark: .init(hex: 0xEBEBF5, opacity: 0.3))
    }

    // MARK: - Semantic Colors

    public var successColor: Color {
        Color(light: .init(hex: 0x34C759), dark: .init(hex: 0x32D74B))
    }

    public var errorColor: Color {
        Color(light: .init(hex: 0xFF3B30), dark: .init(hex: 0xFF453A))
    }

    public var warningColor: Color {
        Color(light: .init(hex: 0xFF9500), dark: .init(hex: 0xFF9F0A))
    }

    public var infoColor: Color {
        Color(light: .init(hex: 0x007AFF), dark: .init(hex: 0x0A84FF))
    }

    // MARK: - Background Colors

    public var backgroundPrimary: Color {
        Color(light: .init(hex: 0xFFFFFF), dark: .init(hex: 0x000000))
    }

    public var backgroundSecondary: Color {
        Color(light: .init(hex: 0xF2F2F7), dark: .init(hex: 0x1C1C1E))
    }

    public var backgroundTertiary: Color {
        Color(light: .init(hex: 0xFFFFFF), dark: .init(hex: 0x2C2C2E))
    }

    // MARK: - Surface Colors

    public var surfaceColor: Color {
        Color(light: .init(hex: 0xFFFFFF), dark: .init(hex: 0x1C1C1E))
    }

    public var surfaceSecondary: Color {
        Color(light: .init(hex: 0xF2F2F7), dark: .init(hex: 0x2C2C2E))
    }

    // MARK: - Border & Divider

    public var borderColor: Color {
        Color(light: .init(hex: 0xC6C6C8), dark: .init(hex: 0x38383A))
    }

    public var dividerColor: Color {
        Color(light: .init(hex: 0x3C3C43, opacity: 0.2),
              dark: .init(hex: 0x545458, opacity: 0.65))
    }

    // MARK: - Gradients

    public var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [
                primaryColor,
                primaryColor.opacity(0.8)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public var secondaryGradient: LinearGradient {
        LinearGradient(
            colors: [
                secondaryColor,
                secondaryColor.opacity(0.8)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public var accentGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(light: .init(hex: 0x007AFF), dark: .init(hex: 0x0A84FF)),
                Color(light: .init(hex: 0x5856D6), dark: .init(hex: 0x5E5CE6)),
                Color(light: .init(hex: 0xAF52DE), dark: .init(hex: 0xBF5AF2))
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [
                backgroundPrimary,
                backgroundSecondary
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

// MARK: - Color Extension for Light/Dark Support

extension Color {
    init(light: UIColor, dark: UIColor) {
        self.init(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? dark : light
        })
    }
}

// MARK: - UIColor Extension for Hex Support

extension UIColor {
    convenience init(hex: UInt32, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255.0
        let green = Double((hex >> 8) & 0xff) / 255.0
        let blue = Double(hex & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: opacity)
    }
}

// MARK: - Theme Environment Key

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue: any AppThemeProtocol = DefaultTheme()
}

extension EnvironmentValues {
    public var theme: any AppThemeProtocol {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

// MARK: - View Extension for Theme

extension View {
    public func theme(_ theme: any AppThemeProtocol) -> some View {
        environment(\.theme, theme)
    }
}

// MARK: - Convenience Extensions

extension View {
    // Quick access to theme colors
    public func foregroundStyle(_ semantic: SemanticColor) -> some View {
        self.modifier(ThemedForegroundModifier(semantic: semantic))
    }

    public func backgroundStyle(_ semantic: SemanticBackground) -> some View {
        self.modifier(ThemedBackgroundModifier(semantic: semantic))
    }
}

// MARK: - Semantic Color Types

public enum SemanticColor {
    case primary
    case secondary
    case textPrimary
    case textSecondary
    case textTertiary
    case success
    case error
    case warning
    case info
}

public enum SemanticBackground {
    case primary
    case secondary
    case tertiary
    case surface
    case surfaceSecondary
}

// MARK: - Theme Modifiers

struct ThemedForegroundModifier: ViewModifier {
    @Environment(\.theme) private var theme
    let semantic: SemanticColor

    func body(content: Content) -> some View {
        content.foregroundColor(color)
    }

    private var color: Color {
        switch semantic {
        case .primary:
            return theme.primaryColor
        case .secondary:
            return theme.secondaryColor
        case .textPrimary:
            return theme.textPrimary
        case .textSecondary:
            return theme.textSecondary
        case .textTertiary:
            return theme.textTertiary
        case .success:
            return theme.successColor
        case .error:
            return theme.errorColor
        case .warning:
            return theme.warningColor
        case .info:
            return theme.infoColor
        }
    }
}

struct ThemedBackgroundModifier: ViewModifier {
    @Environment(\.theme) private var theme
    let semantic: SemanticBackground

    func body(content: Content) -> some View {
        content.background(color)
    }

    private var color: Color {
        switch semantic {
        case .primary:
            return theme.backgroundPrimary
        case .secondary:
            return theme.backgroundSecondary
        case .tertiary:
            return theme.backgroundTertiary
        case .surface:
            return theme.surfaceColor
        case .surfaceSecondary:
            return theme.surfaceSecondary
        }
    }
}