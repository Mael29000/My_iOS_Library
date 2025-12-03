//
//  TabBar.swift
//  My_iOS_Library
//
//  A highly customizable tab bar with animations and multiple styles
//
//  Usage:
//  ```swift
//  TabBar(selection: $selectedTab) {
//      TabBarItem(tag: 0, title: "Home", icon: "house.fill")
//      TabBarItem(tag: 1, title: "Search", icon: "magnifyingglass")
//      TabBarItem(tag: 2, title: "Profile", icon: "person.fill")
//  }
//  .tabBarStyle(TabBarStyleConfiguration.floating)
//  ```
//
//  Customization:
//  - Styles: standard, floating, minimal, curved
//  - Animations: spring, scale, fade
//  - Custom colors and shapes
//  - Badge support
//
//  Dependencies: None
//  iOS Requirement: 15.0+
//

import SwiftUI
import UIKit

// MARK: - TabBar

public struct TabBar<SelectionValue: Hashable>: View {
    // MARK: - Properties

    @Binding var selection: SelectionValue
    private let items: [TabBarItemConfiguration<SelectionValue>]

    @State private var itemFrames: [SelectionValue: CGRect] = [:]
    @State private var indicatorFrame: CGRect = .zero

    @Environment(\.tabBarStyle) private var style
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Initialization

    public init(
        selection: Binding<SelectionValue>,
        @TabBarItemBuilder<SelectionValue> items: () -> [TabBarItemConfiguration<SelectionValue>]
    ) {
        self._selection = selection
        self.items = items()
    }

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Background
                backgroundView(in: geometry)

                // Items
                HStack(spacing: 0) {
                    ForEach(items, id: \.tag) { item in
                        TabBarItemView(
                            item: item,
                            isSelected: selection == item.tag,
                            style: style,
                            colorScheme: colorScheme
                        )
                        .frame(maxWidth: .infinity)
                        .background(
                            GeometryReader { itemGeometry in
                                Color.clear
                                    .preference(
                                        key: TabBarItemPreferenceKey.self,
                                        value: [TabBarItemData(
                                            tag: AnyHashable(item.tag),
                                            frame: itemGeometry.frame(in: .global)
                                        )]
                                    )
                            }
                        )
                        .onTapGesture {
                            withAnimation(style.selectionAnimation) {
                                selection = item.tag
                                hapticFeedback()
                            }
                        }
                    }
                }
                .padding(.horizontal, style.horizontalPadding)
                .frame(height: style.height)

