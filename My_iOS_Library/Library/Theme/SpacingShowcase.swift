//
//  SpacingShowcase.swift
//  My_iOS_Library
//
//  Demonstration view for the spacing system
//

import SwiftUI

struct SpacingShowcase: View {
    @Environment(\.spacing) private var spacing
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: spacing.xl) {
                // Header
                VStack(spacing: spacing.sm) {
                    Text("Spacing System")
                        .style(.title)

                    Text("Consistent spacing throughout your app")
                        .style(.body2)
                }
                .padding(.top, spacing.lg)

                // Spacing Values
                SpacingValuesSection()

                // Visual Examples
                VisualExamplesSection()

                // Padding Examples
                PaddingExamplesSection()

                // Stack Examples
                StackExamplesSection()

                // Real World Examples
                RealWorldExamplesSection()
            }
            .padding(.horizontal, spacing.lg)
            .padding(.bottom, spacing.xxl)
        }
        .backgroundStyle(.primary)
    }
}

// MARK: - Spacing Values Section

struct SpacingValuesSection: View {
    @Environment(\.spacing) private var spacing
    @Environment(\.theme) private var theme

    private let spacingSizes: [(String, SpacingSize, String)] = [
        ("none", .none, "0"),
        ("xxs", .xxs, "2"),
        ("xs", .xs, "4"),
        ("sm", .sm, "8"),
        ("md", .md, "12"),
        ("lg", .lg, "16"),
        ("xl", .xl, "24"),
        ("xxl", .xxl, "32"),
        ("xxxl", .xxxl, "40"),
        ("xxxxl", .xxxxl, "48")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("Spacing Values")
                .style(.heading2)

            VStack(spacing: spacing.sm) {
                ForEach(spacingSizes, id: \.0) { name, size, value in
                    SpacingRow(name: name, size: size, value: value)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Spacing Row

struct SpacingRow: View {
    @Environment(\.spacing) private var spacing
    @Environment(\.theme) private var theme

    let name: String
    let size: SpacingSize
    let value: String

    var body: some View {
        HStack(spacing: spacing.lg) {
            // Name
            Text(".\(name)")
                .style(.body1)
                .font(.system(.body, design: .monospaced))
                .frame(width: 60, alignment: .leading)

            // Value
            Text("\(value)pt")
                .style(.caption)
                .frame(width: 40, alignment: .trailing)

            // Visual representation
            HStack(spacing: 0) {
                Rectangle()
                    .fill(theme.primaryColor)
                    .frame(width: spacingValue(size), height: 32)

                Rectangle()
                    .fill(theme.primaryColor.opacity(0.3))
                    .frame(width: 2, height: 32)
            }

            Spacer()
        }
    }

    private func spacingValue(_ size: SpacingSize) -> CGFloat {
        switch size {
        case .none: return spacing.none
        case .xxs: return spacing.xxs
        case .xs: return spacing.xs
        case .sm: return spacing.sm
        case .md: return spacing.md
        case .lg: return spacing.lg
        case .xl: return spacing.xl
        case .xxl: return spacing.xxl
        case .xxxl: return spacing.xxxl
        case .xxxxl: return spacing.xxxxl
        case .custom(let value): return value
        }
    }
}

// MARK: - Visual Examples Section

struct VisualExamplesSection: View {
    @Environment(\.spacing) private var spacing
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("Visual Examples")
                .style(.heading2)

            // Grid of boxes with different spacing
            VStack(alignment: .leading, spacing: spacing.md) {
                Text("Icon Grid")
                    .style(.body2)

                HStack(spacing: spacing.sm) {
                    ForEach(0..<4) { _ in
                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.surfaceSecondary)
                            .frame(width: 44, height: 44)
                            .overlay(
                                Image(systemName: "star.fill")
                                    .foregroundColor(theme.primaryColor)
                            )
                    }
                }

                Text("Card Grid")
                    .style(.body2)

                VStack(spacing: spacing.md) {
                    ForEach(0..<3) { index in
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(theme.primaryColor.opacity(0.2))
                                .frame(width: 60, height: 60)

                            VStack(alignment: .leading, spacing: spacing.xs) {
                                Text("Item \(index + 1)")
                                    .style(.body1)
                                    .fontWeight(.semibold)

                                Text("Description text")
                                    .style(.caption)
                            }

                            Spacer()
                        }
                        .padding(spacing.md)
                        .background(theme.surfaceColor)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(theme.borderColor, lineWidth: 1)
                        )
                    }
                }
            }
        }
    }
}

// MARK: - Padding Examples Section

struct PaddingExamplesSection: View {
    @Environment(\.spacing) private var spacing
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("Padding Examples")
                .style(.heading2)

