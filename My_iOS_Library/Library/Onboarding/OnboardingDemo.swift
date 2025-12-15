//
//  OnboardingDemo.swift
//  My_iOS_Library
//
//  Demo showcasing all onboarding styles
//

import SwiftUI

// MARK: - Onboarding Demo View

public struct OnboardingDemo: View {
    @State private var selectedStyle = OnboardingStyle.modernTravel
    @State private var showingOnboarding = false
    @State private var showingGuide = false
    @Environment(\.theme) private var theme

    enum OnboardingStyle: String, CaseIterable {
        case modernTravel = "Modern Travel"
        case modernFinance = "Modern Finance"
        case modernFitness = "Modern Fitness"
        case modernSocial = "Modern Social"
        case illustrated = "Illustrated"
        case features = "Features Classic"
        case questionnaire = "Questionnaire"

        var icon: String {
            switch self {
            case .modernTravel: return "airplane"
            case .modernFinance: return "creditcard.fill"
            case .modernFitness: return "figure.run"
            case .modernSocial: return "person.2.fill"
            case .illustrated: return "paintpalette.fill"
            case .features: return "star.fill"
            case .questionnaire: return "questionmark.circle.fill"
            }
        }

        var description: String {
            switch self {
            case .modernTravel:
                return "Airbnb-style onboarding with bold colors and travel theme"
            case .modernFinance:
                return "Professional finance app onboarding with trust and security focus"
            case .modernFitness:
                return "Energetic fitness app onboarding with motivational messaging"
            case .modernSocial:
                return "Social media style with gradients and community focus"
            case .illustrated:
                return "Beautiful illustrations with custom shapes and animations"
            case .features:
                return "Classic feature showcase with smooth page transitions"
            case .questionnaire:
                return "Collect user preferences to personalize their experience"
            }
        }
    }

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    headerSection

                    // Style Selection
                    styleSelectionSection

                    // Preview Section
                    previewSection

                    // Actions
                    actionsSection

                    // Reset Button
                    resetSection
                }
                .padding()
            }
            .navigationTitle("Onboarding Examples")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingGuide = true
                    }) {
                        Image(systemName: "info.circle")
                    }
                }
            }
            .sheet(isPresented: $showingGuide) {
                NavigationStack {
                    OnboardingGuideView()
                }
            }
            .fullScreenCover(isPresented: $showingOnboarding) {
                selectedOnboardingView
            }
        }
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Choose Your Onboarding Style")
                .font(theme.typography.heading2)
                .foregroundColor(theme.textPrimary)

            Text("Professional onboarding experiences for your app")
                .font(theme.typography.body2)
                .foregroundColor(theme.textSecondary)
        }
    }

    private var styleSelectionSection: some View {
        VStack(spacing: 12) {
            ForEach(OnboardingStyle.allCases, id: \.self) { style in
                StyleCard(
                    style: style,
                    isSelected: selectedStyle == style,
                    onTap: {
                        withAnimation(.spring()) {
                            selectedStyle = style
                        }
                    }
                )
            }
        }
    }

    private var previewSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preview")
                .font(theme.typography.heading3)
                .foregroundColor(theme.textPrimary)

            // Mock Preview based on selected style
            MockPreview(style: selectedStyle)
                .frame(height: 300)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }

    private var actionsSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                showingOnboarding = true
            }) {
                Label("Launch Onboarding", systemImage: "play.fill")
                    .font(theme.typography.body1)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(theme.primaryColor)
                    .cornerRadius(12)
            }

            Text("Will show in full screen mode")
                .font(theme.typography.label2)
                .foregroundColor(theme.textSecondary)
        }
    }

    private var resetSection: some View {
        Button(action: {
            OnboardingManager.shared.resetOnboarding()
        }) {
            Text("Reset Onboarding Status")
                .font(theme.typography.body2)
                .foregroundColor(theme.errorColor)
        }
        .padding(.top, 20)
    }

    // MARK: - Selected Onboarding View

    @ViewBuilder
    private var selectedOnboardingView: some View {
        switch selectedStyle {
        case .modernTravel:
            ModernOnboardingView(
                pages: PremiumOnboarding.travelPages,
                onComplete: {
                    showingOnboarding = false
                }
            )

        case .modernFinance:
            ModernOnboardingView(
                pages: PremiumOnboarding.financePages,
                onComplete: {
                    showingOnboarding = false
                }
            )

        case .modernFitness:
            ModernOnboardingView(
                pages: PremiumOnboarding.fitnessPages,
                onComplete: {
                    showingOnboarding = false
                }
            )

        case .modernSocial:
            ModernOnboardingView(
                pages: PremiumOnboarding.socialPages,
                onComplete: {
                    showingOnboarding = false
                }
            )

        case .illustrated:
            IllustratedOnboardingView(
                pages: IllustratedPage.samplePages,
                onComplete: {
                    showingOnboarding = false
                }
            )

        case .features:
            FeaturesOnboardingView(
                appName: "My App",
                features: OnboardingFeature.sampleFeatures,
                accentColor: theme.primaryColor,
                onComplete: {
                    showingOnboarding = false
                }
            )

        case .questionnaire:
            QuestionnaireOnboardingView(
                title: "Welcome",
                subtitle: "Let's personalize your experience",
                questions: OnboardingQuestion.sampleQuestions,
                accentColor: theme.primaryColor,
                onComplete: { responses in
                    print("Questionnaire completed with responses:", responses)
                    showingOnboarding = false
                }
            )
        }
    }
}

