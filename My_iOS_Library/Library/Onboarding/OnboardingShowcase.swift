//
//  OnboardingShowcase.swift
//  My_iOS_Library
//
//  Complete onboarding showcase with working previews
//

import SwiftUI

// MARK: - Onboarding Showcase

public struct OnboardingShowcase: View {
    @State private var selectedTab = 0
    @Environment(\.theme) private var theme

    public init() {}

    public var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                // Simple Preview
                SimplePreviewTab()
                    .tabItem {
                        Label("Simple", systemImage: "square.on.square")
                    }
                    .tag(0)

                // Modern Preview
                ModernPreviewTab()
                    .tabItem {
                        Label("Modern", systemImage: "sparkles")
                    }
                    .tag(1)

                // Illustrated Preview
                IllustratedPreviewTab()
                    .tabItem {
                        Label("Illustrated", systemImage: "paintpalette")
                    }
                    .tag(2)

                // All Styles
                AllStylesTab()
                    .tabItem {
                        Label("All Styles", systemImage: "square.grid.2x2")
                    }
                    .tag(3)
            }
            .navigationTitle("Onboarding Examples")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Simple Preview Tab

struct SimplePreviewTab: View {
    @State private var currentPage = 0
    @State private var showFullscreen = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Simple Onboarding")
                        .font(.title2)
                        .bold()

                    Text("Clean and minimalist onboarding flow perfect for most apps")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // Live Preview
                VStack {
                    // Mini onboarding
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.secondarySystemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)

                        VStack(spacing: 0) {
                            // Pages
                            TabView(selection: $currentPage) {
                                ForEach(0..<4) { index in
                                    SimplePagePreview(pageIndex: index)
                                        .tag(index)
                                }
                            }
                            .tabViewStyle(.page(indexDisplayMode: .never))
                            .frame(height: 350)

                            // Controls
                            VStack(spacing: 16) {
                                // Dots
                                HStack(spacing: 8) {
                                    ForEach(0..<4) { index in
                                        Circle()
                                            .fill(currentPage == index ? .blue : .gray.opacity(0.3))
                                            .frame(width: 8, height: 8)
                                    }
                                }

                                // Buttons
                                HStack(spacing: 12) {
                                    if currentPage < 3 {
                                        Button("Skip") {
                                            currentPage = 3
                                        }
                                        .foregroundColor(.gray)
                                    }

                                    Button(action: {
                                        if currentPage < 3 {
                                            withAnimation {
                                                currentPage += 1
                                            }
                                        } else {
                                            currentPage = 0
                                        }
                                    }) {
                                        Text(currentPage == 3 ? "Restart" : "Next")
                                            .font(.footnote.bold())
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 10)
                                            .background(Color.blue)
                                            .cornerRadius(8)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    .frame(height: 450)
                    .padding(.horizontal)
                }

                // Try Fullscreen Button
                Button(action: {
                    showFullscreen = true
                }) {
                    Label("Try Fullscreen", systemImage: "arrow.up.left.and.arrow.down.right")
                        .font(.body.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $showFullscreen) {
            SimpleOnboardingView(
                accentColor: .blue,
                onComplete: {
                    showFullscreen = false
                }
            )
        }
    }
}

// MARK: - Simple Page Preview

struct SimplePagePreview: View {
    let pageIndex: Int

    let pages = [
        ("star.fill", "Welcome", "Discover amazing features"),
        ("bell.badge.fill", "Notifications", "Stay updated with alerts"),
        ("lock.shield.fill", "Security", "Your data is protected"),
        ("hand.raised.fill", "Let's Go!", "Start your journey")
    ]

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: pages[pageIndex].0)
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text(pages[pageIndex].1)
                .font(.title3.bold())

            Text(pages[pageIndex].2)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
        }
    }
}

// MARK: - Modern Preview Tab

struct ModernPreviewTab: View {
    @State private var showTravel = false
    @State private var showFinance = false
    @State private var showFitness = false
    @State private var showSocial = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Modern Styles")
                        .font(.title2)
                        .bold()

