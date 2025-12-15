//
//  ThemeAndTypographyShowcase.swift
//  My_iOS_Library
//
//  Combined showcase for theme colors and typography
//

import SwiftUI

struct ThemeAndTypographyShowcase: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ThemeShowcase()
                .tabItem {
                    Label("Colors", systemImage: "paintpalette.fill")
                }
                .tag(0)

            TypographyShowcase()
                .tabItem {
                    Label("Typography", systemImage: "textformat")
                }
                .tag(1)

            SpacingShowcase()
                .tabItem {
                    Label("Spacing", systemImage: "ruler")
                }
                .tag(2)

            CombinedExample()
                .tabItem {
                    Label("Examples", systemImage: "square.grid.2x2.fill")
                }
                .tag(3)
        }
    }
}

// MARK: - Combined Example

struct CombinedExample: View {
    @Environment(\.theme) private var theme
    @Environment(\.typography) private var typography

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Theme & Typography")
                        .style(.title)

                    Text("Real-world usage examples")
                        .style(.body2)
                }
                .padding(.top)

                // Feature Cards
                VStack(spacing: 16) {
                    FeatureCard(
                        icon: "star.fill",
                        iconColor: theme.warningColor,
                        title: "Premium Feature",
                        description: "Unlock advanced capabilities with our premium plan",
                        badge: "NEW",
                        badgeColor: theme.successColor,
                        gradient: ThemeGradients.warm
                    )

                    FeatureCard(
                        icon: "bolt.fill",
                        iconColor: theme.primaryColor,
                        title: "Lightning Fast",
                        description: "Experience blazing fast performance with optimized algorithms",
                        badge: "POPULAR",
                        badgeColor: theme.primaryColor,
                        gradient: ThemeGradients.ocean
                    )

                    FeatureCard(
                        icon: "shield.fill",
                        iconColor: theme.successColor,
                        title: "Secure & Private",
                        description: "Your data is protected with end-to-end encryption",
                        badge: nil,
                        badgeColor: .clear,
                        gradient: ThemeGradients.forest
                    )
                }

                // Stats Section
                StatsSection()

                // Action Buttons
                ActionButtonsSection()

                // Notification Examples
                NotificationExamples()
            }
            .padding()
        }
        .backgroundStyle(.primary)
    }
}

// MARK: - Feature Card

struct FeatureCard: View {
    @Environment(\.theme) private var theme

    let icon: String
    let iconColor: Color
    let title: String
    let description: String
    let badge: String?
    let badgeColor: Color
    let gradient: LinearGradient

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            RoundedRectangle(cornerRadius: 12)
                .fill(gradient)
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                )

            // Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title)
                        .style(.heading3)

                    if let badge = badge {
                        Text(badge)
                            .style(.label2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(badgeColor.opacity(0.2))
                            .foregroundColor(badgeColor)
                            .cornerRadius(4)
                    }

                    Spacer()
                }

                Text(description)
                    .style(.body2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .background(theme.surfaceColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(theme.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Stats Section

struct StatsSection: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Performance Metrics")
                .style(.heading2)

            HStack(spacing: 12) {
                StatCard(
                    value: "99.9%",
                    label: "Uptime",
                    trend: .up,
                    color: theme.successColor
                )

                StatCard(
                    value: "45ms",
                    label: "Response",
                    trend: .down,
                    color: theme.primaryColor
                )

                StatCard(
                    value: "2.3M",
                    label: "Requests",
                    trend: .up,
                    color: theme.secondaryColor
                )
            }
        }
    }
}

// MARK: - Stat Card

struct StatCard: View {
    @Environment(\.theme) private var theme

    let value: String
    let label: String
    let trend: Trend
    let color: Color

    enum Trend {
        case up, down

        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            }
        }

        var color: Color {
            switch self {
            case .up: return Color(hex: 0x34C759)
            case .down: return Color(hex: 0xFF3B30)
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Text(value)
                    .style(.heading2)
                    .foregroundColor(color)

                Image(systemName: trend.icon)
                    .font(.caption)
                    .foregroundColor(trend.color)
            }

            Text(label)
                .style(.caption)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(theme.surfaceSecondary)
        .cornerRadius(12)
    }
}

// MARK: - Action Buttons Section

struct ActionButtonsSection: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Actions")
                .style(.heading2)

            VStack(spacing: 12) {
                // Primary button with gradient
                Button(action: {}) {
                    HStack {
                        Image(systemName: "rocket.fill")
                        Text("Get Started")
                            .style(.button)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(ThemeGradients.purpleDream)
                    .cornerRadius(12)
                }

                // Secondary button
                Button(action: {}) {
                    Text("Learn More")
                        .style(.button)
                        .foregroundColor(theme.primaryColor)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.primaryColor.opacity(0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(theme.primaryColor, lineWidth: 2)
                        )
                }

                // Text button
                Button(action: {}) {
                    Text("Skip for now")
                        .style(.link)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
        }
    }
}

// MARK: - Notification Examples

struct NotificationExamples: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Notifications")
                .style(.heading2)

            VStack(spacing: 12) {
                NotificationCard(
                    icon: "checkmark.circle.fill",
                    title: "Success!",
                    message: "Your changes have been saved",
                    color: theme.successColor
                )

                NotificationCard(
                    icon: "exclamationmark.triangle.fill",
                    title: "Warning",
                    message: "You're approaching your storage limit",
                    color: theme.warningColor
                )

                NotificationCard(
                    icon: "xmark.circle.fill",
                    title: "Error",
                    message: "Unable to process your request",
                    color: theme.errorColor
                )

                NotificationCard(
                    icon: "info.circle.fill",
                    title: "Info",
                    message: "New features are now available",
                    color: theme.infoColor
                )
            }
        }
    }
}

// MARK: - Notification Card

struct NotificationCard: View {
    let icon: String
    let title: String
    let message: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title3)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .style(.body1)
                    .fontWeight(.semibold)

                Text(message)
                    .style(.caption)
            }

            Spacer()

            Image(systemName: "xmark")
                .font(.caption)
                .foregroundStyle(.textSecondary)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview("Combined Showcase") {
    ThemeAndTypographyShowcase()
        .theme(DefaultTheme())
        .typography(DefaultTypography())
        .spacing(DefaultSpacing())
}