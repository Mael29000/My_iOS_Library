//
//  Spacing.swift
//  My_iOS_Library
//
//  Spacing system for consistent layout throughout the app
//

import SwiftUI

// MARK: - Spacing Protocol

public protocol SpacingProtocol {
    /// No spacing (0)
    var none: CGFloat { get }

    /// Extra extra small spacing (2)
    var xxs: CGFloat { get }

    /// Extra small spacing (4)
    var xs: CGFloat { get }

    /// Small spacing (8)
    var sm: CGFloat { get }

    /// Medium spacing (12)
    var md: CGFloat { get }

    /// Large spacing (16)
    var lg: CGFloat { get }

    /// Extra large spacing (24)
    var xl: CGFloat { get }

    /// 2x extra large spacing (32)
    var xxl: CGFloat { get }

    /// 3x extra large spacing (40)
    var xxxl: CGFloat { get }

    /// 4x extra large spacing (48)
    var xxxxl: CGFloat { get }

    /// Custom multiplier for dynamic spacing
    func custom(_ multiplier: CGFloat) -> CGFloat
}

// MARK: - Default Spacing

public struct DefaultSpacing: SpacingProtocol {
    // Base unit for spacing
    private let baseUnit: CGFloat

    public init(baseUnit: CGFloat = 4) {
        self.baseUnit = baseUnit
    }

    // MARK: - Spacing Values

    public var none: CGFloat { 0 }
    public var xxs: CGFloat { baseUnit * 0.5 }    // 2
    public var xs: CGFloat { baseUnit * 1 }       // 4
    public var sm: CGFloat { baseUnit * 2 }       // 8
    public var md: CGFloat { baseUnit * 3 }       // 12
    public var lg: CGFloat { baseUnit * 4 }       // 16
    public var xl: CGFloat { baseUnit * 6 }       // 24
    public var xxl: CGFloat { baseUnit * 8 }      // 32
    public var xxxl: CGFloat { baseUnit * 10 }    // 40
    public var xxxxl: CGFloat { baseUnit * 12 }   // 48

    public func custom(_ multiplier: CGFloat) -> CGFloat {
        baseUnit * multiplier
    }
}

// MARK: - Compact Spacing

/// Spacing for compact layouts (like watches or widgets)
public struct CompactSpacing: SpacingProtocol {
    private let baseUnit: CGFloat = 2

    public var none: CGFloat { 0 }
    public var xxs: CGFloat { baseUnit * 0.5 }    // 1
    public var xs: CGFloat { baseUnit * 1 }       // 2
    public var sm: CGFloat { baseUnit * 2 }       // 4
    public var md: CGFloat { baseUnit * 3 }       // 6
    public var lg: CGFloat { baseUnit * 4 }       // 8
    public var xl: CGFloat { baseUnit * 6 }       // 12
    public var xxl: CGFloat { baseUnit * 8 }      // 16
    public var xxxl: CGFloat { baseUnit * 10 }    // 20
    public var xxxxl: CGFloat { baseUnit * 12 }   // 24

    public func custom(_ multiplier: CGFloat) -> CGFloat {
        baseUnit * multiplier
    }
}

// MARK: - Generous Spacing

/// Spacing for more generous layouts (like iPad or macOS)
public struct GenerousSpacing: SpacingProtocol {
    private let baseUnit: CGFloat = 8

    public var none: CGFloat { 0 }
    public var xxs: CGFloat { baseUnit * 0.5 }    // 4
    public var xs: CGFloat { baseUnit * 1 }       // 8
    public var sm: CGFloat { baseUnit * 2 }       // 16
    public var md: CGFloat { baseUnit * 3 }       // 24
    public var lg: CGFloat { baseUnit * 4 }       // 32
    public var xl: CGFloat { baseUnit * 6 }       // 48
    public var xxl: CGFloat { baseUnit * 8 }      // 64
    public var xxxl: CGFloat { baseUnit * 10 }    // 80
    public var xxxxl: CGFloat { baseUnit * 12 }   // 96

    public func custom(_ multiplier: CGFloat) -> CGFloat {
        baseUnit * multiplier
    }
}

// MARK: - Spacing Environment Key

private struct SpacingKey: EnvironmentKey {
    static let defaultValue: any SpacingProtocol = DefaultSpacing()
}

