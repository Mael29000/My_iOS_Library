//
//  PrimaryButton+Styles.swift
//  My_iOS_Library
//
//  Predefined styles and themes for PrimaryButton
//

import SwiftUI

// MARK: - Predefined Styles

extension PrimaryButton {

    // MARK: - Solid Colors

    public static func blue(_ title: String, icon: String? = nil, action: @escaping () async -> Void) -> some View {
        PrimaryButton(title, icon: icon, action: action)
            .primaryButtonColors(
                background: { isEnabled, _ in
                    isEnabled ? Color.blue : Color.gray.opacity(0.3)
                },
                foreground: { _, _ in .white }
            )
    }

    public static func green(_ title: String, icon: String? = nil, action: @escaping () async -> Void) -> some View {
        PrimaryButton(title, icon: icon, action: action)
            .primaryButtonColors(
                background: { isEnabled, _ in
                    isEnabled ? Color.green : Color.gray.opacity(0.3)
                },
                foreground: { _, _ in .white }
            )
    }

    public static func red(_ title: String, icon: String? = nil, action: @escaping () async -> Void) -> some View {
        PrimaryButton(title, icon: icon, action: action)
            .primaryButtonColors(
                background: { isEnabled, _ in
                    isEnabled ? Color.red : Color.gray.opacity(0.3)
                },
                foreground: { _, _ in .white }
            )
    }

    public static func purple(_ title: String, icon: String? = nil, action: @escaping () async -> Void) -> some View {
        PrimaryButton(title, icon: icon, action: action)
            .primaryButtonColors(
                background: { isEnabled, _ in
                    isEnabled ? Color.purple : Color.gray.opacity(0.3)
                },
                foreground: { _, _ in .white }
            )
    }

    // MARK: - Gradient Styles

    public static func blueGradient(_ title: String, icon: String? = nil, action: @escaping () async -> Void) -> some View {
        PrimaryButton(title, icon: icon, action: action)
            .primaryButtonGradient { isEnabled, _ in
                isEnabled
                    ? [Color.blue, Color.blue.opacity(0.7)]
                    : [Color.gray.opacity(0.3), Color.gray.opacity(0.2)]
            }
    }

    public static func purpleGradient(_ title: String, icon: String? = nil, action: @escaping () async -> Void) -> some View {
        PrimaryButton(title, icon: icon, action: action)
            .primaryButtonGradient { isEnabled, _ in
                isEnabled
                    ? [Color.purple, Color.pink]
                    : [Color.gray.opacity(0.3), Color.gray.opacity(0.2)]
            }
    }

    public static func sunsetGradient(_ title: String, icon: String? = nil, action: @escaping () async -> Void) -> some View {
        PrimaryButton(title, icon: icon, action: action)
            .primaryButtonGradient { isEnabled, _ in
                isEnabled
                    ? [Color.orange, Color.pink]
                    : [Color.gray.opacity(0.3), Color.gray.opacity(0.2)]
            }
    }

    public static func oceanGradient(_ title: String, icon: String? = nil, action: @escaping () async -> Void) -> some View {
        PrimaryButton(title, icon: icon, action: action)
            .primaryButtonGradient { isEnabled, _ in
                isEnabled
                    ? [Color.blue, Color.teal]
                    : [Color.gray.opacity(0.3), Color.gray.opacity(0.2)]
            }
    }
}

// MARK: - Theme Configurations

public struct PrimaryButtonTheme {

    // MARK: - Default color functions

    private static func defaultBackgroundColor(isEnabled: Bool, colorScheme: ColorScheme) -> Color {
        if !isEnabled {
            return colorScheme == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2)
        }
        return Color.accentColor
    }

    private static func defaultForegroundColor(isEnabled: Bool, colorScheme: ColorScheme) -> Color {
        if !isEnabled {
            return colorScheme == .dark ? Color.gray : Color.gray.opacity(0.6)
        }
        return .white
    }

    private static func defaultGradientColors(isEnabled: Bool, colorScheme: ColorScheme) -> [Color] {
        if !isEnabled {
            return [Color.gray.opacity(0.3), Color.gray.opacity(0.2)]
        }
        return [Color.accentColor, Color.accentColor.opacity(0.8)]
    }

    private static func defaultShadowColor(isEnabled: Bool, colorScheme: ColorScheme) -> Color {
        if !isEnabled {
            return .clear
        }
        return colorScheme == .dark
            ? Color.accentColor.opacity(0.3)
            : Color.black.opacity(0.15)
    }

    // MARK: - Default Theme

    public static let `default` = PrimaryButtonStyleConfiguration(
        size: PrimaryButtonSize.medium,
        height: 44,
        fontSize: 16,
        iconSize: 16,
        spacing: 8,
        cornerRadius: 10,
        hasGradient: false,
        backgroundColor: defaultBackgroundColor,
        foregroundColor: defaultForegroundColor,
        gradientColors: defaultGradientColors,
        shadowColor: defaultShadowColor
    )

    // MARK: - Flat Theme (No shadows)

    public static let flat = PrimaryButtonStyleConfiguration(
        size: PrimaryButtonSize.medium,
        height: 44,
        fontSize: 16,
        iconSize: 16,
        spacing: 8,
        cornerRadius: 8,
        hasGradient: false,
        backgroundColor: defaultBackgroundColor,
        foregroundColor: defaultForegroundColor,
        gradientColors: defaultGradientColors,
        shadowColor: { _, _ in .clear }
    )

    // MARK: - Rounded Theme

    public static let rounded = PrimaryButtonStyleConfiguration(
        size: PrimaryButtonSize.medium,
        height: 44,
        fontSize: 16,
        iconSize: 16,
        spacing: 8,
        cornerRadius: 22, // Half of height for pill shape
        hasGradient: false,
        backgroundColor: defaultBackgroundColor,
        foregroundColor: defaultForegroundColor,
        gradientColors: defaultGradientColors,
        shadowColor: defaultShadowColor
    )

    // MARK: - Outline Theme

    public static let outline = PrimaryButtonStyleConfiguration(
        size: PrimaryButtonSize.medium,
        height: 44,
        fontSize: 16,
        iconSize: 16,
        spacing: 8,
        cornerRadius: 10,
        hasGradient: false,
        backgroundColor: { _, _ in .clear },
        foregroundColor: { isEnabled, _ in
            isEnabled ? Color.accentColor : Color.gray
        },
        gradientColors: { _, _ in [] },
        shadowColor: { _, _ in .clear }
    )

    // MARK: - Ghost Theme

    public static let ghost = PrimaryButtonStyleConfiguration(
        size: PrimaryButtonSize.medium,
        height: 44,
        fontSize: 16,
        iconSize: 16,
        spacing: 8,
        cornerRadius: 10,
        hasGradient: false,
        backgroundColor: { isEnabled, _ in
            isEnabled ? Color.accentColor.opacity(0.1) : Color.gray.opacity(0.1)
        },
        foregroundColor: { isEnabled, _ in
            isEnabled ? Color.accentColor : Color.gray
        },
        gradientColors: { _, _ in [] },
        shadowColor: { _, _ in .clear }
    )
}

