//
//  FeaturesOnboarding.swift
//  My_iOS_Library
//
//  Features showcase style onboarding
//

import SwiftUI

// MARK: - Features Onboarding View

public struct FeaturesOnboardingView: View {
    @StateObject private var flow: BaseOnboardingFlow
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    private let features: [[OnboardingFeature]]
    private let appName: String
    private let appIcon: String?
    private let accentColor: Color

    public init(
        appName: String,
        appIcon: String? = nil,
        features: [[OnboardingFeature]],
        accentColor: Color = .blue,
        onComplete: (() -> Void)? = nil
    ) {
        self.appName = appName
        self.appIcon = appIcon
        self.features = features
        self.accentColor = accentColor

        let pages = features.enumerated().map { index, pageFeatures in
            FeaturesPage(
                pageNumber: index + 1,
                totalPages: features.count,
                features: pageFeatures,
                isLastPage: index == features.count - 1
            )
        }

        self._flow = StateObject(wrappedValue: BaseOnboardingFlow(
            pages: pages,
            onComplete: onComplete
        ))
    }

    public var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    accentColor.opacity(0.1),
                    theme.backgroundPrimary
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerView
                    .padding(.top, 60)
                    .padding(.horizontal)

                // Pages
                TabView(selection: $flow.currentPageIndex) {
                    ForEach(Array(flow.pages.enumerated()), id: \.offset) { index, page in
                        FeaturesPageView(
                            page: page as! FeaturesPage,
                            accentColor: accentColor
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(), value: flow.currentPageIndex)

                // Bottom Controls
                bottomControls
                    .padding(.horizontal)
                    .padding(.bottom, 50)
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 16) {
            // App Icon
            if let appIcon = appIcon {
                Image(appIcon)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(18)
            } else {
                RoundedRectangle(cornerRadius: 18)
                    .fill(accentColor.gradient)
                    .frame(width: 80, height: 80)
                    .overlay(
                        Text(String(appName.prefix(2)))
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    )
            }

            // App Name
            Text("Welcome to \(appName)")
                .font(theme.typography.title)
                .foregroundColor(theme.textPrimary)

            // Progress Indicator
            ProgressView(value: flow.progress)
                .progressViewStyle(LinearProgressViewStyle(tint: accentColor))
                .frame(height: 4)
                .scaleEffect(x: 1, y: 1.5)
                .padding(.horizontal, 40)
        }
    }

    private var bottomControls: some View {
        HStack {
            // Skip Button
            if !flow.isLastPage {
                Button(action: {
                    flow.skipOnboarding()
                }) {
                    Text("Skip")
                        .font(theme.typography.body1)
                        .foregroundColor(theme.textSecondary)
                }
            }

            Spacer()

            // Page Indicators
            HStack(spacing: 8) {
                ForEach(0..<flow.pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == flow.currentPageIndex ? accentColor : Color.secondary.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == flow.currentPageIndex ? 1.2 : 1.0)
                        .animation(.spring(), value: flow.currentPageIndex)
                }
            }

            Spacer()

            // Next/Get Started Button
            Button(action: {
                flow.nextPage()
            }) {
                Text(flow.isLastPage ? "Get Started" : "Next")
                    .font(theme.typography.body1)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(accentColor)
                    .cornerRadius(25)
            }
        }
    }
}

// MARK: - Features Page Model

struct FeaturesPage: OnboardingPageProtocol {
    let id = UUID().uuidString
    let title = ""
    let subtitle: String? = nil
    let imageName: String? = nil
    let systemImageName: String? = nil
    let backgroundColor: Color? = nil
    let primaryAction: OnboardingAction? = nil
    let secondaryAction: OnboardingAction? = nil

    let pageNumber: Int
    let totalPages: Int
    let features: [OnboardingFeature]
    let isLastPage: Bool
}

// MARK: - Features Page View

struct FeaturesPageView: View {
    @Environment(\.theme) private var theme
    let page: FeaturesPage
    let accentColor: Color

    var body: some View {
        VStack(spacing: 32) {
            // Page Title
            VStack(spacing: 8) {
                if page.pageNumber == 1 {
                    Text("Key Features")
                        .font(theme.typography.heading1)
                        .foregroundColor(theme.textPrimary)

                    Text("Everything you need to get started")
                        .font(theme.typography.body1)
                        .foregroundColor(theme.textSecondary)
                } else if page.isLastPage {
                    Text("Ready to Begin!")
                        .font(theme.typography.heading1)
                        .foregroundColor(theme.textPrimary)

                    Text("Let's set up your account")
                        .font(theme.typography.body1)
                        .foregroundColor(theme.textSecondary)
                } else {
                    Text("More Features")
                        .font(theme.typography.heading1)
                        .foregroundColor(theme.textPrimary)

                    Text("Discover what else you can do")
                        .font(theme.typography.body1)
                        .foregroundColor(theme.textSecondary)
                }
            }
            .padding(.top, 40)

            // Features List
            VStack(spacing: 24) {
                ForEach(page.features) { feature in
                    OnboardingFeatureRow(feature: feature)
                }
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}

// MARK: - Onboarding Feature Row

struct OnboardingFeatureRow: View {
    @Environment(\.theme) private var theme
    let feature: OnboardingFeature

    var body: some View {
        HStack(spacing: 20) {
            // Icon
            ZStack {
                Circle()
                    .fill(feature.iconColor.opacity(0.15))
                    .frame(width: 60, height: 60)

                Image(systemName: feature.icon)
                    .font(.title2)
                    .foregroundColor(feature.iconColor)
            }

            // Text
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(theme.typography.heading3)
                    .foregroundColor(theme.textPrimary)

                Text(feature.description)
                    .font(theme.typography.body2)
                    .foregroundColor(theme.textSecondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.08))
        .cornerRadius(16)
    }
}

// MARK: - Sample Features

public extension OnboardingFeature {
    static let sampleFeatures: [[OnboardingFeature]] = [
        // Page 1
        [
            OnboardingFeature(
                icon: "bell.badge",
                iconColor: .blue,
                title: "Smart Notifications",
                description: "Get notified about what matters most to you"
            ),
            OnboardingFeature(
                icon: "chart.line.uptrend.xyaxis",
                iconColor: .green,
                title: "Analytics & Insights",
                description: "Track your progress with detailed analytics"
            ),
            OnboardingFeature(
                icon: "lock.shield",
                iconColor: .purple,
                title: "Privacy First",
                description: "Your data is encrypted and secure"
            )
        ],
        // Page 2
        [
            OnboardingFeature(
                icon: "person.2",
                iconColor: .orange,
                title: "Collaboration",
                description: "Work together with your team seamlessly"
            ),
            OnboardingFeature(
                icon: "wand.and.stars",
                iconColor: .pink,
                title: "AI-Powered",
                description: "Smart suggestions to boost productivity"
            ),
            OnboardingFeature(
                icon: "icloud.and.arrow.up",
                iconColor: .cyan,
                title: "Cloud Sync",
                description: "Access your data from anywhere"
            )
        ],
        // Page 3
        [
            OnboardingFeature(
                icon: "paintbrush",
                iconColor: .indigo,
                title: "Customizable",
                description: "Make it yours with themes and settings"
            ),
            OnboardingFeature(
                icon: "bolt.fill",
                iconColor: .yellow,
                title: "Lightning Fast",
                description: "Optimized for the best performance"
            )
        ]
    ]
}