extension EnvironmentValues {
    public var spacing: any SpacingProtocol {
        get { self[SpacingKey.self] }
        set { self[SpacingKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    /// Sets the spacing system for this view hierarchy
    public func spacing(_ spacing: any SpacingProtocol) -> some View {
        environment(\.spacing, spacing)
    }

    // MARK: - Padding Extensions

    /// Applies semantic padding
    public func padding(_ size: SpacingSize) -> some View {
        self.modifier(SpacingPaddingModifier(size: size, edges: .all))
    }

    /// Applies semantic padding to specific edges
    public func padding(_ edges: Edge.Set, _ size: SpacingSize) -> some View {
        self.modifier(SpacingPaddingModifier(size: size, edges: edges))
    }

    /// Applies semantic horizontal padding
    public func paddingHorizontal(_ size: SpacingSize) -> some View {
        self.modifier(SpacingPaddingModifier(size: size, edges: .horizontal))
    }

    /// Applies semantic vertical padding
    public func paddingVertical(_ size: SpacingSize) -> some View {
        self.modifier(SpacingPaddingModifier(size: size, edges: .vertical))
    }

    // MARK: - Spacing Views

    /// Adds semantic spacing
    public func spacing(_ size: SpacingSize, edge: Edge) -> some View {
        self.modifier(SpacingModifier(size: size, edge: edge))
    }
}

// MARK: - Spacing Size Enum

public enum SpacingSize {
    case none
    case xxs
    case xs
    case sm
    case md
    case lg
    case xl
    case xxl
    case xxxl
    case xxxxl
    case custom(CGFloat)
}

// MARK: - Spacing Padding Modifier

struct SpacingPaddingModifier: ViewModifier {
    @Environment(\.spacing) private var spacing

    let size: SpacingSize
    let edges: Edge.Set

    func body(content: Content) -> some View {
        content.padding(edges, value)
    }

    private var value: CGFloat {
        switch size {
        case .none: return spacing.none
        case .xxs: return spacing.xxs
        case .xs: return spacing.xs
        case .sm: return spacing.sm
        case .md: return spacing.md
        case .lg: return spacing.lg
        case .xl: return spacing.xl
        case .xxl: return spacing.xxl
        case .xxxl: return spacing.xxxl
        case .xxxxl: return spacing.xxxxl
        case .custom(let value): return spacing.custom(value)
        }
    }
}

// MARK: - Spacing Modifier

struct SpacingModifier: ViewModifier {
    @Environment(\.spacing) private var spacing

    let size: SpacingSize
    let edge: Edge

    func body(content: Content) -> some View {
        content.padding(EdgeInsets(
            top: edge == .top ? value : 0,
            leading: edge == .leading ? value : 0,
            bottom: edge == .bottom ? value : 0,
            trailing: edge == .trailing ? value : 0
        ))
    }

    private var value: CGFloat {
        switch size {
        case .none: return spacing.none
        case .xxs: return spacing.xxs
        case .xs: return spacing.xs
        case .sm: return spacing.sm
        case .md: return spacing.md
        case .lg: return spacing.lg
        case .xl: return spacing.xl
        case .xxl: return spacing.xxl
        case .xxxl: return spacing.xxxl
        case .xxxxl: return spacing.xxxxl
        case .custom(let value): return spacing.custom(value)
        }
    }
}

// MARK: - Stack Helpers

/// Creates a VStack with semantic spacing
public func VStackSpacing<Content: View>(
    alignment: HorizontalAlignment = .center,
    spacing: SpacingSize,
    @ViewBuilder content: @escaping () -> Content
) -> some View {
    SpacingVStackWrapper(alignment: alignment, spacingSize: spacing, content: content)
}

/// Creates an HStack with semantic spacing
public func HStackSpacing<Content: View>(
    alignment: VerticalAlignment = .center,
    spacing: SpacingSize,
    @ViewBuilder content: @escaping () -> Content
) -> some View {
    SpacingHStackWrapper(alignment: alignment, spacingSize: spacing, content: content)
}

// MARK: - Stack Wrappers

struct SpacingVStackWrapper<Content: View>: View {
    @Environment(\.spacing) private var spacing

    let alignment: HorizontalAlignment
    let spacingSize: SpacingSize
    let content: () -> Content

    var body: some View {
        VStack(alignment: alignment, spacing: spacingValue) {
            content()
        }
    }

    private var spacingValue: CGFloat {
        switch spacingSize {
        case .none: return spacing.none
        case .xxs: return spacing.xxs
        case .xs: return spacing.xs
        case .sm: return spacing.sm
        case .md: return spacing.md
        case .lg: return spacing.lg
        case .xl: return spacing.xl
        case .xxl: return spacing.xxl
        case .xxxl: return spacing.xxxl
        case .xxxxl: return spacing.xxxxl
        case .custom(let value): return spacing.custom(value)
        }
    }
}

struct SpacingHStackWrapper<Content: View>: View {
    @Environment(\.spacing) private var spacing

    let alignment: VerticalAlignment
    let spacingSize: SpacingSize
    let content: () -> Content

    var body: some View {
        HStack(alignment: alignment, spacing: spacingValue) {
            content()
        }
    }

    private var spacingValue: CGFloat {
        switch spacingSize {
        case .none: return spacing.none
        case .xxs: return spacing.xxs
        case .xs: return spacing.xs
        case .sm: return spacing.sm
        case .md: return spacing.md
        case .lg: return spacing.lg
        case .xl: return spacing.xl
        case .xxl: return spacing.xxl
        case .xxxl: return spacing.xxxl
        case .xxxxl: return spacing.xxxxl
        case .custom(let value): return spacing.custom(value)
        }
    }
}

// MARK: - Spacer Extensions

extension Spacer {
    /// Creates a fixed spacer with semantic size
    public static func fixed(_ size: SpacingSize) -> some View {
        SpacingSpacer(size: size)
    }
}

struct SpacingSpacer: View {
    @Environment(\.spacing) private var spacing
    let size: SpacingSize

    var body: some View {
        Color.clear
            .frame(width: value, height: value)
    }

    private var value: CGFloat {
        switch size {
        case .none: return spacing.none
        case .xxs: return spacing.xxs
        case .xs: return spacing.xs
        case .sm: return spacing.sm
        case .md: return spacing.md
        case .lg: return spacing.lg
        case .xl: return spacing.xl
        case .xxl: return spacing.xxl
        case .xxxl: return spacing.xxxl
        case .xxxxl: return spacing.xxxxl
        case .custom(let value): return spacing.custom(value)
        }
    }
}