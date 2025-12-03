//
//  SkeletonLoader.swift
//  My_iOS_Library
//
//  Animated skeleton loading placeholder with shimmer effect
//
//  Usage:
//  ```swift
//  SkeletonLoader()
//      .skeleton(shape: .rectangle)
//      .frame(height: 100)
//  ```
//
//  Customization:
//  - Shapes: rectangle, circle, rounded rectangle
//  - Animation: shimmer, pulse, or none
//  - Colors: base and highlight colors
//  - Speed: animation duration
//
//  Dependencies: None
//  iOS Requirement: 15.0+
//

import SwiftUI
import UIKit

// MARK: - Skeleton Loader

public struct SkeletonLoader: View {
    // MARK: - Properties

    @State private var animationProgress: CGFloat = 0
    @Environment(\.skeletonStyle) private var style
    @Environment(\.colorScheme) private var colorScheme

    private let animationTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    // MARK: - Body

    public var body: some View {
        GeometryReader { geometry in
            shapeView
                .overlay(animationOverlay(in: geometry))
                .onReceive(animationTimer) { _ in
                    updateAnimation()
                }
                .onDisappear {
                    animationProgress = 0
                }
        }
    }

    // MARK: - Shape

    @ViewBuilder
    private var shapeView: some View {
        switch style.shape {
        case .rectangle:
            Rectangle()
                .fill(style.baseColor(colorScheme))

        case .roundedRectangle(let cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(style.baseColor(colorScheme))

        case .circle:
            Circle()
                .fill(style.baseColor(colorScheme))

        case .capsule:
            Capsule()
                .fill(style.baseColor(colorScheme))
        }
    }

    // MARK: - Animation Overlay

    @ViewBuilder
    private func animationOverlay(in geometry: GeometryProxy) -> some View {
        switch style.animation {
        case .shimmer:
            shimmerOverlay(in: geometry)

        case .pulse:
            pulseOverlay

        case .none:
            EmptyView()
        }
    }

    private func shimmerOverlay(in geometry: GeometryProxy) -> some View {
        LinearGradient(
            gradient: Gradient(colors: [
                style.baseColor(colorScheme),
                style.highlightColor(colorScheme),
                style.baseColor(colorScheme)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .mask(
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .black, location: 0),
                            .init(color: .black, location: 0.4),
                            .init(color: .clear, location: 0.5),
                            .init(color: .black, location: 0.6),
                            .init(color: .black, location: 1)
                        ]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .offset(x: -geometry.size.width + (geometry.size.width * 3 * animationProgress))
        )
    }

    private var pulseOverlay: some View {
        style.highlightColor(colorScheme)
            .opacity(0.7 * Darwin.sin(animationProgress * .pi))
    }

    // MARK: - Animation

    private func updateAnimation() {
        withAnimation(.linear(duration: 0.1)) {
            animationProgress += 0.1 / style.animationDuration

            if animationProgress >= 1.0 {
                animationProgress = 0
            }
        }
    }
}

// MARK: - Skeleton Style

public struct SkeletonStyleConfiguration {
    public enum Shape {
        case rectangle
        case roundedRectangle(cornerRadius: CGFloat)
        case circle
        case capsule
    }

    public enum Animation {
        case shimmer
        case pulse
        case none
    }

    public let shape: Shape
    public let animation: Animation
    public let baseColor: (ColorScheme) -> Color
    public let highlightColor: (ColorScheme) -> Color
    public let animationDuration: TimeInterval

    // Predefined styles
    public static let `default` = SkeletonStyleConfiguration(
        shape: .rectangle,
        animation: .shimmer,
        baseColor: { $0 == .dark ? Color.gray.opacity(0.3) : Color.gray.opacity(0.2) },
        highlightColor: { $0 == .dark ? Color.gray.opacity(0.5) : Color.gray.opacity(0.3) },
        animationDuration: 1.5
    )

    public static let rounded = SkeletonStyleConfiguration(
        shape: .roundedRectangle(cornerRadius: 8),
        animation: .shimmer,
        baseColor: SkeletonStyleConfiguration.default.baseColor,
        highlightColor: SkeletonStyleConfiguration.default.highlightColor,
        animationDuration: 1.5
    )

    public static let circular = SkeletonStyleConfiguration(
        shape: .circle,
        animation: .shimmer,
        baseColor: SkeletonStyleConfiguration.default.baseColor,
        highlightColor: SkeletonStyleConfiguration.default.highlightColor,
        animationDuration: 1.5
    )

    public static let pulse = SkeletonStyleConfiguration(
        shape: .roundedRectangle(cornerRadius: 8),
        animation: .pulse,
        baseColor: SkeletonStyleConfiguration.default.baseColor,
        highlightColor: SkeletonStyleConfiguration.default.highlightColor,
        animationDuration: 1.0
    )
}

// MARK: - Environment Key

private struct SkeletonStyleKey: EnvironmentKey {
    static let defaultValue = SkeletonStyleConfiguration.default
}

extension EnvironmentValues {
    var skeletonStyle: SkeletonStyleConfiguration {
        get { self[SkeletonStyleKey.self] }
        set { self[SkeletonStyleKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    public func skeletonStyle(_ style: SkeletonStyleConfiguration) -> some View {
        environment(\.skeletonStyle, style)
    }

    public func skeleton(
        shape: SkeletonStyleConfiguration.Shape,
        animation: SkeletonStyleConfiguration.Animation = .shimmer
    ) -> some View {
        self.modifier(SkeletonModifier(shape: shape, animation: animation))
    }

    public func skeletonAnimation(_ animation: SkeletonStyleConfiguration.Animation) -> some View {
        self.modifier(SkeletonAnimationModifier(animation: animation))
    }

    public func skeletonColors(
        base: Color,
        highlight: Color? = nil
    ) -> some View {
        self.modifier(SkeletonColorModifier(
            baseColor: { _ in base },
            highlightColor: { _ in highlight ?? base.opacity(0.5) }
        ))
    }

    public func skeletonSpeed(_ duration: TimeInterval) -> some View {
        self.modifier(SkeletonSpeedModifier(duration: duration))
    }
}

// MARK: - Modifiers

private struct SkeletonModifier: ViewModifier {
    let shape: SkeletonStyleConfiguration.Shape
    let animation: SkeletonStyleConfiguration.Animation
    @Environment(\.skeletonStyle) private var style

    func body(content: Content) -> some View {
        let modifiedStyle = style
            .with(shape: shape)
            .with(animation: animation)
        return content.environment(\.skeletonStyle, modifiedStyle)
    }
}

private struct SkeletonAnimationModifier: ViewModifier {
    let animation: SkeletonStyleConfiguration.Animation
    @Environment(\.skeletonStyle) private var style

    func body(content: Content) -> some View {
        let modifiedStyle = style.with(animation: animation)
        return content.environment(\.skeletonStyle, modifiedStyle)
    }
}

private struct SkeletonColorModifier: ViewModifier {
    let baseColor: (ColorScheme) -> Color
    let highlightColor: (ColorScheme) -> Color
    @Environment(\.skeletonStyle) private var style

    func body(content: Content) -> some View {
        let modifiedStyle = style
            .with(baseColor: baseColor)
            .with(highlightColor: highlightColor)
        return content.environment(\.skeletonStyle, modifiedStyle)
    }
}

private struct SkeletonSpeedModifier: ViewModifier {
    let duration: TimeInterval
    @Environment(\.skeletonStyle) private var style

    func body(content: Content) -> some View {
        let modifiedStyle = style.with(animationDuration: duration)
        return content.environment(\.skeletonStyle, modifiedStyle)
    }
}

// MARK: - Style Modification Helper

extension SkeletonStyleConfiguration {
    func with(shape: Shape) -> SkeletonStyleConfiguration {
        SkeletonStyleConfiguration(
            shape: shape,
            animation: animation,
            baseColor: baseColor,
            highlightColor: highlightColor,
            animationDuration: animationDuration
        )
    }

    func with(animation: Animation) -> SkeletonStyleConfiguration {
        SkeletonStyleConfiguration(
            shape: shape,
            animation: animation,
            baseColor: baseColor,
            highlightColor: highlightColor,
            animationDuration: animationDuration
        )
    }

    func with(baseColor: @escaping (ColorScheme) -> Color) -> SkeletonStyleConfiguration {
        SkeletonStyleConfiguration(
            shape: shape,
            animation: animation,
            baseColor: baseColor,
            highlightColor: highlightColor,
            animationDuration: animationDuration
        )
    }

    func with(highlightColor: @escaping (ColorScheme) -> Color) -> SkeletonStyleConfiguration {
        SkeletonStyleConfiguration(
            shape: shape,
            animation: animation,
            baseColor: baseColor,
            highlightColor: highlightColor,
            animationDuration: animationDuration
        )
    }

    func with(animationDuration: TimeInterval) -> SkeletonStyleConfiguration {
        SkeletonStyleConfiguration(
            shape: shape,
            animation: animation,
            baseColor: baseColor,
            highlightColor: highlightColor,
            animationDuration: animationDuration
        )
    }
}

// MARK: - Skeleton Layouts

public struct SkeletonList: View {
    let itemCount: Int
    let itemHeight: CGFloat
    let spacing: CGFloat

    public init(
        itemCount: Int = 5,
        itemHeight: CGFloat = 80,
        spacing: CGFloat = 12
    ) {
        self.itemCount = itemCount
        self.itemHeight = itemHeight
        self.spacing = spacing
    }

    public var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<itemCount, id: \.self) { _ in
                SkeletonListItem()
                    .frame(height: itemHeight)
            }
        }
    }
}

public struct SkeletonListItem: View {
    public var body: some View {
        HStack(spacing: 16) {
            SkeletonLoader()
                .skeleton(shape: .circle)
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 8) {
                SkeletonLoader()
                    .skeleton(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(height: 20)

                SkeletonLoader()
                    .skeleton(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(width: 200, height: 16)
            }

            Spacer()
        }
    }
}

public struct SkeletonGrid: View {
    let columns: Int
    let rows: Int
    let spacing: CGFloat

    public init(
        columns: Int = 2,
        rows: Int = 3,
        spacing: CGFloat = 16
    ) {
        self.columns = columns
        self.rows = rows
        self.spacing = spacing
    }

    public var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns),
            spacing: spacing
        ) {
            ForEach(0..<(columns * rows), id: \.self) { _ in
                SkeletonGridItem()
            }
        }
    }
}

