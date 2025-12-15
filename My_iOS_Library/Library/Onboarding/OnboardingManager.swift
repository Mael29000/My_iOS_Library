//
//  OnboardingManager.swift
//  My_iOS_Library
//
//  Manages onboarding state and persistence
//

import SwiftUI

// MARK: - Onboarding Manager

public class OnboardingManager: OnboardingManagerProtocol {
    private let userDefaults = UserDefaults.standard
    private let hasCompletedKey = "hasCompletedOnboarding"
    private let versionKey = "onboardingVersion"
    private let responsesKey = "onboardingResponses"

    public static let shared = OnboardingManager()

    private init() {}

    // MARK: - OnboardingManagerProtocol

    public var hasCompletedOnboarding: Bool {
        get { userDefaults.bool(forKey: hasCompletedKey) }
        set { userDefaults.set(newValue, forKey: hasCompletedKey) }
    }

    public var onboardingVersion: String {
        get { userDefaults.string(forKey: versionKey) ?? "0.0.0" }
        set { userDefaults.set(newValue, forKey: versionKey) }
    }

    public var userResponses: [String: Any] {
        get { userDefaults.dictionary(forKey: responsesKey) ?? [:] }
        set { userDefaults.set(newValue, forKey: responsesKey) }
    }

    public func shouldShowOnboarding(for version: String) -> Bool {
        // Show onboarding if never completed or version is newer
        if !hasCompletedOnboarding { return true }

        let currentVersion = onboardingVersion
        return isVersionNewer(version, than: currentVersion)
    }

    public func markOnboardingCompleted(version: String) {
        hasCompletedOnboarding = true
        onboardingVersion = version
    }

    public func saveResponse(key: String, value: Any) {
        var responses = userResponses
        responses[key] = value
        userResponses = responses
    }

    public func getResponse(for key: String) -> Any? {
        return userResponses[key]
    }

    public func resetOnboarding() {
        hasCompletedOnboarding = false
        onboardingVersion = "0.0.0"
        userResponses = [:]
    }

    // MARK: - Private Helpers

    private func isVersionNewer(_ new: String, than current: String) -> Bool {
        let newComponents = new.split(separator: ".").compactMap { Int($0) }
        let currentComponents = current.split(separator: ".").compactMap { Int($0) }

        for i in 0..<max(newComponents.count, currentComponents.count) {
            let newValue = i < newComponents.count ? newComponents[i] : 0
            let currentValue = i < currentComponents.count ? currentComponents[i] : 0

            if newValue > currentValue { return true }
            if newValue < currentValue { return false }
        }

        return false
    }
}

// MARK: - Base Onboarding Flow

@MainActor
public class BaseOnboardingFlow: OnboardingFlowProtocol {
    @Published public var currentPageIndex: Int = 0
    @Published public var isCompleted: Bool = false

    public let pages: [any OnboardingPageProtocol]
    private let onComplete: (() -> Void)?

    public init(pages: [any OnboardingPageProtocol], onComplete: (() -> Void)? = nil) {
        self.pages = pages
        self.onComplete = onComplete
    }

    public func nextPage() {
        withAnimation(.spring()) {
            if currentPageIndex < pages.count - 1 {
                currentPageIndex += 1
            } else {
                completeOnboarding()
            }
        }
    }

    public func previousPage() {
        withAnimation(.spring()) {
            if currentPageIndex > 0 {
                currentPageIndex -= 1
            }
        }
    }

    public func skipOnboarding() {
        completeOnboarding()
    }

    public func completeOnboarding() {
        withAnimation {
            isCompleted = true
        }
        onComplete?()
        OnboardingManager.shared.markOnboardingCompleted(version: "1.0.0")
    }

    public var progress: Double {
        guard pages.count > 0 else { return 0 }
        return Double(currentPageIndex + 1) / Double(pages.count)
    }

    public var canGoBack: Bool {
        currentPageIndex > 0
    }

    public var canGoForward: Bool {
        currentPageIndex < pages.count - 1
    }

    public var isLastPage: Bool {
        currentPageIndex == pages.count - 1
    }
}