//
//  TypographyShowcase.swift
//  My_iOS_Library
//
//  Demonstration view for typography system
//

import SwiftUI

struct TypographyShowcase: View {
    @Environment(\.typography) private var typography
    @Environment(\.theme) private var theme

    private let sampleText = "The quick brown fox jumps over the lazy dog"
    private let sampleTextShort = "Typography"

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                // Header
                VStack(spacing: 8) {
                    Text("Typography Showcase")
                        .style(.title)

                    Text("All text styles in the design system")
                        .style(.body2)
                }
                .padding(.top)

                // Main text styles
                VStack(alignment: .leading, spacing: 24) {
                    TextStyleRow(
                        name: "Title",
                        style: .title,
                        sample: sampleTextShort
                    )

                    TextStyleRow(
                        name: "Heading 1",
                        style: .heading1,
                        sample: "Section Header"
                    )

                    TextStyleRow(
                        name: "Heading 2",
                        style: .heading2,
                        sample: "Subsection Header"
                    )

                    TextStyleRow(
                        name: "Heading 3",
                        style: .heading3,
                        sample: "Component Title"
                    )

                    Divider()

                    TextStyleRow(
                        name: "Body 1",
                        style: .body1,
                        sample: sampleText
                    )

                    TextStyleRow(
                        name: "Body 2",
                        style: .body2,
                        sample: sampleText
                    )

                    Divider()

                    TextStyleRow(
                        name: "Label 1",
                        style: .label1,
                        sample: "SMALL LABEL"
                    )

                    TextStyleRow(
                        name: "Label 2",
                        style: .label2,
                        sample: "TINY LABEL"
                    )

                    Divider()

                    TextStyleRow(
                        name: "Caption",
                        style: .caption,
                        sample: "Supporting text or metadata"
                    )

                    TextStyleRow(
                        name: "Button",
                        style: .button,
                        sample: "Call to Action"
                    )

                    TextStyleRow(
                        name: "Link",
                        style: .link,
                        sample: "Learn more"
                    )

                    TextStyleRow(
                        name: "Code",
                        style: .code,
                        sample: "let result = calculate()"
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // Usage Examples
                UsageSection()

                // Font Weights Demo
                FontWeightsSection()

                // Custom Font Info
                CustomFontSection()
            }
            .padding()
        }
        .backgroundStyle(.primary)
    }
}

// MARK: - Text Style Row

struct TextStyleRow: View {
    let name: String
    let style: TextStyle
    let sample: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(name)
                .style(.label1)
                .foregroundStyle(.textTertiary)

            Text(sample)
                .style(style)
        }
    }
}

// MARK: - Usage Section

struct UsageSection: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Usage Examples")
                .style(.heading2)

            // Card example
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .font(.title3)
                        .foregroundColor(theme.primaryColor)

                    Text("Document Title")
                        .style(.heading3)

                    Spacer()

                    Text("NEW")
                        .style(.label2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(theme.successColor.opacity(0.2))
                        .foregroundColor(theme.successColor)
                        .cornerRadius(4)
                }

                Text("This is an example of how different text styles work together in a typical card component.")
                    .style(.body2)

                HStack {
                    Text("Updated 2 hours ago")
                        .style(.caption)

                    Spacer()

                    Text("View Details")
                        .style(.link)
                }
            }
            .padding()
            .background(theme.surfaceColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(theme.borderColor, lineWidth: 1)
            )

            // Button examples
            VStack(spacing: 12) {
                Button(action: {}) {
                    Text("Primary Action")
                        .style(.button)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(theme.primaryGradient)
                        .cornerRadius(10)
                }

                Button(action: {}) {
                    HStack {
                        Text("Secondary Action")
                            .style(.button)

                        Image(systemName: "arrow.right")
                            .font(.caption)
                    }
                    .foregroundColor(theme.primaryColor)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.primaryColor.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
}

// MARK: - Font Weights Section

struct FontWeightsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Font Weights")
                .style(.heading2)

            Text("System font weights demonstration")
                .style(.body2)

            VStack(alignment: .leading, spacing: 8) {
                Text("Regular weight text")
                    .font(.body)
                    .fontWeight(.regular)

                Text("Medium weight text")
                    .font(.body)
                    .fontWeight(.medium)

                Text("Semibold weight text")
                    .font(.body)
                    .fontWeight(.semibold)

                Text("Bold weight text")
                    .font(.body)
                    .fontWeight(.bold)

                Text("Black weight text")
                    .font(.body)
                    .fontWeight(.black)
            }
            .foregroundStyle(.textPrimary)
        }
    }
}

// MARK: - Custom Font Section

struct CustomFontSection: View {
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Custom Fonts")
                .style(.heading2)

            VStack(alignment: .leading, spacing: 12) {
                Text("How to use custom fonts:")
                    .style(.body1)
                    .fontWeight(.semibold)

                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 12) {
                        Text("1.")
                            .style(.body1)
                            .foregroundColor(theme.primaryColor)
                            .fontWeight(.bold)

                        Text("Add font files (.ttf, .otf) to your project")
                            .style(.body2)
                    }

                    HStack(alignment: .top, spacing: 12) {
                        Text("2.")
                            .style(.body1)
                            .foregroundColor(theme.primaryColor)
                            .fontWeight(.bold)

                        Text("Add fonts to Info.plist under 'Fonts provided by application'")
                            .style(.body2)
                    }

                    HStack(alignment: .top, spacing: 12) {
                        Text("3.")
                            .style(.body1)
                            .foregroundColor(theme.primaryColor)
                            .fontWeight(.bold)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Create custom typography:")
                                .style(.body2)

                            Text("let customTypo = DefaultTypography(fontFamily: .inter)")
                                .style(.code)
                                .padding(8)
                                .background(theme.surfaceSecondary)
                                .cornerRadius(6)
                        }
                    }
                }
            }
            .padding()
            .background(theme.infoColor.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(theme.infoColor.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

// MARK: - Preview

#Preview("Typography Showcase") {
    TypographyShowcase()
        .theme(DefaultTheme())
        .typography(DefaultTypography())
}