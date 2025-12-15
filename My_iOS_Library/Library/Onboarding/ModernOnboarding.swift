//
//  ModernOnboarding.swift
//  My_iOS_Library
//
//  Modern professional onboarding like top apps
//

import SwiftUI

// MARK: - Modern Onboarding View

public struct ModernOnboardingView: View {
    @StateObject private var viewModel = ModernOnboardingViewModel()
    @Environment(\.dismiss) private var dismiss

    private let pages: [ModernOnboardingPage]
    private let primaryColor: Color
    private let onComplete: (() -> Void)?

    public init(
        pages: [ModernOnboardingPage],
        primaryColor: Color = .blue,
        onComplete: (() -> Void)? = nil
    ) {
        self.pages = pages
        self.primaryColor = primaryColor
        self.onComplete = onComplete
    }

    public var body: some View {
        ZStack {
            // Background color that changes with pages
            pages[viewModel.currentPage].backgroundColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: viewModel.currentPage)

            VStack(spacing: 0) {
                // Skip button
                HStack {
                    Spacer()

                    if viewModel.currentPage < pages.count - 1 {
                        Button(action: {
                            skip()
                        }) {
                            Text("Skip")
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .padding()
                        }
                    }
                }
                .padding(.top, 50)

                // Page content
                TabView(selection: $viewModel.currentPage) {
                    ForEach(pages.indices, id: \.self) { index in
                        ModernPageView(
                            page: pages[index],
                            isLastPage: index == pages.count - 1
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.spring(), value: viewModel.currentPage)

                // Bottom section
                VStack(spacing: 30) {
                    // Page indicator
                    PageIndicator(
                        numberOfPages: pages.count,
                        currentPage: viewModel.currentPage
                    )

                    // Action button
                    Button(action: {
                        if viewModel.currentPage < pages.count - 1 {
                            withAnimation(.spring()) {
                                viewModel.currentPage += 1
                            }
                        } else {
                            complete()
                        }
                    }) {
                        Text(viewModel.currentPage == pages.count - 1 ? "Get Started" : "Continue")
                            .font(.headline)
                            .foregroundColor(pages[viewModel.currentPage].buttonTextColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(pages[viewModel.currentPage].buttonColor)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.bottom, 50)
            }
        }
        .preferredColorScheme(pages[viewModel.currentPage].preferredColorScheme)
    }

    private func skip() {
        complete()
    }

    private func complete() {
        OnboardingManager.shared.markOnboardingCompleted(version: "1.0.0")
        onComplete?()
        dismiss()
    }
}

// MARK: - Modern Page View

struct ModernPageView: View {
    let page: ModernOnboardingPage
    let isLastPage: Bool

    @State private var animateContent = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Illustration or Image
            if let imageName = page.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .padding(.horizontal, 40)
                    .scaleEffect(animateContent ? 1 : 0.8)
                    .opacity(animateContent ? 1 : 0)
            } else if let systemImage = page.systemImageName {
                Image(systemName: systemImage)
                    .font(.system(size: 120, weight: .light))
                    .foregroundColor(page.iconColor)
                    .padding(40)
                    .scaleEffect(animateContent ? 1 : 0.8)
                    .opacity(animateContent ? 1 : 0)
            }

            Spacer()

            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(page.titleColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .offset(y: animateContent ? 0 : 30)
                    .opacity(animateContent ? 1 : 0)

                Text(page.subtitle)
                    .font(.system(size: 18))
                    .foregroundColor(page.subtitleColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .offset(y: animateContent ? 0 : 30)
                    .opacity(animateContent ? 1 : 0)
            }

            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.1)) {
                animateContent = true
            }
        }
        .onDisappear {
            animateContent = false
        }
    }
}

// MARK: - Page Indicator

struct PageIndicator: View {
    let numberOfPages: Int
    let currentPage: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<numberOfPages, id: \.self) { page in
                Capsule()
                    .fill(page == currentPage ? Color.white : Color.white.opacity(0.3))
                    .frame(width: page == currentPage ? 24 : 8, height: 8)
                    .animation(.spring(), value: currentPage)
            }
        }
    }
}

// MARK: - Modern Onboarding Page Model

public struct ModernOnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String?
    let systemImageName: String?
    let backgroundColor: Color
    let titleColor: Color
    let subtitleColor: Color
    let buttonColor: Color
    let buttonTextColor: Color
    let iconColor: Color
    let preferredColorScheme: ColorScheme?

    public init(
        title: String,
        subtitle: String,
        imageName: String? = nil,
        systemImageName: String? = nil,
        backgroundColor: Color,
        titleColor: Color = .white,
        subtitleColor: Color = .white.opacity(0.8),
        buttonColor: Color = .white,
        buttonTextColor: Color = .black,
        iconColor: Color = .white,
        preferredColorScheme: ColorScheme? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.systemImageName = systemImageName
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
        self.subtitleColor = subtitleColor
        self.buttonColor = buttonColor
        self.buttonTextColor = buttonTextColor
        self.iconColor = iconColor
        self.preferredColorScheme = preferredColorScheme
    }
}

// MARK: - View Model

@MainActor
class ModernOnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
}