// MARK: - Convenience Extensions

extension View {
    public func primaryButtonTheme(_ theme: PrimaryButtonStyleConfiguration) -> some View {
        environment(\.primaryButtonStyle, theme)
    }
}

// MARK: - Common Button Presets

extension PrimaryButton {

    // MARK: - Action Buttons

    public static func save(action: @escaping () async -> Void) -> some View {
        PrimaryButton("Save", icon: "checkmark.circle.fill", action: action)
            .primaryButtonColors(
                background: { isEnabled, _ in
                    isEnabled ? Color.green : Color.gray.opacity(0.3)
                },
                foreground: { _, _ in .white }
            )
    }

    public static func delete(action: @escaping () async -> Void) -> some View {
        PrimaryButton("Delete", icon: "trash.fill", action: action)
            .primaryButtonColors(
                background: { isEnabled, _ in
                    isEnabled ? Color.red : Color.gray.opacity(0.3)
                },
                foreground: { _, _ in .white }
            )
    }

    public static func submit(action: @escaping () async -> Void) -> some View {
        PrimaryButton("Submit", icon: "paperplane.fill", iconPosition: .trailing, action: action)
    }

    public static func next(action: @escaping () async -> Void) -> some View {
        PrimaryButton("Next", icon: "arrow.right", iconPosition: .trailing, action: action)
    }

    public static func back(action: @escaping () async -> Void) -> some View {
        PrimaryButton("Back", icon: "arrow.left", iconPosition: .leading, action: action)
    }

    public static func done(action: @escaping () async -> Void) -> some View {
        PrimaryButton("Done", icon: "checkmark", action: action)
            .primaryButtonColors(
                background: { isEnabled, _ in
                    isEnabled ? Color.green : Color.gray.opacity(0.3)
                },
                foreground: { _, _ in .white }
            )
    }
}

// MARK: - Preview

#Preview("Button Themes") {
    ScrollView {
        VStack(spacing: 20) {
            Text("Themes").font(.headline)

            PrimaryButton("Default Theme") {
                print("Default")
            }
            .primaryButtonTheme(PrimaryButtonTheme.default)

            PrimaryButton("Flat Theme") {
                print("Flat")
            }
            .primaryButtonTheme(PrimaryButtonTheme.flat)

            PrimaryButton("Rounded Theme") {
                print("Rounded")
            }
            .primaryButtonTheme(PrimaryButtonTheme.rounded)

            PrimaryButton("Outline Theme") {
                print("Outline")
            }
            .primaryButtonTheme(PrimaryButtonTheme.outline)

            PrimaryButton("Ghost Theme") {
                print("Ghost")
            }
            .primaryButtonTheme(PrimaryButtonTheme.ghost)

            Divider()

            Text("Preset Styles").font(.headline)

            PrimaryButton.save {
                print("Save")
            }

            PrimaryButton.delete {
                print("Delete")
            }

            PrimaryButton.submit {
                print("Submit")
            }

            PrimaryButton.next {
                print("Next")
            }

            Divider()

            Text("Color Variants").font(.headline)

            PrimaryButton.blue("Blue Button") {
                print("Blue")
            }

            PrimaryButton.green("Green Button") {
                print("Green")
            }

            PrimaryButton.purple("Purple Button") {
                print("Purple")
            }

            PrimaryButton.blueGradient("Blue Gradient") {
                print("Gradient")
            }

            PrimaryButton.sunsetGradient("Sunset Gradient") {
                print("Sunset")
            }
        }
        .padding()
    }
}