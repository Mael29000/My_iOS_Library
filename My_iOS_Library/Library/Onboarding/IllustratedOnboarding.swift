//
//  IllustratedOnboarding.swift
//  My_iOS_Library
//
//  Beautiful illustrated onboarding with animations
//

import SwiftUI

// MARK: - Illustrated Onboarding View

public struct IllustratedOnboardingView: View {
    @State private var currentPage = 0
    @State private var showContent = false
    @Environment(\.dismiss) private var dismiss

    private let pages: [IllustratedPage]
    private let onComplete: (() -> Void)?

    public init(
        pages: [IllustratedPage],
        onComplete: (() -> Void)? = nil
    ) {
        self.pages = pages
        self.onComplete = onComplete
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Content area
                    TabView(selection: $currentPage) {
                        ForEach(pages.indices, id: \.self) { index in
                            IllustratedPageView(
                                page: pages[index],
                                geometry: geometry
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.spring(), value: currentPage)

                    // Bottom section
                    bottomSection
                        .padding(.horizontal, 24)
                        .padding(.bottom, 50)
                }

                // Skip button
                if currentPage < pages.count - 1 {
                    VStack {
                        HStack {
                            Spacer()
                            Button("Skip") {
                                complete()
                            }
                            .foregroundColor(.gray)
                            .padding()
                        }
                        .padding(.top, 50)

                        Spacer()
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
        }
    }

    private var bottomSection: some View {
        VStack(spacing: 24) {
            // Page indicator
            HStack(spacing: 8) {
                ForEach(pages.indices, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.black : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                        .scaleEffect(index == currentPage ? 1.2 : 1.0)
                        .animation(.spring(), value: currentPage)
                }
            }

            // Action buttons
            if currentPage == pages.count - 1 {
                // Last page
                Button(action: complete) {
                    Text("Start Using App")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.black)
                        .cornerRadius(16)
                }
            } else {
                // Other pages
                HStack(spacing: 16) {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.spring()) {
                                currentPage -= 1
                            }
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20))
                                .foregroundColor(.black)
                                .frame(width: 56, height: 56)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(16)
                        }
                    }

                    Spacer()

                    Button(action: {
                        withAnimation(.spring()) {
                            currentPage += 1
                        }
                    }) {
                        HStack {
                            Text("Next")
                                .font(.system(size: 18, weight: .semibold))
                            Image(systemName: "arrow.right")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .frame(height: 56)
                        .background(Color.black)
                        .cornerRadius(16)
                    }
                }
            }
        }
    }

    private func complete() {
        OnboardingManager.shared.markOnboardingCompleted(version: "1.0.0")
        onComplete?()
        dismiss()
    }
}

// MARK: - Illustrated Page View

struct IllustratedPageView: View {
    let page: IllustratedPage
    let geometry: GeometryProxy

    @State private var animateElements = false

    var body: some View {
        VStack(spacing: 0) {
            // Illustration area
            ZStack {
                // Background shape
                page.backgroundShape
                    .fill(page.backgroundColor.gradient)
                    .frame(height: geometry.size.height * 0.6)
                    .scaleEffect(animateElements ? 1 : 0.8)
                    .opacity(animateElements ? 1 : 0)

                // Illustration elements
                VStack {
                    Spacer()

                    if let illustration = page.illustration {
                        illustration
                            .scaleEffect(animateElements ? 1 : 0.8)
                            .opacity(animateElements ? 1 : 0)
                            .offset(y: animateElements ? 0 : 50)
                    }

                    Spacer()
                }
                .frame(height: geometry.size.height * 0.5)
            }
            .frame(maxHeight: geometry.size.height * 0.6)

            Spacer()

            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .offset(y: animateElements ? 0 : 30)
                    .opacity(animateElements ? 1 : 0)

                Text(page.subtitle)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 32)
                    .offset(y: animateElements ? 0 : 30)
                    .opacity(animateElements ? 1 : 0)
            }

            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.2)) {
                animateElements = true
            }
        }
        .onDisappear {
            animateElements = false
        }
    }
}

// MARK: - Illustrated Page Model

public struct IllustratedPage {
    let title: String
    let subtitle: String
    let backgroundColor: Color
    let backgroundShape: AnyShape
    let illustration: AnyView?

