//
//  NavigationDemo.swift
//  My_iOS_Library
//
//  Demo view showing how to use the navigation system
//

import SwiftUI

// MARK: - Navigation Demo

public struct NavigationDemo: View {
    @State private var showTabs = false

    public init() {}

    public var body: some View {
        VStack(spacing: 30) {
            Text("Navigation Architecture")
                .font(.largeTitle)
                .bold()

            Text("Choose a navigation style:")
                .font(.headline)

            VStack(spacing: 20) {
                // Simple Navigation
                Button(action: { showTabs = false }) {
                    Label("Simple Navigation", systemImage: "arrow.right.square")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Tab Navigation
                Button(action: { showTabs = true }) {
                    Label("Tab Navigation", systemImage: "square.grid.2x2")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)

            if showTabs {
                // Tab-based navigation
                TabNavigationContainer()
                    .transition(.move(edge: .bottom))
            } else {
                // Simple navigation
                NavigationContainer {
                    HomeView()
                }
                .transition(.opacity)
            }
        }
        .animation(.default, value: showTabs)
    }
}

// MARK: - How to Use Guide

public struct NavigationGuide: View {
    public init() {}

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 30) {
                Text("Navigation System Guide")
                    .font(.largeTitle)
                    .bold()

                // Overview
                VStack(alignment: .leading, spacing: 10) {
                    Text("Overview")
                        .font(.title2)
                        .bold()

                    Text("""
                    This navigation system provides a centralized way to handle all navigation in your app:
                    • Push navigation
                    • Sheets
                    • Full screen covers
                    • Alerts
                    • Confirmation dialogs
                    • Tab navigation
                    """)
                }

                Divider()

                // Setup
                VStack(alignment: .leading, spacing: 10) {
                    Text("Setup")
                        .font(.title2)
                        .bold()

                    Text("1. Wrap your app in NavigationContainer:")
                        .font(.headline)

                    codeBlock("""
                    // In your App.swift
                    NavigationContainer {
                        HomeView()
                    }

                    // Or for tab navigation:
                    TabNavigationContainer()
                    """)
                }

                Divider()

                // Usage Examples
                VStack(alignment: .leading, spacing: 20) {
                    Text("Usage Examples")
                        .font(.title2)
                        .bold()

                    Text("Push Navigation:")
                        .font(.headline)
                    codeBlock("""
                    @Environment(NavigationRouter.self) private var router

                    // Navigate to a view
                    router.navigate(to: .profile(userId: "123"))

                    // Pop back
                    router.pop()

                    // Pop to root
                    router.popToRoot()
                    """)

                    Text("Sheets:")
                        .font(.headline)
                    codeBlock("""
                    // Present a sheet
                    router.presentSheet(.addItem)

                    // Dismiss sheet
                    router.dismissSheet()
                    """)

                    Text("Full Screen:")
                        .font(.headline)
                    codeBlock("""
                    // Present full screen
                    router.presentFullScreen(.onboarding)

                    // Dismiss full screen
                    router.dismissFullScreen()
                    """)

                    Text("Alerts:")
                        .font(.headline)
                    codeBlock("""
                    // Simple alert
                    router.showAlert(
                        title: "Success!",
                        message: "Action completed"
                    )

                    // Alert with actions
                    router.showAlert(
                        title: "Delete?",
                        message: "This cannot be undone",
                        primaryButton: .delete {
                            // Delete action
                        },
                        secondaryButton: .cancel
                    )
                    """)
                }

                Divider()

                // Adding New Routes
                VStack(alignment: .leading, spacing: 10) {
                    Text("Adding New Routes")
                        .font(.title2)
                        .bold()

                    Text("1. Add your route to Route.swift:")
                        .font(.headline)
                    codeBlock("""
                    enum Route {
                        // Your new route
                        case myNewView(parameter: String)
                    }
                    """)

                    Text("2. Handle it in RouteView:")
                        .font(.headline)
                    codeBlock("""
                    case .myNewView(let parameter):
                        MyNewView(parameter: parameter)
                    """)
                }
            }
            .padding()
        }
    }

    private func codeBlock(_ code: String) -> some View {
        Text(code)
            .font(.system(.callout, design: .monospaced))
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(8)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Preview

#Preview("Navigation Demo") {
    NavigationDemo()
        .theme(DefaultTheme())
}

#Preview("Navigation Guide") {
    NavigationGuide()
}