                // Selection Indicator
                if style.showsSelectionIndicator {
                    selectionIndicator
                        .allowsHitTesting(false)
                }
            }
            .frame(width: geometry.size.width, height: style.height)
        }
        .frame(height: style.height)
        .onPreferenceChange(TabBarItemPreferenceKey.self) { preferences in
            updateFrames(from: preferences)
        }
    }

    // MARK: - Background

    @ViewBuilder
    private func backgroundView(in geometry: GeometryProxy) -> some View {
        switch style.variant {
        case .standard:
            Rectangle()
                .fill(style.backgroundColor(colorScheme))
                .overlay(
                    Rectangle()
                        .fill(style.separatorColor(colorScheme))
                        .frame(height: 1),
                    alignment: .top
                )

        case .floating:
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.backgroundColor(colorScheme))
                .shadow(
                    color: style.shadowColor(colorScheme),
                    radius: 8,
                    y: 4
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 8)

        case .minimal:
            Color.clear

        case .curved:
            CurvedShape()
                .fill(style.backgroundColor(colorScheme))
                .shadow(
                    color: style.shadowColor(colorScheme),
                    radius: 4,
                    y: -2
                )
        }
    }

    // MARK: - Selection Indicator

    @ViewBuilder
    private var selectionIndicator: some View {
        if let frame = itemFrames[selection] {
            switch style.indicatorStyle {
            case .none:
                EmptyView()

            case .underline:
                Rectangle()
                    .fill(style.indicatorColor(colorScheme))
                    .frame(width: frame.width * 0.6, height: 2)
                    .position(
                        x: frame.midX,
                        y: style.height - 8
                    )
                    .animation(style.selectionAnimation, value: selection)

            case .background:
                RoundedRectangle(cornerRadius: style.cornerRadius * 0.6)
                    .fill(style.indicatorColor(colorScheme).opacity(0.1))
                    .frame(width: frame.width * 0.8, height: frame.height * 0.7)
                    .position(
                        x: frame.midX,
                        y: frame.midY
                    )
                    .animation(style.selectionAnimation, value: selection)

            case .dot:
                Circle()
                    .fill(style.indicatorColor(colorScheme))
                    .frame(width: 6, height: 6)
                    .position(
                        x: frame.midX,
                        y: style.height - 16
                    )
                    .animation(style.selectionAnimation, value: selection)
            }
        }
    }

    // MARK: - Helpers

    private func updateFrames(from preferences: [TabBarItemData]) {
        var frames: [SelectionValue: CGRect] = [:]
        for preference in preferences {
            if let tag = preference.tag.base as? SelectionValue {
                frames[tag] = preference.frame
            }
        }
        itemFrames = frames
    }

    private func hapticFeedback() {
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - Tab Bar Item

public struct TabBarItemConfiguration<SelectionValue: Hashable> {
    let tag: SelectionValue
    let title: String?
    let icon: String
    let selectedIcon: String?
    let badge: TabBarBadge?

    public init(
        tag: SelectionValue,
        title: String? = nil,
        icon: String,
        selectedIcon: String? = nil,
        badge: TabBarBadge? = nil
    ) {
        self.tag = tag
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon
        self.badge = badge
    }
}

public enum TabBarBadge {
    case text(String)
    case number(Int)
    case dot
}

// MARK: - Tab Bar Item View

private struct TabBarItemView<SelectionValue: Hashable>: View {
    let item: TabBarItemConfiguration<SelectionValue>
    let isSelected: Bool
    let style: TabBarStyleConfiguration
    let colorScheme: ColorScheme

    @State private var isPressed = false

    var body: some View {
        VStack(spacing: style.itemSpacing) {
            ZStack(alignment: .topTrailing) {
                Image(systemName: isSelected && item.selectedIcon != nil ? item.selectedIcon! : item.icon)
                    .font(.system(size: style.iconSize, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(
                        isSelected
                            ? style.selectedItemColor(colorScheme)
                            : style.unselectedItemColor(colorScheme)
                    )
                    .scaleEffect(isSelected ? 1.1 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)

                // Badge
                if let badge = item.badge {
                    badgeView(for: badge)
                        .offset(x: 12, y: -8)
                }
            }

            if let title = item.title, style.showsLabels {
                Text(title)
                    .font(.system(size: style.labelSize, weight: isSelected ? .medium : .regular))
                    .foregroundColor(
                        isSelected
                            ? style.selectedItemColor(colorScheme)
                            : style.unselectedItemColor(colorScheme)
                    )
                    .lineLimit(1)
            }
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        .onLongPressGesture(
            minimumDuration: 0,
            maximumDistance: .infinity,
            pressing: { pressing in
                isPressed = pressing
            },
            perform: {}
        )
    }

    @ViewBuilder
    private func badgeView(for badge: TabBarBadge) -> some View {
        switch badge {
        case .text(let text):
            Text(text)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.red)
                .clipShape(Capsule())

        case .number(let number):
            if number > 0 {
                Text(number > 99 ? "99+" : "\(number)")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(4)
                    .background(Color.red)
                    .clipShape(Circle())
            }

        case .dot:
            Circle()
                .fill(Color.red)
                .frame(width: 8, height: 8)
        }
    }
}

// MARK: - Curved Shape

private struct CurvedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let curveHeight: CGFloat = 20

        path.move(to: CGPoint(x: 0, y: curveHeight))

        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: curveHeight),
            control: CGPoint(x: rect.width / 2, y: -curveHeight)
        )

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        path.closeSubpath()

        return path
    }
}

// MARK: - Style Configuration

public struct TabBarStyleConfiguration {
    public enum Variant {
        case standard
        case floating
        case minimal
        case curved
    }

    public enum IndicatorStyle {
        case none
        case underline
        case background
        case dot
    }

    public let variant: Variant
    public let height: CGFloat
    public let horizontalPadding: CGFloat
    public let cornerRadius: CGFloat
    public let iconSize: CGFloat
    public let labelSize: CGFloat
    public let itemSpacing: CGFloat
    public let showsLabels: Bool
    public let showsSelectionIndicator: Bool
    public let indicatorStyle: IndicatorStyle
    public let selectionAnimation: Animation

    // Colors
    public let backgroundColor: (ColorScheme) -> Color
    public let separatorColor: (ColorScheme) -> Color
    public let selectedItemColor: (ColorScheme) -> Color
    public let unselectedItemColor: (ColorScheme) -> Color
    public let indicatorColor: (ColorScheme) -> Color
    public let shadowColor: (ColorScheme) -> Color

