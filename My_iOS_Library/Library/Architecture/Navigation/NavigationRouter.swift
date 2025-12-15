//
//  NavigationRouter.swift
//  My_iOS_Library
//
//  Central navigation router using @Observable (iOS 17+)
//

import SwiftUI
import Observation

// MARK: - Navigation Router

@Observable
public class NavigationRouter {
    // MARK: - Navigation State

    /// Navigation path for push navigation
    public var path = NavigationPath()

    /// Currently presented sheet
    public var presentedSheet: SheetRoute?

    /// Currently presented full screen cover
    public var presentedFullScreen: FullScreenRoute?

    /// Current tab selection
    public var selectedTab: TabRoute = .home

    /// Alert state
    public var alert: AlertConfig?

    /// Confirmation dialog state
    public var confirmationDialog: ConfirmationDialogConfig?

    // MARK: - Initialization

    public init() {}

    // MARK: - Navigation Methods

    /// Navigate to a route (push)
    public func navigate(to route: Route) {
        switch route {
        case .sheet(let sheetRoute):
            presentSheet(sheetRoute)
        case .fullScreen(let fullScreenRoute):
            presentFullScreen(fullScreenRoute)
        case .tab(let tabRoute):
            selectedTab = tabRoute
        default:
            path.append(route)
        }
    }

    /// Navigate to multiple routes at once
    public func navigate(to routes: [Route]) {
        for route in routes {
            path.append(route)
        }
    }

    /// Pop to root view
    public func popToRoot() {
        path.removeLast(path.count)
    }

    /// Pop one view
    public func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    /// Pop to a specific route
    public func popTo(_ route: Route) {
        // This is simplified - in a real app you might need more logic
        while !path.isEmpty {
            path.removeLast()
        }
        path.append(route)
    }

    /// Replace the entire navigation stack
    public func replaceStack(with routes: [Route]) {
        path.removeLast(path.count)
        for route in routes {
            path.append(route)
        }
    }

    // MARK: - Sheet Methods

    /// Present a sheet
    public func presentSheet(_ sheet: SheetRoute) {
        presentedSheet = sheet
    }

    /// Dismiss the current sheet
    public func dismissSheet() {
        presentedSheet = nil
    }

    // MARK: - Full Screen Methods

    /// Present a full screen cover
    public func presentFullScreen(_ fullScreen: FullScreenRoute) {
        presentedFullScreen = fullScreen
    }

    /// Dismiss the current full screen cover
    public func dismissFullScreen() {
        presentedFullScreen = nil
    }

    // MARK: - Alert Methods

    /// Show an alert
    public func showAlert(_ config: AlertConfig) {
        alert = config
    }

    /// Show a simple alert
    public func showAlert(
        title: String,
        message: String? = nil,
        primaryButton: AlertButton? = nil,
        secondaryButton: AlertButton? = nil
    ) {
        alert = AlertConfig(
            title: title,
            message: message,
            primaryButton: primaryButton ?? .ok,
            secondaryButton: secondaryButton
        )
    }

    /// Dismiss the current alert
    public func dismissAlert() {
        alert = nil
    }

    // MARK: - Confirmation Dialog Methods

    /// Show a confirmation dialog
    public func showConfirmationDialog(_ config: ConfirmationDialogConfig) {
        confirmationDialog = config
    }

    /// Dismiss the current confirmation dialog
    public func dismissConfirmationDialog() {
        confirmationDialog = nil
    }

    // MARK: - Tab Methods

    /// Switch to a specific tab
    public func switchToTab(_ tab: TabRoute) {
        selectedTab = tab
    }

    // MARK: - Combined Actions

    /// Dismiss all presentations and pop to root
    public func reset() {
        dismissSheet()
        dismissFullScreen()
        dismissAlert()
        dismissConfirmationDialog()
        popToRoot()
        selectedTab = .home
    }
}

// MARK: - Alert Configuration

public struct AlertConfig: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let primaryButton: AlertButton
    public let secondaryButton: AlertButton?

    public init(
        title: String,
        message: String? = nil,
        primaryButton: AlertButton,
        secondaryButton: AlertButton? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}

public struct AlertButton {
    public let title: String
    public let role: ButtonRole?
    public let action: () -> Void

    public init(
        title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.role = role
        self.action = action
    }

    // Convenience initializers
    public static let ok = AlertButton(title: "OK")
    public static let cancel = AlertButton(title: "Cancel", role: .cancel)
    public static func delete(action: @escaping () -> Void) -> AlertButton {
        AlertButton(title: "Delete", role: .destructive, action: action)
    }
}

// MARK: - Confirmation Dialog Configuration

public struct ConfirmationDialogConfig: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let buttons: [DialogButton]

    public init(
        title: String,
        message: String? = nil,
        buttons: [DialogButton]
    ) {
        self.title = title
        self.message = message
        self.buttons = buttons
    }
}

public struct DialogButton {
    public let title: String
    public let role: ButtonRole?
    public let action: () -> Void

    public init(
        title: String,
        role: ButtonRole? = nil,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.role = role
        self.action = action
    }
}