// MARK: - Style Card

struct StyleCard: View {
    @Environment(\.theme) private var theme
    let style: OnboardingDemo.OnboardingStyle
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    Circle()
                        .fill(isSelected ? theme.primaryColor.opacity(0.15) : Color.gray.opacity(0.1))
                        .frame(width: 50, height: 50)

                    Image(systemName: style.icon)
                        .font(.title3)
                        .foregroundColor(isSelected ? theme.primaryColor : .gray)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(style.rawValue)
                        .font(theme.typography.body1)
                        .foregroundColor(theme.textPrimary)

                    Text(style.description)
                        .font(theme.typography.body2)
                        .foregroundColor(theme.textSecondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                // Selection indicator
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(theme.primaryColor)
                    .opacity(isSelected ? 1 : 0)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? theme.primaryColor.opacity(0.05) : Color.gray.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                isSelected ? theme.primaryColor : Color.gray.opacity(0.2),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Mock Preview

struct MockPreview: View {
    @Environment(\.theme) private var theme
    let style: OnboardingDemo.OnboardingStyle

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [theme.primaryColor.opacity(0.3), theme.secondaryColor.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Content based on style
            VStack(spacing: 20) {
                Image(systemName: style.icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white)

                Text(style.rawValue)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)

                Text("Preview")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

// MARK: - Mock App Content

struct MockAppContent: View {
    @Environment(\.theme) private var theme

    var body: some View {
        NavigationStack {
            VStack {
                // Mock navigation bar
                HStack {
                    Text("My App")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Image(systemName: "plus")
                        .font(.title3)
                }
                .padding()

                // Mock content
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(0..<5) { _ in
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.secondary.opacity(0.1))
                                .frame(height: 100)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

// MARK: - Custom Onboarding Example

struct CustomOnboardingExample: View {
    @Environment(\.theme) private var theme
    let onComplete: () -> Void

    @State private var currentPage = 0

    var body: some View {
        ZStack {
            // Gradient Background
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.8),
                    Color.pink.opacity(0.8)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                // Content
                TabView(selection: $currentPage) {
                    // Page 1: Welcome
                    VStack(spacing: 30) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 80))
                            .foregroundColor(.white)

                        Text("Custom Onboarding")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                        Text("Create unique experiences")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .tag(0)

                    // Page 2: Features
                    VStack(spacing: 30) {
                        Image(systemName: "cube.transparent")
                            .font(.system(size: 80))
                            .foregroundColor(.white)

                        Text("Mix & Match")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                        Text("Combine different styles")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .tag(1)

                    // Page 3: Complete
                    VStack(spacing: 30) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.white)

                        Text("All Set!")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)

                        Button(action: onComplete) {
                            Text("Start Using App")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.purple)
                                .padding(.horizontal, 40)
                                .padding(.vertical, 16)
                                .background(Color.white)
                                .cornerRadius(30)
                        }
                    }
                    .tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
        }
    }
}

// MARK: - Onboarding Guide View

struct OnboardingGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Onboarding Implementation Guide")
                    .font(theme.typography.title)

                guideSection(
                    title: "Features Showcase",
                    content: """
                    Perfect for apps with distinct features to highlight:
                    • Visual feature presentation
                    • Progress tracking
                    • Smooth animations
                    • Customizable styling

                    Best for: Consumer apps, productivity tools, social platforms
                    """
                )

                guideSection(
                    title: "Interactive Tutorial",
                    content: """
                    Guide users through your interface:
                    • Contextual tooltips
                    • Highlighted areas
                    • Step-by-step instructions
                    • Action hints

                    Best for: Complex interfaces, professional tools, first-time features
                    """
                )

                guideSection(
                    title: "Questionnaire",
                    content: """
                    Personalize the experience from the start:
                    • Collect preferences
                    • Single/multiple choice questions
                    • Save responses for later use
                    • Progressive disclosure

                    Best for: Personalization-heavy apps, content platforms, fitness apps
                    """
                )

                guideSection(
                    title: "Implementation Tips",
                    content: """
                    1. Keep it brief - 3-5 screens maximum
                    2. Make it skippable
                    3. Show progress indicators
                    4. Use clear CTAs
                    5. Test with real users
                    6. Version your onboarding
                    7. Track completion rates
                    """
                )

                guideSection(
                    title: "Using OnboardingManager",
                    content: """
                    The OnboardingManager handles:
                    • Persistence with UserDefaults
                    • Version tracking
                    • Response storage
                    • Reset functionality

                    Check shouldShowOnboarding() on app launch
                    """
                )
            }
            .padding()
        }
        .navigationTitle("Implementation Guide")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }

    private func guideSection(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(theme.typography.heading2)

            Text(content)
                .font(theme.typography.body2)
                .foregroundColor(theme.textSecondary)
        }
    }
}

// MARK: - Preview

#Preview {
    OnboardingDemo()
        .theme(DefaultTheme())
        .typography(DefaultTypography())
        .spacing(DefaultSpacing())
}