    // Predefined styles
    public static let standard = TabBarStyleConfiguration(
        variant: .standard,
        height: 49,
        horizontalPadding: 0,
        cornerRadius: 0,
        iconSize: 24,
        labelSize: 10,
        itemSpacing: 4,
        showsLabels: true,
        showsSelectionIndicator: false,
        indicatorStyle: .none,
        selectionAnimation: .easeInOut(duration: 0.2),
        backgroundColor: { $0 == .dark ? Color(.systemGray6) : .white },
        separatorColor: { $0 == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.3) },
        selectedItemColor: { _ in .accentColor },
        unselectedItemColor: { _ in .gray },
        indicatorColor: { _ in .accentColor },
        shadowColor: { _ in .clear }
    )

    public static let floating = TabBarStyleConfiguration(
        variant: .floating,
        height: 60,
        horizontalPadding: 16,
        cornerRadius: 30,
        iconSize: 24,
        labelSize: 10,
        itemSpacing: 4,
        showsLabels: false,
        showsSelectionIndicator: true,
        indicatorStyle: .background,
        selectionAnimation: .spring(response: 0.3, dampingFraction: 0.8),
        backgroundColor: { $0 == .dark ? Color(.systemGray5) : .white },
        separatorColor: { _ in .clear },
        selectedItemColor: { _ in .accentColor },
        unselectedItemColor: { $0 == .dark ? .gray : Color.gray.opacity(0.6) },
        indicatorColor: { _ in .accentColor },
        shadowColor: { $0 == .dark ? Color.black.opacity(0.3) : Color.black.opacity(0.1) }
    )

    public static let minimal = TabBarStyleConfiguration(
        variant: .minimal,
        height: 44,
        horizontalPadding: 20,
        cornerRadius: 0,
        iconSize: 20,
        labelSize: 10,
        itemSpacing: 2,
        showsLabels: false,
        showsSelectionIndicator: true,
        indicatorStyle: .dot,
        selectionAnimation: .easeInOut(duration: 0.2),
        backgroundColor: { _ in .clear },
        separatorColor: { _ in .clear },
        selectedItemColor: { _ in .primary },
        unselectedItemColor: { _ in .secondary },
        indicatorColor: { _ in .primary },
        shadowColor: { _ in .clear }
    )

    public static let curved = TabBarStyleConfiguration(
        variant: .curved,
        height: 65,
        horizontalPadding: 0,
        cornerRadius: 0,
        iconSize: 26,
        labelSize: 10,
        itemSpacing: 4,
        showsLabels: true,
        showsSelectionIndicator: true,
        indicatorStyle: .underline,
        selectionAnimation: .spring(response: 0.4, dampingFraction: 0.7),
        backgroundColor: { $0 == .dark ? Color(.systemGray6) : .white },
        separatorColor: { _ in .clear },
        selectedItemColor: { _ in .accentColor },
        unselectedItemColor: { _ in .gray },
        indicatorColor: { _ in .accentColor },
        shadowColor: { $0 == .dark ? Color.black.opacity(0.4) : Color.gray.opacity(0.2) }
    )
}

// MARK: - Environment Key

private struct TabBarStyleKey: EnvironmentKey {
    static let defaultValue = TabBarStyleConfiguration.standard
}

