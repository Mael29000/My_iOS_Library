//
//  NavigationContainer.swift
//  My_iOS_Library
//
//  Main navigation container that handles all navigation types
//

import SwiftUI

// MARK: - Navigation Container

public struct NavigationContainer<Content: View>: View {
    @State private var router = NavigationRouter()
    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        NavigationStack(path: $router.path) {
            content()
                .navigationDestination(for: Route.self) { route in
                    RouteView(route: route)
                }
        }
        .sheet(item: Binding(
            get: { router.presentedSheet.map { SheetWrapper($0) } },
            set: { _ in router.presentedSheet = nil }
        )) { wrapper in
            SheetView(route: wrapper.route)
                .environment(router)
        }
        .fullScreenCover(item: Binding(
            get: { router.presentedFullScreen.map { FullScreenWrapper($0) } },
            set: { _ in router.presentedFullScreen = nil }
        )) { wrapper in
            FullScreenView(route: wrapper.route)
                .environment(router)
        }
        .alert(
            router.alert?.title ?? "",
            isPresented: Binding(
                get: { router.alert != nil },
                set: { _ in router.alert = nil }
            ),
            presenting: router.alert
        ) { alert in
            Button(alert.primaryButton.title, role: alert.primaryButton.role) {
                alert.primaryButton.action()
            }
            if let secondaryButton = alert.secondaryButton {
                Button(secondaryButton.title, role: secondaryButton.role) {
                    secondaryButton.action()
                }
            }
        } message: { alert in
            if let message = alert.message {
                Text(message)
            }
        }
        .confirmationDialog(
            router.confirmationDialog?.title ?? "",
            isPresented: Binding(
                get: { router.confirmationDialog != nil },
                set: { _ in router.confirmationDialog = nil }
            ),
            titleVisibility: .visible,
            presenting: router.confirmationDialog
        ) { dialog in
            ForEach(Array(dialog.buttons.enumerated()), id: \.offset) { _, button in
                Button(button.title, role: button.role) {
                    button.action()
                }
            }
        } message: { dialog in
            if let message = dialog.message {
                Text(message)
            }
        }
        .environment(router)
    }
}

// MARK: - Navigation Container with Tabs

public struct TabNavigationContainer: View {
    @State private var router = NavigationRouter()

    public init() {}

    public var body: some View {
        TabView(selection: $router.selectedTab) {
            ForEach(TabRoute.allCases, id: \.self) { tab in
                NavigationStack(path: pathBinding(for: tab)) {
                    TabContentView(tab: tab)
                        .navigationDestination(for: Route.self) { route in
                            RouteView(route: route)
                        }
                }
                .tabItem {
                    Label(tab.rawValue, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
        .sheet(item: Binding(
            get: { router.presentedSheet.map { SheetWrapper($0) } },
            set: { _ in router.presentedSheet = nil }
        )) { wrapper in
            SheetView(route: wrapper.route)
                .environment(router)
        }
        .fullScreenCover(item: Binding(
            get: { router.presentedFullScreen.map { FullScreenWrapper($0) } },
            set: { _ in router.presentedFullScreen = nil }
        )) { wrapper in
            FullScreenView(route: wrapper.route)
                .environment(router)
        }
        .environment(router)
    }

    private func pathBinding(for tab: TabRoute) -> Binding<NavigationPath> {
        // In a real app, you might want separate paths for each tab
        $router.path
    }
}

// MARK: - Route View

struct RouteView: View {
    @Environment(NavigationRouter.self) private var router
    let route: Route

    var body: some View {
        switch route {
        case .home:
            HomeView()
        case .profile(let userId):
            ProfileView(userId: userId)
        case .settings:
            SettingsView()
        case .detail(let itemId):
            DetailView(itemId: itemId)
        case .list(let category):
            ListView(category: category)
        case .sheet, .fullScreen, .tab:
            // These are handled differently
            EmptyView()
        }
    }
}

// MARK: - Sheet View

struct SheetView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    let route: SheetRoute

    var body: some View {
        NavigationStack {
            Group {
                switch route {
                case .addItem:
                    AddItemView()
                case .editProfile(let userId):
                    EditProfileView(userId: userId)
                case .filter(let options):
                    FilterView(options: options)
                case .share(let content):
                    ShareView(content: content)
                case .imagePicker:
                    ImagePickerView()
                case .settings:
                    SettingsView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Full Screen View

struct FullScreenView: View {
    @Environment(NavigationRouter.self) private var router
    let route: FullScreenRoute

    var body: some View {
        switch route {
        case .onboarding:
            OnboardingView()
        case .login:
            LoginView()
        case .premium:
            PremiumView()
        case .videoPlayer(let url):
            VideoPlayerView(url: url)
        }
    }
}

// MARK: - Tab Content View

struct TabContentView: View {
    @Environment(NavigationRouter.self) private var router
    let tab: TabRoute

    var body: some View {
        switch tab {
        case .home:
            HomeView()
        case .explore:
            ExploreView()
        case .favorites:
            FavoritesView()
        case .profile:
            ProfileTabView()
        }
    }
}

// MARK: - Wrapper Types

private struct SheetWrapper: Identifiable {
    let id = UUID()
    let route: SheetRoute

    init(_ route: SheetRoute) {
        self.route = route
    }
}

private struct FullScreenWrapper: Identifiable {
    let id = UUID()
    let route: FullScreenRoute

    init(_ route: FullScreenRoute) {
        self.route = route
    }
}