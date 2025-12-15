//
//  SimpleOnboarding.swift
//  My_iOS_Library
//
//  Simple and clean onboarding with working preview
//

import SwiftUI

// MARK: - Simple Onboarding View

public struct SimpleOnboardingView: View {
    @State private var currentPage = 0
    @Environment(\.dismiss) private var dismiss

    let pages: [OnboardingPageContent]
    let accentColor: Color
    let onComplete: (() -> Void)?

    public init(
        pages: [OnboardingPageContent]? = nil,
        accentColor: Color = .blue,
        onComplete: (() -> Void)? = nil
    ) {
        self.pages = pages ?? OnboardingPageContent.defaultPages
        self.accentColor = accentColor
        self.onComplete = onComplete
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Pages
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(
                        content: pages[index],
                        accentColor: accentColor
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Bottom controls
            VStack(spacing: 20) {
                // Page dots
                HStack(spacing: 8) {
                    ForEach(pages.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? accentColor : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(), value: currentPage)
                    }
                }

                // Buttons
                HStack(spacing: 16) {
                    // Skip button
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            complete()
                        }
                        .font(.body)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                    }

                    // Next/Get Started button
                    Button(action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            complete()
                        }
                    }) {
                        Text(currentPage == pages.count - 1 ? "Get Started" : "Next")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(accentColor)
                            .cornerRadius(12)
                    }
                    .frame(maxWidth: currentPage < pages.count - 1 ? .infinity : nil)
                }
                .padding(.horizontal, 24)
            }
            .padding(.vertical, 30)
            .background(Color(UIColor.systemBackground))
        }
        .background(Color(UIColor.secondarySystemBackground))
    }

    private func complete() {
        onComplete?()
        dismiss()
    }
}

// MARK: - Onboarding Page View

struct OnboardingPageView: View {
    let content: OnboardingPageContent
    let accentColor: Color

    @State private var animateContent = false

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Image/Icon
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.1))
                    .frame(width: 200, height: 200)
                    .scaleEffect(animateContent ? 1 : 0.8)

                Image(systemName: content.icon)
                    .font(.system(size: 80))
                    .foregroundColor(accentColor)
                    .scaleEffect(animateContent ? 1 : 0.5)
            }
            .padding(.bottom, 20)

            // Text content
            VStack(spacing: 16) {
                Text(content.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .offset(y: animateContent ? 0 : 20)
                    .opacity(animateContent ? 1 : 0)

                Text(content.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .offset(y: animateContent ? 0 : 20)
                    .opacity(animateContent ? 1 : 0)
            }

            Spacer()
            Spacer()
        }
        .padding()
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                animateContent = true
            }
        }
        .onDisappear {
            animateContent = false
        }
    }
}

// MARK: - Onboarding Page Content

public struct OnboardingPageContent {
    let icon: String
    let title: String
    let description: String

    public init(icon: String, title: String, description: String) {
        self.icon = icon
        self.title = title
        self.description = description
    }

    public static let defaultPages = [
        OnboardingPageContent(
            icon: "star.fill",
            title: "Welcome",
            description: "Discover amazing features that will help you get the most out of our app"
        ),
        OnboardingPageContent(
            icon: "bell.badge.fill",
            title: "Stay Updated",
            description: "Get notifications about important updates and never miss what matters to you"
        ),
        OnboardingPageContent(
            icon: "lock.shield.fill",
            title: "Secure & Private",
            description: "Your data is protected with industry-leading security measures"
        ),
        OnboardingPageContent(
            icon: "hand.raised.fill",
            title: "Ready to Start",
            description: "You're all set! Let's begin your journey with us"
        )
    ]
}

// MARK: - Inline Onboarding Demo

public struct InlineOnboardingDemo: View {
    @State private var showingFullscreen = false
    @State private var currentPage = 0

    public var body: some View {
        VStack(spacing: 20) {
            Text("Onboarding Preview")
                .font(.headline)

            // Mini onboarding preview
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(OnboardingPageContent.defaultPages.indices, id: \.self) { index in
                        MiniOnboardingPage(
                            content: OnboardingPageContent.defaultPages[index]
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 400)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            }
            .padding(.horizontal)

            // Control buttons
            VStack(spacing: 12) {
                // Page indicator
                HStack(spacing: 8) {
                    ForEach(OnboardingPageContent.defaultPages.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? .blue : Color.gray.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }

                // Launch fullscreen button
                Button(action: {
                    showingFullscreen = true
                }) {
                    Label("View Fullscreen", systemImage: "arrow.up.left.and.arrow.down.right")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .fullScreenCover(isPresented: $showingFullscreen) {
            SimpleOnboardingView()
        }
    }
}

// MARK: - Mini Page for Preview

struct MiniOnboardingPage: View {
    let content: OnboardingPageContent

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Icon
            Image(systemName: content.icon)
                .font(.system(size: 50))
                .foregroundColor(.blue)

            // Title
            Text(content.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            // Description
            Text(content.description)
                .font(.footnote)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Spacer()
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    InlineOnboardingDemo()
}