// MARK: - Premium Onboarding Styles

public struct PremiumOnboarding {

    // Style 1: Travel App (like Airbnb)
    public static let travelPages = [
        ModernOnboardingPage(
            title: "Discover Amazing Places",
            subtitle: "Find unique accommodations and experiences around the world",
            systemImageName: "globe.americas",
            backgroundColor: Color(red: 255/255, green: 90/255, blue: 95/255),
            preferredColorScheme: .dark
        ),
        ModernOnboardingPage(
            title: "Book with Confidence",
            subtitle: "Secure payments, verified hosts, and 24/7 support for peace of mind",
            systemImageName: "checkmark.shield.fill",
            backgroundColor: Color(red: 0/255, green: 132/255, blue: 137/255),
            preferredColorScheme: .dark
        ),
        ModernOnboardingPage(
            title: "Create Memories",
            subtitle: "From cozy apartments to luxury villas, find your perfect stay",
            systemImageName: "heart.fill",
            backgroundColor: Color(red: 146/255, green: 90/255, blue: 183/255),
            preferredColorScheme: .dark
        )
    ]

    // Style 2: Finance App
    public static let financePages = [
        ModernOnboardingPage(
            title: "Your Money, Simplified",
            subtitle: "Track expenses, budgets, and investments all in one place",
            systemImageName: "chart.line.uptrend.xyaxis",
            backgroundColor: Color(red: 25/255, green: 33/255, blue: 56/255),
            iconColor: Color(red: 76/255, green: 217/255, blue: 100/255),
            preferredColorScheme: .dark
        ),
        ModernOnboardingPage(
            title: "Bank-Level Security",
            subtitle: "Your data is encrypted and protected with industry-leading security",
            systemImageName: "lock.shield.fill",
            backgroundColor: Color(red: 29/255, green: 41/255, blue: 81/255),
            iconColor: Color(red: 90/255, green: 200/255, blue: 250/255),
            preferredColorScheme: .dark
        ),
        ModernOnboardingPage(
            title: "Smart Insights",
            subtitle: "Get personalized recommendations to reach your financial goals",
            systemImageName: "lightbulb.fill",
            backgroundColor: Color(red: 34/255, green: 49/255, blue: 102/255),
            iconColor: Color(red: 255/255, green: 204/255, blue: 0/255),
            preferredColorScheme: .dark
        )
    ]

    // Style 3: Fitness App
    public static let fitnessPages = [
        ModernOnboardingPage(
            title: "Start Your Journey",
            subtitle: "Personalized workouts designed to help you reach your fitness goals",
            systemImageName: "figure.run",
            backgroundColor: Color(red: 255/255, green: 45/255, blue: 85/255),
            preferredColorScheme: .dark
        ),
        ModernOnboardingPage(
            title: "Track Progress",
            subtitle: "Monitor your workouts, calories, and see your improvement over time",
            systemImageName: "chart.xyaxis.line",
            backgroundColor: Color(red: 255/255, green: 149/255, blue: 0/255),
            preferredColorScheme: .dark
        ),
        ModernOnboardingPage(
            title: "Stay Motivated",
            subtitle: "Join challenges, earn achievements, and workout with friends",
            systemImageName: "trophy.fill",
            backgroundColor: Color(red: 88/255, green: 86/255, blue: 214/255),
            preferredColorScheme: .dark
        )
    ]

    // Style 4: Social Media App
    public static let socialPages = [
        ModernOnboardingPage(
            title: "Connect & Share",
            subtitle: "Share your moments with friends and discover what's happening around you",
            systemImageName: "person.2.fill",
            backgroundColor: LinearGradient(
                colors: [
                    Color(red: 131/255, green: 58/255, blue: 180/255),
                    Color(red: 253/255, green: 29/255, blue: 29/255),
                    Color(red: 252/255, green: 176/255, blue: 69/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).opacity(1).eraseToAnyView().backgroundColor ?? .purple,
            preferredColorScheme: .dark
        ),
        ModernOnboardingPage(
            title: "Express Yourself",
            subtitle: "Create stories, share photos, and show the world who you are",
            systemImageName: "camera.fill",
            backgroundColor: LinearGradient(
                colors: [
                    Color(red: 64/255, green: 93/255, blue: 230/255),
                    Color(red: 88/255, green: 81/255, blue: 219/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).opacity(1).eraseToAnyView().backgroundColor ?? .blue,
            preferredColorScheme: .dark
        ),
        ModernOnboardingPage(
            title: "Stay in Touch",
            subtitle: "Message friends, join communities, and never miss a moment",
            systemImageName: "bubble.left.and.bubble.right.fill",
            backgroundColor: LinearGradient(
                colors: [
                    Color(red: 20/255, green: 165/255, blue: 155/255),
                    Color(red: 43/255, green: 125/255, blue: 200/255)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ).opacity(1).eraseToAnyView().backgroundColor ?? .teal,
            preferredColorScheme: .dark
        )
    ]
}

// Extension to handle gradient backgrounds
extension View {
    var backgroundColor: Color? {
        if let color = self as? Color {
            return color
        }
        // For gradients, return a fallback color
        return nil
    }

    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}