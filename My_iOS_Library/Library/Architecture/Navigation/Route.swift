//
//  Route.swift
//  My_iOS_Library
//
//  Defines all possible navigation routes in the app
//

import SwiftUI

// MARK: - Route Definition

public enum Route: Hashable {
    // MARK: - Main Routes (Push Navigation)
    case home
    case profile(userId: String)
    case settings
    case detail(itemId: String)
    case list(category: String)

    // MARK: - Sheet Routes
    case sheet(SheetRoute)

    // MARK: - Full Screen Cover Routes
    case fullScreen(FullScreenRoute)

    // MARK: - Tab Routes
    case tab(TabRoute)
}

// MARK: - Sheet Routes

public enum SheetRoute: Hashable {
    case addItem
    case editProfile(userId: String)
    case filter(FilterOptions)
    case share(content: ShareContent)
    case imagePicker
    case settings
}

// MARK: - Full Screen Routes

public enum FullScreenRoute: Hashable {
    case onboarding
    case login
    case premium
    case videoPlayer(url: String)
}

// MARK: - Tab Routes

public enum TabRoute: String, CaseIterable, Hashable {
    case home = "Home"
    case explore = "Explore"
    case favorites = "Favorites"
    case profile = "Profile"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .explore: return "magnifyingglass"
        case .favorites: return "heart.fill"
        case .profile: return "person.fill"
        }
    }
}

// MARK: - Supporting Types

public struct FilterOptions: Hashable {
    let category: String?
    let priceRange: ClosedRange<Double>?
    let sortBy: SortOption

    public init(
        category: String? = nil,
        priceRange: ClosedRange<Double>? = nil,
        sortBy: SortOption = .name
    ) {
        self.category = category
        self.priceRange = priceRange
        self.sortBy = sortBy
    }
}

public enum SortOption: String, CaseIterable, Hashable {
    case name = "Name"
    case price = "Price"
    case date = "Date"
    case popularity = "Popularity"
}

public struct ShareContent: Hashable {
    let title: String
    let url: String?
    let image: String?

    public init(title: String, url: String? = nil, image: String? = nil) {
        self.title = title
        self.url = url
        self.image = image
    }
}