            VStack(alignment: .leading, spacing: spacing.md) {
                // Small padding
                Text("Small Padding (.sm)")
                    .style(.body2)
                    .padding(.sm)
                    .background(theme.primaryColor.opacity(0.1))
                    .cornerRadius(8)

                // Medium padding
                Text("Medium Padding (.md)")
                    .style(.body2)
                    .padding(.md)
                    .background(theme.secondaryColor.opacity(0.1))
                    .cornerRadius(8)

                // Large padding
                Text("Large Padding (.lg)")
                    .style(.body2)
                    .padding(.lg)
                    .background(theme.successColor.opacity(0.1))
                    .cornerRadius(8)

                // Horizontal only
                Text("Horizontal Padding (.xl)")
                    .style(.body2)
                    .paddingHorizontal(.xl)
                    .padding(.vertical, spacing.sm)
                    .background(theme.warningColor.opacity(0.1))
                    .cornerRadius(8)

                // Vertical only
                Text("Vertical Padding (.xl)")
                    .style(.body2)
                    .paddingVertical(.xl)
                    .padding(.horizontal, spacing.sm)
                    .background(theme.infoColor.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}

// MARK: - Stack Examples Section

struct StackExamplesSection: View {
    @Environment(\.spacing) private var spacing
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("Stack Spacing")
                .style(.heading2)

            // VStack example
            VStack(alignment: .leading, spacing: spacing.md) {
                Text("VStack with .md spacing")
                    .style(.body2)

                VStackSpacing(spacing: .md) {
                    ForEach(0..<3) { index in
                        Text("Item \(index + 1)")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, spacing.sm)
                            .background(theme.surfaceSecondary)
                            .cornerRadius(6)
                    }
                }
            }

            // HStack example
            VStack(alignment: .leading, spacing: spacing.md) {
                Text("HStack with .lg spacing")
                    .style(.body2)

                HStackSpacing(spacing: .lg) {
                    ForEach(0..<3) { index in
                        VStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(theme.warningColor)
                            Text("Star \(index + 1)")
                                .style(.caption)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(spacing.md)
                        .background(theme.surfaceSecondary)
                        .cornerRadius(8)
                    }
                }
            }
        }
    }
}

// MARK: - Real World Examples Section

struct RealWorldExamplesSection: View {
    @Environment(\.spacing) private var spacing
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: spacing.lg) {
            Text("Real World Examples")
                .style(.heading2)

            // Settings row
            VStack(spacing: spacing.none) {
                SettingsRow(
                    icon: "moon.fill",
                    title: "Dark Mode",
                    value: "Auto"
                )

                Divider()
                    .padding(.leading, spacing.xxxxl)

                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    value: "On"
                )

                Divider()
                    .padding(.leading, spacing.xxxxl)

                SettingsRow(
                    icon: "globe",
                    title: "Language",
                    value: "English"
                )
            }
            .background(theme.surfaceColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(theme.borderColor, lineWidth: 1)
            )

            // Profile card
            ProfileCard()

            // Action buttons
            VStack(spacing: spacing.md) {
                Button(action: {}) {
                    Text("Primary Action")
                        .style(.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, spacing.lg)
                        .padding(.horizontal, spacing.xl)
                        .background(theme.primaryGradient)
                        .cornerRadius(12)
                }

                Button(action: {}) {
                    Text("Secondary Action")
                        .style(.button)
                        .foregroundColor(theme.primaryColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, spacing.lg)
                        .padding(.horizontal, spacing.xl)
                        .background(theme.surfaceSecondary)
                        .cornerRadius(12)
                }
            }
        }
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    @Environment(\.spacing) private var spacing
    @Environment(\.theme) private var theme

    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: spacing.md) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(theme.primaryColor)
                .frame(width: spacing.xl)

            Text(title)
                .style(.body1)

            Spacer()

            Text(value)
                .style(.body2)

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.textTertiary)
        }
        .padding(.vertical, spacing.md)
        .padding(.horizontal, spacing.lg)
    }
}

// MARK: - Profile Card

struct ProfileCard: View {
    @Environment(\.spacing) private var spacing
    @Environment(\.theme) private var theme

    var body: some View {
        HStack(spacing: spacing.lg) {
            // Avatar
            Circle()
                .fill(ThemeGradients.purpleDream)
                .frame(width: 60, height: 60)
                .overlay(
                    Text("JS")
                        .style(.heading3)
                        .foregroundColor(.white)
                )

            // Info
            VStack(alignment: .leading, spacing: spacing.xs) {
                Text("John Smith")
                    .style(.heading3)

                Text("Premium Member")
                    .style(.caption)

                HStack(spacing: spacing.sm) {
                    Label("1.2K", systemImage: "heart.fill")
                        .font(.caption)
                        .foregroundColor(theme.errorColor)

                    Label("842", systemImage: "eye.fill")
                        .font(.caption)
                        .foregroundStyle(.textSecondary)
                }
            }

            Spacer()
        }
        .padding(spacing.lg)
        .background(theme.surfaceColor)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(theme.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview("Spacing Showcase") {
    SpacingShowcase()
        .theme(DefaultTheme())
        .typography(DefaultTypography())
        .spacing(DefaultSpacing())
}