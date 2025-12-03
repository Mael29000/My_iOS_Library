//
//  Card.swift
//  My_iOS_Library
//
//  A versatile card container with shadows, customizable styling, and interactive variants
//
//  Usage:
//  ```swift
//  Card {
//      VStack {
//          Text("Card Content")
//      }
//  }
//  .cardStyle(.elevated)
//  ```
//
//  Customization:
//  - Styles: elevated, outlined, filled, neumorphic
//  - Corners: Customizable radius and specific corners
//  - Shadows: Multiple elevation levels
//  - Interaction: Tap actions and press effects
//
//  Dependencies: None
//  iOS Requirement: 15.0+
//

import SwiftUI
import UIKit

// MARK: - Card

public struct Card<Content: View>: View {
    // MARK: - Properties

    private let content: Content
    private let action: (() -> Void)?

    @State private var isPressed = false
    @Environment(\.cardStyle) private var style
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.isEnabled) private var isEnabled

    // MARK: - Initialization

    public init(
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.action = action
        self.content = content()
    }

    // MARK: - Body

    public var body: some View {
        Group {
            if action != nil {
                Button {
                    action?()
                    hapticFeedback()
                } label: {
                    cardContent
                }
                .buttonStyle(CardButtonStyle(isPressed: $isPressed))
                .disabled(!isEnabled)
            } else {
                cardContent
            }
        }
    }

    // MARK: - Card Content

    @ViewBuilder
    private var cardContent: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(backgroundView)
            .clipShape(RoundedRectangle(cornerRadius: style.cornerRadius))
            .overlay(overlayView)
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: shadowOffset.width,
                y: shadowOffset.height
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
    }

    // MARK: - Background

    @ViewBuilder
    private var backgroundView: some View {
        switch style.variant {
        case .elevated:
            style.backgroundColor(colorScheme)

        case .outlined:
            Color.clear

        case .filled:
            style.backgroundColor(colorScheme)

        case .neumorphic:
            neumorphicBackground

        case .glass:
            glassBackground

        case .gradient:
            gradientBackground
        }
    }

    @ViewBuilder
    private var neumorphicBackground: some View {
        RoundedRectangle(cornerRadius: style.cornerRadius)
            .fill(
                LinearGradient(
                    colors: [
                        style.backgroundColor(colorScheme).opacity(0.2),
                        style.backgroundColor(colorScheme)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.black.opacity(0.1)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }

    @ViewBuilder
    private var glassBackground: some View {
        ZStack {
            style.backgroundColor(colorScheme)
                .opacity(0.3)

            if #available(iOS 15.0, *) {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
        }
    }

    @ViewBuilder
    private var gradientBackground: some View {
        LinearGradient(
            colors: style.gradientColors ?? [style.backgroundColor(colorScheme)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Overlay

    @ViewBuilder
    private var overlayView: some View {
        switch style.variant {
        case .outlined:
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .strokeBorder(borderColor, lineWidth: style.borderWidth)

        case .neumorphic:
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                .blur(radius: 0.5)

        default:
            EmptyView()
        }
    }

    // MARK: - Styling Properties

    private var shadowColor: Color {
        if !isEnabled {
            return .clear
        }

        switch style.variant {
        case .elevated:
            return colorScheme == .dark
                ? Color.black.opacity(0.4)
                : Color.black.opacity(0.1)

        case .neumorphic:
            return isPressed
                ? Color.clear
                : (colorScheme == .dark ? Color.black.opacity(0.5) : Color.gray.opacity(0.4))

        default:
            return .clear
        }
    }

    private var shadowRadius: CGFloat {
        if isPressed {
            return style.elevation.shadowRadius * 0.5
        }
        return style.elevation.shadowRadius
    }

    private var shadowOffset: CGSize {
        if isPressed {
            return CGSize(
                width: style.elevation.shadowOffset.width * 0.5,
                height: style.elevation.shadowOffset.height * 0.5
            )
        }
        return style.elevation.shadowOffset
    }

    private var borderColor: Color {
        if !isEnabled {
            return Color.gray.opacity(0.2)
        }
        return style.borderColor ?? (colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.1))
    }

    // MARK: - Helpers

    private func hapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - Button Style

private struct CardButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}

// MARK: - Card Style Configuration

public struct CardStyleConfiguration {
    public enum Variant {
        case elevated
        case outlined
        case filled
        case neumorphic
        case glass
        case gradient
    }

    public struct Elevation {
        public let shadowRadius: CGFloat
        public let shadowOffset: CGSize

        public static let none = Elevation(shadowRadius: 0, shadowOffset: .zero)
        public static let low = Elevation(shadowRadius: 4, shadowOffset: CGSize(width: 0, height: 2))
        public static let medium = Elevation(shadowRadius: 8, shadowOffset: CGSize(width: 0, height: 4))
        public static let high = Elevation(shadowRadius: 16, shadowOffset: CGSize(width: 0, height: 8))
    }

    public let variant: Variant
    public let cornerRadius: CGFloat
    public let elevation: Elevation
    public let backgroundColor: (ColorScheme) -> Color
    public let borderColor: Color?
    public let borderWidth: CGFloat
    public let gradientColors: [Color]?

    // Predefined styles
    public static let elevated = CardStyleConfiguration(
        variant: .elevated,
        cornerRadius: 16,
        elevation: .medium,
        backgroundColor: { $0 == .dark ? Color(.systemGray6) : .white },
        borderColor: nil,
        borderWidth: 0,
        gradientColors: nil
    )

    public static let outlined = CardStyleConfiguration(
        variant: .outlined,
        cornerRadius: 16,
        elevation: .none,
        backgroundColor: { $0 == .dark ? Color(.systemGray6) : .white },
        borderColor: nil,
        borderWidth: 1,
        gradientColors: nil
    )

    public static let filled = CardStyleConfiguration(
        variant: .filled,
        cornerRadius: 16,
        elevation: .none,
        backgroundColor: { $0 == .dark ? Color(.systemGray5) : Color(.systemGray6) },
        borderColor: nil,
        borderWidth: 0,
        gradientColors: nil
    )

    public static let neumorphic = CardStyleConfiguration(
        variant: .neumorphic,
        cornerRadius: 20,
        elevation: .medium,
        backgroundColor: { $0 == .dark ? Color(.systemGray6) : Color(.systemGray6) },
        borderColor: nil,
        borderWidth: 0,
        gradientColors: nil
    )

    public static let glass = CardStyleConfiguration(
        variant: .glass,
        cornerRadius: 16,
        elevation: .low,
        backgroundColor: { _ in Color.white },
        borderColor: Color.white.opacity(0.2),
        borderWidth: 1,
        gradientColors: nil
    )
}

// MARK: - Environment Key

private struct CardStyleKey: EnvironmentKey {
    static let defaultValue = CardStyleConfiguration.elevated
}

extension EnvironmentValues {
    var cardStyle: CardStyleConfiguration {
        get { self[CardStyleKey.self] }
        set { self[CardStyleKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    public func cardStyle(_ style: CardStyleConfiguration) -> some View {
        environment(\.cardStyle, style)
    }

    public func cardStyle(_ variant: CardStyleConfiguration.Variant) -> some View {
        let configuration: CardStyleConfiguration
        switch variant {
        case .elevated:
            configuration = CardStyleConfiguration.elevated
        case .outlined:
            configuration = CardStyleConfiguration.outlined
        case .filled:
            configuration = CardStyleConfiguration.filled
        case .neumorphic:
            configuration = CardStyleConfiguration.neumorphic
        case .glass:
            configuration = CardStyleConfiguration.glass
        case .gradient:
            configuration = CardStyleConfiguration.elevated // Default gradient
        }
        return environment(\.cardStyle, configuration)
    }

    public func cardElevation(_ elevation: CardStyleConfiguration.Elevation) -> some View {
        self.modifier(CardElevationModifier(elevation: elevation))
    }

    public func cardCornerRadius(_ radius: CGFloat) -> some View {
        self.modifier(CardCornerRadiusModifier(radius: radius))
    }

    public func cardGradient(_ colors: [Color]) -> some View {
        self.modifier(CardGradientModifier(colors: colors))
    }
}

// MARK: - Modifiers

private struct CardElevationModifier: ViewModifier {
    let elevation: CardStyleConfiguration.Elevation
    @Environment(\.cardStyle) private var style

    func body(content: Content) -> some View {
        let modifiedStyle = style.with(elevation: elevation)
        return content.environment(\.cardStyle, modifiedStyle)
    }
}

private struct CardCornerRadiusModifier: ViewModifier {
    let radius: CGFloat
    @Environment(\.cardStyle) private var style

    func body(content: Content) -> some View {
        let modifiedStyle = style.with(cornerRadius: radius)
        return content.environment(\.cardStyle, modifiedStyle)
    }
}

private struct CardGradientModifier: ViewModifier {
    let colors: [Color]
    @Environment(\.cardStyle) private var style

    func body(content: Content) -> some View {
        let modifiedStyle = style
            .with(variant: .gradient)
            .with(gradientColors: colors)
        return content.environment(\.cardStyle, modifiedStyle)
    }
}

// MARK: - Convenience Initializers

extension Card where Content == AnyView {
    // Simple card with title and subtitle
    public static func simple(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        action: (() -> Void)? = nil
    ) -> Card {
        Card(action: action) {
            HStack(spacing: 16) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.accentColor)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                if action != nil {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .eraseToAnyView()
        }
    }

    // Info card with image
    public static func info(
        image: String,
        title: String,
        description: String,
        action: (() -> Void)? = nil
    ) -> Card {
        Card(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Image(systemName: image)
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)

                Text(title)
                    .font(.headline)

                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .eraseToAnyView()
        }
    }
}

// Helper to erase to AnyView
extension View {
    fileprivate func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: - Style Modification Helpers

extension CardStyleConfiguration {
    func with(elevation: Elevation) -> CardStyleConfiguration {
        CardStyleConfiguration(
            variant: variant,
            cornerRadius: cornerRadius,
            elevation: elevation,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            gradientColors: gradientColors
        )
    }

    func with(cornerRadius: CGFloat) -> CardStyleConfiguration {
        CardStyleConfiguration(
            variant: variant,
            cornerRadius: cornerRadius,
            elevation: elevation,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            gradientColors: gradientColors
        )
    }

    func with(variant: Variant) -> CardStyleConfiguration {
        CardStyleConfiguration(
            variant: variant,
            cornerRadius: cornerRadius,
            elevation: elevation,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            gradientColors: gradientColors
        )
    }

    func with(gradientColors: [Color]?) -> CardStyleConfiguration {
        CardStyleConfiguration(
            variant: variant,
            cornerRadius: cornerRadius,
            elevation: elevation,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
            gradientColors: gradientColors
        )
    }
}

// MARK: - Preview

#Preview("Card Styles") {
    ScrollView {
        VStack(spacing: 20) {
            Card {
                VStack {
                    Text("Elevated Card")
                    Text("Default style with shadow")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .cardStyle(CardStyleConfiguration.elevated)

            Card {
                VStack {
                    Text("Outlined Card")
                    Text("Border with no shadow")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .cardStyle(CardStyleConfiguration.outlined)

            Card {
                VStack {
                    Text("Filled Card")
                    Text("Solid background, no shadow")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .cardStyle(CardStyleConfiguration.filled)

            Card {
                VStack {
                    Text("Neumorphic Card")
                    Text("Soft UI design")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .cardStyle(CardStyleConfiguration.neumorphic)

            Card {
                VStack {
                    Text("Glass Card")
                    Text("Translucent material")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
            .cardStyle(CardStyleConfiguration.glass)

            Card {
                VStack {
                    Text("Gradient Card")
                    Text("Custom gradient background")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding()
            }
            .cardGradient([.blue, .purple])
        }
        .padding()
    }
}

#Preview("Interactive Cards") {
    VStack(spacing: 20) {
        Card(action: { print("Card tapped") }) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Tap me!")
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
        }

        Card.simple(
            title: "Settings",
            subtitle: "Configure your preferences",
            icon: "gear",
            action: { print("Settings tapped") }
        )

        Card.info(
            image: "exclamationmark.triangle.fill",
            title: "Important Notice",
            description: "This is a critical update that requires your attention.",
            action: { print("Notice tapped") }
        )
    }
    .padding()
}