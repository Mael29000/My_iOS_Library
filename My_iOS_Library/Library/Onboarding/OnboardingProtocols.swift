//
//  OnboardingProtocols.swift
//  My_iOS_Library
//
//  Base protocols and models for onboarding experiences
//

import SwiftUI

// MARK: - Onboarding Page Protocol

public protocol OnboardingPageProtocol {
    var id: String { get }
    var title: String { get }
    var subtitle: String? { get }
    var imageName: String? { get }
    var systemImageName: String? { get }
    var backgroundColor: Color? { get }
    var primaryAction: OnboardingAction? { get }
    var secondaryAction: OnboardingAction? { get }
}

// MARK: - Onboarding Action

public struct OnboardingAction {
    public let title: String
    public let style: ActionStyle
    public let action: () -> Void

    public enum ActionStyle {
        case primary
        case secondary
        case skip
        case custom(foregroundColor: Color, backgroundColor: Color)
    }

    public init(title: String, style: ActionStyle = .primary, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
}

// MARK: - Onboarding Flow Protocol

public protocol OnboardingFlowProtocol: ObservableObject {
    var currentPageIndex: Int { get set }
    var pages: [any OnboardingPageProtocol] { get }
    var isCompleted: Bool { get }

    func nextPage()
    func previousPage()
    func skipOnboarding()
    func completeOnboarding()
}

// MARK: - Default Onboarding Page

public struct OnboardingPage: OnboardingPageProtocol {
    public let id: String
    public let title: String
    public let subtitle: String?
    public let imageName: String?
    public let systemImageName: String?
    public let backgroundColor: Color?
    public let primaryAction: OnboardingAction?
    public let secondaryAction: OnboardingAction?

    public init(
        id: String = UUID().uuidString,
        title: String,
        subtitle: String? = nil,
        imageName: String? = nil,
        systemImageName: String? = nil,
        backgroundColor: Color? = nil,
        primaryAction: OnboardingAction? = nil,
        secondaryAction: OnboardingAction? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.systemImageName = systemImageName
        self.backgroundColor = backgroundColor
        self.primaryAction = primaryAction
        self.secondaryAction = secondaryAction
    }
}

// MARK: - Feature Item

public struct OnboardingFeature: Identifiable {
    public let id = UUID()
    public let icon: String
    public let iconColor: Color
    public let title: String
    public let description: String

    public init(icon: String, iconColor: Color, title: String, description: String) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.description = description
    }
}

// MARK: - Question Item

public struct OnboardingQuestion: Identifiable {
    public let id = UUID()
    public let question: String
    public let options: [QuestionOption]
    public let allowsMultipleSelection: Bool

    public init(question: String, options: [QuestionOption], allowsMultipleSelection: Bool = false) {
        self.question = question
        self.options = options
        self.allowsMultipleSelection = allowsMultipleSelection
    }
}

public struct QuestionOption: Identifiable {
    public let id = UUID()
    public let title: String
    public let subtitle: String?
    public let icon: String?
    public let value: String

    public init(title: String, subtitle: String? = nil, icon: String? = nil, value: String) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.value = value
    }
}

// MARK: - Onboarding Manager Protocol

public protocol OnboardingManagerProtocol {
    var hasCompletedOnboarding: Bool { get set }
    var onboardingVersion: String { get set }
    var userResponses: [String: Any] { get set }

    func shouldShowOnboarding(for version: String) -> Bool
    func markOnboardingCompleted(version: String)
    func saveResponse(key: String, value: Any)
    func getResponse(for key: String) -> Any?
    func resetOnboarding()
}

// MARK: - Transition Styles

public enum OnboardingTransitionStyle {
    case slide
    case fade
    case scale
    case custom(AnyTransition)
}