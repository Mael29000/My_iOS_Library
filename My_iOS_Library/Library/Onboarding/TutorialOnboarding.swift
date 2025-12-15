//
//  TutorialOnboarding.swift
//  My_iOS_Library
//
//  Interactive tutorial style onboarding
//

import SwiftUI

// MARK: - Tutorial Step

public struct TutorialStep: Identifiable {
    public let id = UUID()
    public let title: String
    public let instruction: String
    public let highlightArea: HighlightArea?
    public let action: TutorialAction?
    public let showsSkipButton: Bool

    public enum HighlightArea {
        case rect(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
        case circle(x: CGFloat, y: CGFloat, radius: CGFloat)
        case custom(Path)
    }

    public enum TutorialAction {
        case tap
        case swipe(direction: SwipeDirection)
        case longPress
        case doubleTap
        case custom(String)

        public enum SwipeDirection {
            case up, down, left, right
        }
    }

    public init(
        title: String,
        instruction: String,
        highlightArea: HighlightArea? = nil,
        action: TutorialAction? = nil,
        showsSkipButton: Bool = true
    ) {
        self.title = title
        self.instruction = instruction
        self.highlightArea = highlightArea
        self.action = action
        self.showsSkipButton = showsSkipButton
    }
}

// MARK: - Tutorial Onboarding View

public struct TutorialOnboardingView<Content: View>: View {
    @StateObject private var tutorialState: TutorialState
    @Environment(\.theme) private var theme

    private let content: Content
    private let steps: [TutorialStep]
    private let onComplete: (() -> Void)?

    public init(
        steps: [TutorialStep],
        onComplete: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.steps = steps
        self.onComplete = onComplete
        self.content = content()
        self._tutorialState = StateObject(wrappedValue: TutorialState(totalSteps: steps.count))
    }

    public var body: some View {
        ZStack {
            // Main Content
            content
                .allowsHitTesting(!tutorialState.isActive)

            // Tutorial Overlay
            if tutorialState.isActive && tutorialState.currentStep < steps.count {
                TutorialOverlay(
                    step: steps[tutorialState.currentStep],
                    tutorialState: tutorialState,
                    onNext: {
                        tutorialState.nextStep()
                        if tutorialState.currentStep >= steps.count {
                            completeTutorial()
                        }
                    },
                    onSkip: {
                        completeTutorial()
                    }
                )
            }
        }
        .onAppear {
            tutorialState.startTutorial()
        }
    }

    private func completeTutorial() {
        tutorialState.completeTutorial()
        onComplete?()
        OnboardingManager.shared.markOnboardingCompleted(version: "1.0.0")
    }
}

// MARK: - Tutorial State

class TutorialState: ObservableObject {
    @Published var isActive = false
    @Published var currentStep = 0
    let totalSteps: Int

    init(totalSteps: Int) {
        self.totalSteps = totalSteps
    }

    func startTutorial() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isActive = true
        }
    }

    func nextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStep += 1
        }
    }

    func completeTutorial() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isActive = false
        }
    }

    var progress: Double {
        guard totalSteps > 0 else { return 0 }
        return Double(currentStep + 1) / Double(totalSteps)
    }
}

// MARK: - Tutorial Overlay

struct TutorialOverlay: View {
    @Environment(\.theme) private var theme
    let step: TutorialStep
    let tutorialState: TutorialState
    let onNext: () -> Void
    let onSkip: () -> Void

    @State private var tooltipOffset: CGSize = .zero
    @State private var animateHint = false