                    Text("Professional onboarding inspired by top apps")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // Style Cards
                VStack(spacing: 16) {
                    ModernStyleCard(
                        title: "Travel Style",
                        subtitle: "Airbnb-inspired design",
                        color: Color(red: 255/255, green: 90/255, blue: 95/255),
                        icon: "airplane",
                        showFullscreen: $showTravel
                    )

                    ModernStyleCard(
                        title: "Finance Style",
                        subtitle: "Banking app design",
                        color: Color(red: 25/255, green: 33/255, blue: 56/255),
                        icon: "creditcard.fill",
                        showFullscreen: $showFinance
                    )

                    ModernStyleCard(
                        title: "Fitness Style",
                        subtitle: "Health & workout apps",
                        color: Color(red: 255/255, green: 45/255, blue: 85/255),
                        icon: "figure.run",
                        showFullscreen: $showFitness
                    )

                    ModernStyleCard(
                        title: "Social Style",
                        subtitle: "Social media inspired",
                        color: Color(red: 131/255, green: 58/255, blue: 180/255),
                        icon: "person.2.fill",
                        showFullscreen: $showSocial
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $showTravel) {
            ModernOnboardingView(
                pages: PremiumOnboarding.travelPages,
                onComplete: { showTravel = false }
            )
        }
        .fullScreenCover(isPresented: $showFinance) {
            ModernOnboardingView(
                pages: PremiumOnboarding.financePages,
                onComplete: { showFinance = false }
            )
        }
        .fullScreenCover(isPresented: $showFitness) {
            ModernOnboardingView(
                pages: PremiumOnboarding.fitnessPages,
                onComplete: { showFitness = false }
            )
        }
        .fullScreenCover(isPresented: $showSocial) {
            ModernOnboardingView(
                pages: PremiumOnboarding.socialPages,
                onComplete: { showSocial = false }
            )
        }
    }
}

// MARK: - Modern Style Card

struct ModernStyleCard: View {
    let title: String
    let subtitle: String
    let color: Color
    let icon: String
    @Binding var showFullscreen: Bool

    var body: some View {
        Button(action: {
            showFullscreen = true
        }) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(color)
                        .frame(width: 60, height: 60)

                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(color)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Illustrated Preview Tab

struct IllustratedPreviewTab: View {
    @State private var showFullscreen = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Illustrated Style")
                        .font(.title2)
                        .bold()

                    Text("Beautiful custom illustrations with animations")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // Preview
                Button(action: {
                    showFullscreen = true
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        VStack(spacing: 20) {
                            Image(systemName: "paintpalette.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.purple)

                            Text("Tap to View")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Text("See beautiful illustrated onboarding")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(40)
                    }
                    .frame(height: 300)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal)

                // Features
                VStack(alignment: .leading, spacing: 12) {
                    Text("Features:")
                        .font(.headline)

                    FeatureRow(icon: "wand.and.stars", text: "Custom animations")
                    FeatureRow(icon: "scribble.variable", text: "Unique shapes")
                    FeatureRow(icon: "paintbrush.pointed", text: "Gradient backgrounds")
                    FeatureRow(icon: "sparkles", text: "Smooth transitions")
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical)
        }
        .fullScreenCover(isPresented: $showFullscreen) {
            IllustratedOnboardingView(
                pages: IllustratedPage.samplePages,
                onComplete: { showFullscreen = false }
            )
        }
    }
}

// MARK: - Feature Row

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.blue)
                .frame(width: 30)

            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - All Styles Tab

struct AllStylesTab: View {
    @State private var showingGuide = false

    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("All Onboarding Styles")
                        .font(.title2)
                        .bold()

                    Text("Choose the perfect style for your app")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

                // Guide Button
                Button(action: {
                    showingGuide = true
                }) {
                    HStack {
                        Image(systemName: "book.fill")
                            .font(.body)

                        Text("Implementation Guide")
                            .font(.body.bold())

                        Spacer()

                        Image(systemName: "arrow.right")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                }
                .padding(.horizontal)

                // Style List
                VStack(alignment: .leading, spacing: 16) {
                    StyleInfoCard(
                        title: "Simple",
                        description: "Clean, minimalist design with smooth animations. Perfect for utility apps.",
                        bestFor: "Productivity, utilities, simple tools"
                    )

                    StyleInfoCard(
                        title: "Modern",
                        description: "Bold colors, full-screen pages, inspired by top apps like Airbnb and Uber.",
                        bestFor: "Consumer apps, marketplaces, social"
                    )

                    StyleInfoCard(
                        title: "Illustrated",
                        description: "Custom illustrations and shapes with playful animations.",
                        bestFor: "Creative apps, education, entertainment"
                    )

                    StyleInfoCard(
                        title: "Questionnaire",
                        description: "Collect user preferences to personalize the experience.",
                        bestFor: "Fitness, content platforms, personalized apps"
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showingGuide) {
            OnboardingGuideView()
        }
    }
}

// MARK: - Style Info Card

struct StyleInfoCard: View {
    let title: String
    let description: String
    let bestFor: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)

            Text(description)
                .font(.body)
                .foregroundColor(.secondary)

            HStack {
                Text("Best for:")
                    .font(.caption.bold())
                    .foregroundColor(.blue)

                Text(bestFor)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    OnboardingShowcase()
        .theme(DefaultTheme())
}