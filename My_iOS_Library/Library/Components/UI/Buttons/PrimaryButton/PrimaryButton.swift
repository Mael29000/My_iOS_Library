//
//  PrimaryButton.swift
//  My_iOS_Library
//
//  A highly customizable primary button with loading states, animations, and haptic feedback
//
//  Usage:
//  ```swift
//  PrimaryButton(
//      title: "Submit",
//      icon: "arrow.right",
//      action: { await submitForm() }
//  )
//  .primaryButtonStyle(.large)
//  ```
//
//  Customization:
//  - Size: Use `.primaryButtonStyle()` with .small, .medium, or .large
//  - Colors: Customize with `.accentColor()` or `.primaryButtonColors()`
//  - Loading: Automatically shows loading state for async actions
//  - Disabled: Use `.disabled()` to disable interaction
//
//  Dependencies: None
//  iOS Requirement: 15.0+
//

import SwiftUI
import UIKit

// MARK: - Primary Button

public struct PrimaryButton: View {
    // MARK: - Properties

    private let title: String
    private let icon: String?
    private let iconPosition: IconPosition
    private let action: () async -> Void

    @State private var isPressed = false
    @State private var isLoading = false
    @State private var hasCompletedAnimation = false

    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.primaryButtonStyle) private var style
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    public init(
        _ title: String,
        icon: String? = nil,
        iconPosition: IconPosition = .leading,
        action: @escaping () async -> Void
    ) {
        self.title = title
        self.icon = icon
        self.iconPosition = iconPosition
        self.action = action
    }

    // Sync action convenience initializer
    public init(
        _ title: String,
        icon: String? = nil,
        iconPosition: IconPosition = .leading,
        action: @escaping () -> Void
    ) {
        self.init(title, icon: icon, iconPosition: iconPosition) {
            action()
        }
    }

    // MARK: - Body

    public var body: some View {
        Button {
            Task {
                await performAction()
            }
        } label: {
            buttonContent
        }
        .buttonStyle(PrimaryButtonPressStyle(isPressed: $isPressed))
        .disabled(isLoading)
        .allowsHitTesting(!isLoading)
    }

    // MARK: - Subviews

    @ViewBuilder
    private var buttonContent: some View {
        ZStack {
            // Success checkmark animation
            if hasCompletedAnimation {
                Image(systemName: "checkmark")
                    .font(.system(size: style.fontSize, weight: .semibold))
                    .foregroundColor(style.foregroundColor(isEnabled, colorScheme))
                    .transition(.scale.combined(with: .opacity))
            } else {
                HStack(spacing: style.spacing) {
                    if iconPosition == .leading, let icon = icon, !isLoading {
                        iconView(icon)
                    }

                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor(isEnabled, colorScheme)))
                            .scaleEffect(0.8)
                    } else {
                        Text(title)
                            .font(.system(size: style.fontSize, weight: .semibold))
                            .foregroundColor(style.foregroundColor(isEnabled, colorScheme))
                    }

                    if iconPosition == .trailing, let icon = icon, !isLoading {
                        iconView(icon)
                    }
                }
                .opacity(hasCompletedAnimation ? 0 : 1)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: style.height)
        .background(backgroundView)
        .overlay(overlayView)
        .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
        .shadow(
            color: style.shadowColor(isEnabled, colorScheme),
            radius: isPressed ? 2 : 4,
            x: 0,
            y: isPressed ? 1 : 2
        )
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: hasCompletedAnimation)
    }

    @ViewBuilder
    private func iconView(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: style.iconSize, weight: .semibold))
            .foregroundColor(style.foregroundColor(isEnabled, colorScheme))
    }

    @ViewBuilder
    private var backgroundView: some View {
        if style.hasGradient {
            LinearGradient(
                colors: style.gradientColors(isEnabled, colorScheme),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            style.backgroundColor(isEnabled, colorScheme)
        }
    }

    @ViewBuilder
    private var overlayView: some View {
        if isPressed {
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(Color.black.opacity(0.1))
        }
    }

    // MARK: - Actions

    private func performAction() async {
        guard !isLoading else { return }

        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.prepare()
        impact.impactOccurred()

        // Start loading
        withAnimation(.easeInOut(duration: 0.2)) {
            isLoading = true
        }

        // Perform action
        await action()

        // Success animation
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isLoading = false
            hasCompletedAnimation = true
        }

        // Reset after delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        withAnimation(.easeOut(duration: 0.2)) {
            hasCompletedAnimation = false
        }
    }

    // MARK: - Types

    public enum IconPosition {
        case leading
        case trailing
    }
}

// MARK: - Button Style

private struct PrimaryButtonPressStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}

// MARK: - Style Configuration

public struct PrimaryButtonStyleConfiguration {
    public let size: PrimaryButtonSize
    public let height: CGFloat
    public let fontSize: CGFloat
    public let iconSize: CGFloat
    public let spacing: CGFloat
    public let cornerRadius: CGFloat
    public let hasGradient: Bool