    public init<S: Shape, V: View>(
        title: String,
        subtitle: String,
        backgroundColor: Color,
        backgroundShape: S,
        @ViewBuilder illustration: () -> V
    ) {
        self.title = title
        self.subtitle = subtitle
        self.backgroundColor = backgroundColor
        self.backgroundShape = AnyShape(backgroundShape)
        self.illustration = AnyView(illustration())
    }
}

// MARK: - Shape Type Erasure

struct AnyShape: Shape {
    private let _path: (CGRect) -> Path

    init<S: Shape>(_ shape: S) {
        _path = shape.path(in:)
    }

    func path(in rect: CGRect) -> Path {
        _path(rect)
    }
}

// MARK: - Custom Shapes

struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.8))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.7),
            control: CGPoint(x: rect.width * 0.5, y: rect.height)
        )
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.closeSubpath()
        return path
    }
}

struct BlobShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.move(to: CGPoint(x: width * 0.9, y: height * 0.4))
        path.addCurve(
            to: CGPoint(x: width * 0.1, y: height * 0.4),
            control1: CGPoint(x: width * 1.1, y: height * 0.8),
            control2: CGPoint(x: width * -0.05, y: height * 0.7)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.5, y: height * 0.05),
            control1: CGPoint(x: width * 0.0, y: height * 0.0),
            control2: CGPoint(x: width * 0.2, y: height * -0.1)
        )
        path.addCurve(
            to: CGPoint(x: width * 0.9, y: height * 0.4),
            control1: CGPoint(x: width * 0.8, y: height * 0.1),
            control2: CGPoint(x: width * 0.95, y: height * 0.2)
        )
        return path
    }
}

// MARK: - Sample Illustrated Pages

public extension IllustratedPage {
    static let samplePages: [IllustratedPage] = [
        IllustratedPage(
            title: "Welcome to Your New Experience",
            subtitle: "We're excited to show you around and help you get the most out of our app",
            backgroundColor: .blue.opacity(0.3),
            backgroundShape: WaveShape()
        ) {
            VStack(spacing: -20) {
                Image(systemName: "sparkles")
                    .font(.system(size: 80))
                    .foregroundColor(.blue)

                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 200, height: 200)
                    .overlay(
                        Image(systemName: "apps.iphone")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                    )
            }
        },

        IllustratedPage(
            title: "Organize Everything",
            subtitle: "Keep all your important information in one place, accessible anytime",
            backgroundColor: .green.opacity(0.3),
            backgroundShape: BlobShape()
        ) {
            ZStack {
                ForEach(0..<3) { index in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.green.opacity(0.3))
                        .frame(width: 150, height: 200)
                        .rotationEffect(.degrees(Double(index - 1) * 15))
                        .offset(x: CGFloat(index - 1) * 30, y: CGFloat(index) * 10)
                }

                Image(systemName: "folder.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
            }
        },

        IllustratedPage(
            title: "Stay Connected",
            subtitle: "Collaborate with your team and share your progress effortlessly",
            backgroundColor: .purple.opacity(0.3),
            backgroundShape: Circle()
        ) {
            ZStack {
                Circle()
                    .strokeBorder(Color.purple.opacity(0.3), lineWidth: 2)
                    .frame(width: 250, height: 250)

                ForEach(0..<6) { index in
                    Circle()
                        .fill(Color.purple)
                        .frame(width: 40, height: 40)
                        .offset(x: 100 * cos(CGFloat(index) * .pi / 3),
                               y: 100 * sin(CGFloat(index) * .pi / 3))
                }

                Image(systemName: "person.3.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.purple)
            }
        },

        IllustratedPage(
            title: "Ready to Begin?",
            subtitle: "Let's set up your account and personalize your experience",
            backgroundColor: .orange.opacity(0.3),
            backgroundShape: RoundedRectangle(cornerRadius: 100)
        ) {
            VStack(spacing: 20) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.orange)

                HStack(spacing: 20) {
                    ForEach(["bell", "gear", "person"], id: \.self) { icon in
                        Circle()
                            .fill(Color.orange.opacity(0.2))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: icon)
                                    .font(.title2)
                                    .foregroundColor(.orange)
                            )
                    }
                }
            }
        }
    ]
}