public struct SkeletonGridItem: View {
    public var body: some View {
        VStack(spacing: 12) {
            SkeletonLoader()
                .skeleton(shape: .roundedRectangle(cornerRadius: 8))
                .aspectRatio(1, contentMode: .fit)

            VStack(spacing: 6) {
                SkeletonLoader()
                    .skeleton(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(height: 16)

                SkeletonLoader()
                    .skeleton(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(height: 14)
                    .opacity(0.7)
            }
        }
    }
}

// MARK: - Preview

#Preview("Skeleton Shapes") {
    VStack(spacing: 20) {
        // Rectangle
        SkeletonLoader()
            .skeleton(shape: .rectangle)
            .frame(height: 60)

        // Rounded Rectangle
        SkeletonLoader()
            .skeleton(shape: .roundedRectangle(cornerRadius: 16))
            .frame(height: 60)

        // Circle
        HStack(spacing: 20) {
            SkeletonLoader()
                .skeleton(shape: .circle)
                .frame(width: 60, height: 60)

            SkeletonLoader()
                .skeleton(shape: .circle)
                .frame(width: 80, height: 80)
        }

        // Capsule
        SkeletonLoader()
            .skeleton(shape: .capsule)
            .frame(width: 200, height: 40)
    }
    .padding()
}

#Preview("Skeleton Animations") {
    VStack(spacing: 30) {
        VStack(alignment: .leading, spacing: 10) {
            Text("Shimmer").font(.headline)
            SkeletonLoader()
                .skeleton(shape: .roundedRectangle(cornerRadius: 8), animation: .shimmer)
                .frame(height: 60)
        }

        VStack(alignment: .leading, spacing: 10) {
            Text("Pulse").font(.headline)
            SkeletonLoader()
                .skeleton(shape: .roundedRectangle(cornerRadius: 8), animation: .pulse)
                .frame(height: 60)
        }

        VStack(alignment: .leading, spacing: 10) {
            Text("No Animation").font(.headline)
            SkeletonLoader()
                .skeleton(shape: .roundedRectangle(cornerRadius: 8), animation: .none)
                .frame(height: 60)
        }

        VStack(alignment: .leading, spacing: 10) {
            Text("Custom Colors").font(.headline)
            SkeletonLoader()
                .skeleton(shape: .roundedRectangle(cornerRadius: 8))
                .skeletonColors(base: .blue.opacity(0.1), highlight: .blue.opacity(0.3))
                .frame(height: 60)
        }

        VStack(alignment: .leading, spacing: 10) {
            Text("Fast Animation").font(.headline)
            SkeletonLoader()
                .skeleton(shape: .roundedRectangle(cornerRadius: 8))
                .skeletonSpeed(0.8)
                .frame(height: 60)
        }
    }
    .padding()
}

#Preview("Skeleton Layouts") {
    ScrollView {
        VStack(spacing: 30) {
            VStack(alignment: .leading, spacing: 10) {
                Text("List Layout").font(.headline)
                SkeletonList(itemCount: 3)
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                Text("Grid Layout").font(.headline)
                SkeletonGrid(columns: 2, rows: 2)
            }
        }
        .padding()
    }
}