    // Color configuration
    public let backgroundColor: (Bool, ColorScheme) -> Color
    public let foregroundColor: (Bool, ColorScheme) -> Color
    public let gradientColors: (Bool, ColorScheme) -> [Color]
    public let shadowColor: (Bool, ColorScheme) -> Color

    // Default configurations
    public static let small = PrimaryButtonStyleConfiguration(
        size: .small,
        height: 36,
        fontSize: 14,
        iconSize: 14,
        spacing: 6,
        cornerRadius: 8,
        hasGradient: false,
        backgroundColor: defaultBackgroundColor,
        foregroundColor: defaultForegroundColor,
        gradientColors: defaultGradientColors,
        shadowColor: defaultShadowColor
    )

    public static let medium = PrimaryButtonStyleConfiguration(
        size: .medium,
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

    public static let large = PrimaryButtonStyleConfiguration(
        size: .large,
        height: 52,
        fontSize: 18,
        iconSize: 20,
        spacing: 10,
        cornerRadius: 12,
        hasGradient: false,
        backgroundColor: defaultBackgroundColor,
        foregroundColor: defaultForegroundColor,
        gradientColors: defaultGradientColors,
        shadowColor: defaultShadowColor
    )

    // Color defaults
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
}

public enum PrimaryButtonSize {
    case small
    case medium
    case large
}

// MARK: - Environment Values

private struct PrimaryButtonStyleKey: EnvironmentKey {
    static let defaultValue = PrimaryButtonStyleConfiguration.medium
}

extension EnvironmentValues {
    var primaryButtonStyle: PrimaryButtonStyleConfiguration {
        get { self[PrimaryButtonStyleKey.self] }
        set { self[PrimaryButtonStyleKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    public func primaryButtonStyle(_ size: PrimaryButtonSize) -> some View {
        let configuration: PrimaryButtonStyleConfiguration
        switch size {
        case .small:
            configuration = .small
        case .medium:
            configuration = .medium
        case .large:
            configuration = .large
        }
        return environment(\.primaryButtonStyle, configuration)
    }

    public func primaryButtonStyle(_ configuration: PrimaryButtonStyleConfiguration) -> some View {
        environment(\.primaryButtonStyle, configuration)
    }
}

// MARK: - Custom Color Configuration

extension PrimaryButton {
    public func primaryButtonColors(
        background: @escaping (Bool, ColorScheme) -> Color,
        foreground: @escaping (Bool, ColorScheme) -> Color
    ) -> some View {
        let config = PrimaryButtonStyleConfiguration(
            size: style.size,
            height: style.height,
            fontSize: style.fontSize,
            iconSize: style.iconSize,
            spacing: style.spacing,
            cornerRadius: style.cornerRadius,
            hasGradient: style.hasGradient,
            backgroundColor: background,
            foregroundColor: foreground,
            gradientColors: style.gradientColors,
            shadowColor: style.shadowColor
        )
        return environment(\.primaryButtonStyle, config)
    }

    public func primaryButtonGradient(
        _ colors: @escaping (Bool, ColorScheme) -> [Color]
    ) -> some View {
        let config = PrimaryButtonStyleConfiguration(
            size: style.size,
            height: style.height,
            fontSize: style.fontSize,
            iconSize: style.iconSize,
            spacing: style.spacing,
            cornerRadius: style.cornerRadius,
            hasGradient: true,
            backgroundColor: style.backgroundColor,
            foregroundColor: style.foregroundColor,
            gradientColors: colors,
            shadowColor: style.shadowColor
        )
        return environment(\.primaryButtonStyle, config)
    }
}

// MARK: - Preview

#Preview("Primary Button Sizes") {
    VStack(spacing: 20) {
        PrimaryButton("Small Button", icon: "arrow.right") {
            print("Small tapped")
        }
        .primaryButtonStyle(PrimaryButtonSize.small)

        PrimaryButton("Medium Button", icon: "checkmark") {
            print("Medium tapped")
        }
        .primaryButtonStyle(PrimaryButtonSize.medium)

        PrimaryButton("Large Button", icon: "plus", iconPosition: .trailing) {
            print("Large tapped")
        }
        .primaryButtonStyle(PrimaryButtonSize.large)

        PrimaryButton("Async Action") {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            print("Async completed")
        }
        .primaryButtonStyle(PrimaryButtonSize.large)

        PrimaryButton("Disabled Button") {
            print("Should not print")
        }
        .disabled(true)

        PrimaryButton("Gradient Button") {
            print("Gradient tapped")
        }
        .primaryButtonGradient { _, _ in
            [.blue, .purple]
        }
    }
    .padding()
}

#Preview("Dark Mode") {
    VStack(spacing: 20) {
        PrimaryButton("Primary Action", icon: "arrow.right") {
            print("Action")
        }

        PrimaryButton("Secondary Action") {
            print("Action")
        }
        .disabled(true)
    }
    .padding()
    .preferredColorScheme(.dark)
}