    var body: some View {
        ZStack {
            // Dark overlay with cutout
            GeometryReader { geometry in
                ZStack {
                    // Full dark overlay
                    Color.black.opacity(0.75)
                        .ignoresSafeArea()

                    // Cutout for highlight area
                    if let highlightArea = step.highlightArea {
                        Color.black.opacity(0.75)
                            .mask(
                                ZStack {
                                    Rectangle()
                                        .fill(Color.white)

                                    cutoutShape(for: highlightArea, in: geometry.size)
                                        .foregroundColor(.black)
                                        .blur(radius: 2)
                                }
                            )
                    }
                }
            }

            // Tooltip
            VStack(spacing: 0) {
                if let highlightArea = step.highlightArea {
                    Spacer()
                        .frame(height: tooltipPosition(for: highlightArea).y)
                }

                TooltipView(
                    step: step,
                    progress: tutorialState.progress,
                    animateHint: animateHint,
                    onNext: onNext,
                    onSkip: onSkip
                )
                .padding()
                .offset(tooltipOffset)

                if step.highlightArea != nil {
                    Spacer()
                }
            }
        }
        .onAppear {
            // Animate hint after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    animateHint = true
                }
            }
        }
    }

    @ViewBuilder
    private func cutoutShape(for area: TutorialStep.HighlightArea, in size: CGSize) -> some View {
        switch area {
        case .rect(let x, let y, let width, let height):
            RoundedRectangle(cornerRadius: 8)
                .frame(width: width, height: height)
                .position(x: x, y: y)

        case .circle(let x, let y, let radius):
            Circle()
                .frame(width: radius * 2, height: radius * 2)
                .position(x: x, y: y)

        case .custom(let path):
            path
        }
    }

    private func tooltipPosition(for area: TutorialStep.HighlightArea) -> CGPoint {
        switch area {
        case .rect(let x, let y, _, let height):
            return CGPoint(x: x, y: y + height/2 + 100)

        case .circle(let x, let y, let radius):
            return CGPoint(x: x, y: y + radius + 100)

        case .custom:
            return CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
        }
    }
}

// MARK: - Tooltip View

struct TooltipView: View {
    @Environment(\.theme) private var theme
    let step: TutorialStep
    let progress: Double
    let animateHint: Bool
    let onNext: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            // Progress Indicator
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .white))
                .frame(height: 3)
                .opacity(0.8)

            // Content
            VStack(spacing: 16) {
                Text(step.title)
                    .font(theme.typography.heading2)
                    .foregroundColor(.white)

                Text(step.instruction)
                    .font(theme.typography.body1)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)

                // Action Hint
                if let action = step.action {
                    HStack(spacing: 8) {
                        actionIcon(for: action)
                            .font(.title2)
                            .foregroundColor(.white)
                            .scaleEffect(animateHint ? 1.2 : 1.0)

                        Text(actionText(for: action))
                            .font(theme.typography.body2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                }
            }

            // Buttons
            HStack(spacing: 16) {
                if step.showsSkipButton {
                    Button(action: onSkip) {
                        Text("Skip Tutorial")
                            .font(theme.typography.body2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Spacer()

                Button(action: onNext) {
                    Text("Next")
                        .font(theme.typography.body1)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .cornerRadius(25)
                }
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black.opacity(0.9))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(radius: 20)
    }

    @ViewBuilder
    private func actionIcon(for action: TutorialStep.TutorialAction) -> some View {
        switch action {
        case .tap:
            Image(systemName: "hand.tap")
        case .swipe(let direction):
            switch direction {
            case .up:
                Image(systemName: "arrow.up")
            case .down:
                Image(systemName: "arrow.down")
            case .left:
                Image(systemName: "arrow.left")
            case .right:
                Image(systemName: "arrow.right")
            }
        case .longPress:
            Image(systemName: "hand.tap")
        case .doubleTap:
            Image(systemName: "hand.tap")
        case .custom:
            Image(systemName: "hand.draw")
        }
    }

    private func actionText(for action: TutorialStep.TutorialAction) -> String {
        switch action {
        case .tap:
            return "Tap to continue"
        case .swipe(let direction):
            return "Swipe \(direction)"
        case .longPress:
            return "Long press"
        case .doubleTap:
            return "Double tap"
        case .custom(let text):
            return text
        }
    }
}

// MARK: - Sample Tutorial Steps

public extension TutorialStep {
    static let sampleSteps: [TutorialStep] = [
        TutorialStep(
            title: "Welcome!",
            instruction: "Let's take a quick tour of the app to get you started.",
            action: .tap
        ),
        TutorialStep(
            title: "Navigation Bar",
            instruction: "Use the navigation bar to switch between different sections.",
            highlightArea: .rect(x: UIScreen.main.bounds.width / 2, y: 50, width: UIScreen.main.bounds.width - 40, height: 60),
            action: .tap
        ),
        TutorialStep(
            title: "Main Content",
            instruction: "This is where your main content appears. Swipe to see more.",
            highlightArea: .rect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: UIScreen.main.bounds.width - 40, height: 300),
            action: .swipe(direction: .up)
        ),
        TutorialStep(
            title: "Action Button",
            instruction: "Tap the plus button to create new items.",
            highlightArea: .circle(x: UIScreen.main.bounds.width - 50, y: UIScreen.main.bounds.height - 100, radius: 30),
            action: .tap
        ),
        TutorialStep(
            title: "You're All Set!",
            instruction: "You've completed the tutorial. Enjoy using the app!",
            showsSkipButton: false
        )
    ]
}