extension EnvironmentValues {
    var tabBarStyle: TabBarStyleConfiguration {
        get { self[TabBarStyleKey.self] }
        set { self[TabBarStyleKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    public func tabBarStyle(_ style: TabBarStyleConfiguration) -> some View {
        environment(\.tabBarStyle, style)
    }

    public func tabBarStyle(_ variant: TabBarStyleConfiguration.Variant) -> some View {
        let configuration: TabBarStyleConfiguration
        switch variant {
        case .standard:
            configuration = TabBarStyleConfiguration.standard
        case .floating:
            configuration = TabBarStyleConfiguration.floating
        case .minimal:
            configuration = TabBarStyleConfiguration.minimal
        case .curved:
            configuration = TabBarStyleConfiguration.curved
        }
        return environment(\.tabBarStyle, configuration)
    }
}

// MARK: - Tab Bar Item Builder

@resultBuilder
public struct TabBarItemBuilder<SelectionValue: Hashable> {
    public static func buildBlock(_ components: TabBarItemConfiguration<SelectionValue>...) -> [TabBarItemConfiguration<SelectionValue>] {
        components
    }
}

// MARK: - Preference Key

private struct TabBarItemData: Equatable {
    let tag: AnyHashable
    let frame: CGRect
}

private struct TabBarItemPreferenceKey: PreferenceKey {
    static var defaultValue: [TabBarItemData] = []

    static func reduce(value: inout [TabBarItemData], nextValue: () -> [TabBarItemData]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - Convenience Initializers

public extension TabBarItemConfiguration where SelectionValue == Int {
    static func item(
        tag: Int,
        title: String? = nil,
        icon: String,
        selectedIcon: String? = nil,
        badge: TabBarBadge? = nil
    ) -> TabBarItemConfiguration {
        TabBarItemConfiguration(
            tag: tag,
            title: title,
            icon: icon,
            selectedIcon: selectedIcon,
            badge: badge
        )
    }
}

// MARK: - Preview

#Preview("Tab Bar Styles") {
    struct PreviewContent: View {
        @State private var selection = 0

        var body: some View {
            VStack(spacing: 40) {
                // Standard
                VStack {
                    Text("Standard").font(.headline)
                    TabBar(selection: $selection) {
                        TabBarItemConfiguration(tag: 0, title: "Home", icon: "house.fill")
                        TabBarItemConfiguration(tag: 1, title: "Search", icon: "magnifyingglass")
                        TabBarItemConfiguration(tag: 2, title: "Favorites", icon: "heart.fill", badge: .number(3))
                        TabBarItemConfiguration(tag: 3, title: "Profile", icon: "person.fill")
                    }
                    .tabBarStyle(TabBarStyleConfiguration.standard)
                }

                // Floating
                VStack {
                    Text("Floating").font(.headline)
                    TabBar(selection: $selection) {
                        TabBarItemConfiguration(tag: 0, icon: "house.fill")
                        TabBarItemConfiguration(tag: 1, icon: "magnifyingglass")
                        TabBarItemConfiguration(tag: 2, icon: "plus.circle.fill")
                        TabBarItemConfiguration(tag: 3, icon: "heart.fill", badge: .dot)
                        TabBarItemConfiguration(tag: 4, icon: "person.fill")
                    }
                    .tabBarStyle(TabBarStyleConfiguration.floating)
                }

                // Minimal
                VStack {
                    Text("Minimal").font(.headline)
                    TabBar(selection: $selection) {
                        TabBarItemConfiguration(tag: 0, icon: "square.grid.2x2")
                        TabBarItemConfiguration(tag: 1, icon: "chart.line.uptrend.xyaxis")
                        TabBarItemConfiguration(tag: 2, icon: "bell", badge: .text("New"))
                        TabBarItemConfiguration(tag: 3, icon: "gearshape")
                    }
                    .tabBarStyle(TabBarStyleConfiguration.minimal)
                }

                // Curved
                VStack {
                    Text("Curved").font(.headline)
                    TabBar(selection: $selection) {
                        TabBarItemConfiguration(tag: 0, title: "Home", icon: "house", selectedIcon: "house.fill")
                        TabBarItemConfiguration(tag: 1, title: "Explore", icon: "safari", selectedIcon: "safari.fill")
                        TabBarItemConfiguration(tag: 2, title: "Add", icon: "plus.circle", selectedIcon: "plus.circle.fill")
                        TabBarItemConfiguration(tag: 3, title: "Messages", icon: "message", selectedIcon: "message.fill", badge: .number(12))
                        TabBarItemConfiguration(tag: 4, title: "Account", icon: "person.crop.circle", selectedIcon: "person.crop.circle.fill")
                    }
                    .tabBarStyle(TabBarStyleConfiguration.curved)
                }

                Spacer()
            }
            .padding()
        }
    }

    return PreviewContent()
}

#Preview("Tab Bar with Navigation") {
    struct PreviewContent: View {
        @State private var selection = "home"

        var body: some View {
            ZStack(alignment: .bottom) {
                // Content
                TabView(selection: $selection) {
                    Color.blue.opacity(0.1)
                        .tag("home")
                        .ignoresSafeArea()

                    Color.green.opacity(0.1)
                        .tag("search")
                        .ignoresSafeArea()

                    Color.purple.opacity(0.1)
                        .tag("profile")
                        .ignoresSafeArea()
                }
                .overlay(
                    VStack {
                        Text("Selected: \(selection)")
                            .font(.largeTitle)
                            .padding()
                        Spacer()
                    }
                )

                // Custom Tab Bar
                TabBar(selection: $selection) {
                    TabBarItemConfiguration(
                        tag: "home",
                        icon: "house",
                        selectedIcon: "house.fill"
                    )
                    TabBarItemConfiguration(
                        tag: "search",
                        icon: "magnifyingglass.circle",
                        selectedIcon: "magnifyingglass.circle.fill"
                    )
                    TabBarItemConfiguration(
                        tag: "profile",
                        icon: "person.crop.circle",
                        selectedIcon: "person.crop.circle.fill",
                        badge: .number(5)
                    )
                }
                .tabBarStyle(TabBarStyleConfiguration.floating)
            }
        }
    }

    return PreviewContent()
        .preferredColorScheme(.dark)
}