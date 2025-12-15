//
//  ThemeShowcase.swift
//  My_iOS_Library
//
//  Demonstration view for all theme colors and gradients
//

import SwiftUI

struct ThemeShowcase: View {
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                VStack(spacing: 8) {
                    Text("Theme Showcase")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.textPrimary)

                    Text("All colors and gradients in one place")
                        .font(.subheadline)
                        .foregroundStyle(.textSecondary)
                }
                .padding(.top)

                // Core Colors
                ColorSection(
                    title: "Core Colors",
                    colors: [
                        ("Primary", theme.primaryColor),
                        ("Secondary", theme.secondaryColor)
                    ]
                )

                // Text Colors
                ColorSection(
                    title: "Text Colors",
                    colors: [
                        ("Text Primary", theme.textPrimary),
                        ("Text Secondary", theme.textSecondary),
                        ("Text Tertiary", theme.textTertiary)
                    ]
                )

                // Semantic Colors
                ColorSection(
                    title: "Semantic Colors",
                    colors: [
                        ("Success", theme.successColor),
                        ("Error", theme.errorColor),
                        ("Warning", theme.warningColor),
                        ("Info", theme.infoColor)
                    ]
                )

                // Background Colors
                ColorSection(
                    title: "Background Colors",
                    colors: [
                        ("Primary", theme.backgroundPrimary),
                        ("Secondary", theme.backgroundSecondary),
                        ("Tertiary", theme.backgroundTertiary)
                    ]
                )

                // Surface Colors
                ColorSection(
                    title: "Surface Colors",
                    colors: [
                        ("Surface", theme.surfaceColor),
                        ("Surface Secondary", theme.surfaceSecondary)
                    ]
                )

                // Border Colors
                ColorSection(
                    title: "Border & Divider",
                    colors: [
                        ("Border", theme.borderColor),
                        ("Divider", theme.dividerColor)
                    ]
                )

                Divider()
                    .padding(.horizontal)

                // Gradients
                GradientSection()

                // Usage Examples
                UsageExamples()
            }
            .padding()
        }
        .backgroundStyle(.primary)
    }
}

// MARK: - Color Section

struct ColorSection: View {
    let title: String
    let colors: [(String, Color)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.textPrimary)

            VStack(spacing: 8) {
                ForEach(colors, id: \.0) { name, color in
                    ColorRow(name: name, color: color)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Color Row

struct ColorRow: View {
    let name: String
    let color: Color

    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 60, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(Color.gray.opacity(0.3), lineWidth: 1)
                )

            Text(name)
                .font(.subheadline)
                .foregroundStyle(.textPrimary)

            Spacer()
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Gradient Section

struct GradientSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Gradients")
                .font(.headline)
                .foregroundStyle(.textPrimary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                GradientCard(name: "Sunset", gradient: ThemeGradients.sunset)
                GradientCard(name: "Ocean", gradient: ThemeGradients.ocean)
                GradientCard(name: "Forest", gradient: ThemeGradients.forest)
                GradientCard(name: "Purple Dream", gradient: ThemeGradients.purpleDream)
                GradientCard(name: "Warm", gradient: ThemeGradients.warm)

                // Animated gradient
                VStack {
                    AnimatedGradient(colors: [
                        Color(hex: 0xFF006E),
                        Color(hex: 0x8B00FF),
                        Color(hex: 0x00D4FF)
                    ])
                    .frame(height: 80)
                    .cornerRadius(12)

                    Text("Animated")
                        .font(.caption)
                        .foregroundStyle(.textSecondary)
                }
            }
        }
    }
}

// MARK: - Gradient Card

struct GradientCard: View {
    let name: String
    let gradient: LinearGradient

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(gradient)
                .frame(height: 80)

            Text(name)
                .font(.caption)
                .foregroundStyle(.textSecondary)
        }
    }
}

// MARK: - Usage Examples

struct UsageExamples: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("Usage Examples")
                .font(.headline)
                .foregroundStyle(.textPrimary)

            // Example cards
            VStack(spacing: 16) {
                // Primary button example
                Button(action: {}) {
                    Text("Primary Button")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.primaryGradient)
                        .cornerRadius(12)
                }

                // Secondary button
                Button(action: {}) {
                    Text("Secondary Button")
                        .font(.headline)
                        .foregroundStyle(.textPrimary)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.surfaceSecondary)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(theme.borderColor, lineWidth: 1)
                        )
                }

                // Alert cards
                HStack(spacing: 12) {
                    AlertCard(
                        icon: "checkmark.circle.fill",
                        text: "Success",
                        color: theme.successColor
                    )

                    AlertCard(
                        icon: "xmark.circle.fill",
                        text: "Error",
                        color: theme.errorColor
                    )
                }

                // Gradient text
                Text("Beautiful Gradient Text")
                    .font(.title2.bold())
                    .gradientForeground(ThemeGradients.purpleDream)

                // Card with gradient background
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "star.fill")
                            .font(.title2)
                        Text("Premium Feature")
                            .font(.headline)
                    }
                    .foregroundColor(.white)

                    Text("This card uses our accent gradient")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(theme.accentGradient)
                .cornerRadius(16)
            }
        }
    }
}

// MARK: - Alert Card

struct AlertCard: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            Text(text)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

// MARK: - Preview

#Preview("Theme Showcase") {
    ThemeShowcase()
        .theme(DefaultTheme())
}