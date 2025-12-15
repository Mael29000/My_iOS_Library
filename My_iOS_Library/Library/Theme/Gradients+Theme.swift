//
//  Gradients+Theme.swift
//  My_iOS_Library
//
//  Cool reusable gradients for the theme system
//

import SwiftUI

// MARK: - Gradient Collection

public struct ThemeGradients {

    // MARK: - Vibrant Gradients

    /// Sunset gradient - Orange to Pink
    public static var sunset: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: 0xFF6B6B),
                Color(hex: 0xFFE66D),
                Color(hex: 0xFEDA77),
                Color(hex: 0xFA8072)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Ocean gradient - Blue to Teal
    public static var ocean: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: 0x2E86DE),
                Color(hex: 0x54A0FF),
                Color(hex: 0x48DBFB),
                Color(hex: 0x0ABDE3)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Forest gradient - Green shades
    public static var forest: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: 0x11998E),
                Color(hex: 0x38EF7D),
                Color(hex: 0x6DD5ED)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Purple Dream gradient
    public static var purpleDream: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: 0x667EEA),
                Color(hex: 0x764BA2),
                Color(hex: 0xF093FB)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Warm gradient - Red to Yellow
    public static var warm: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: 0xF2994A),
                Color(hex: 0xF2C94C),
                Color(hex: 0xF8B500)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    // MARK: - Subtle Gradients

    /// Light subtle gradient
    public static var subtleLight: LinearGradient {
        LinearGradient(
            colors: [
                Color.white,
                Color.white.opacity(0.95),
                Color(hex: 0xF5F5F5)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Dark subtle gradient
    public static var subtleDark: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: 0x1C1C1E),
                Color(hex: 0x2C2C2E),
                Color(hex: 0x1C1C1E)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Radial Gradients

    /// Radial blue gradient
    public static var radialBlue: RadialGradient {
        RadialGradient(
            colors: [
                Color(hex: 0x007AFF).opacity(0.8),
                Color(hex: 0x007AFF).opacity(0.4),
                Color(hex: 0x007AFF).opacity(0.1),
                Color.clear
            ],
            center: .center,
            startRadius: 0,
            endRadius: 200
        )
    }

    /// Radial glow gradient
    public static var radialGlow: RadialGradient {
        RadialGradient(
            colors: [
                Color.white,
                Color.white.opacity(0.8),
                Color.white.opacity(0.4),
                Color.clear
            ],
            center: .center,
            startRadius: 0,
            endRadius: 150
        )
    }

    // MARK: - Angular Gradients

    /// Rainbow angular gradient
    public static var rainbow: AngularGradient {
        AngularGradient(
            colors: [
                .red, .orange, .yellow, .green,
                .blue, .purple, .pink, .red
            ],
            center: .center
        )
    }

    // MARK: - Mesh Gradients (iOS 18+)

    /// Creates a mesh gradient (iOS 18+ only)
    @available(iOS 18.0, *)
    public static var mesh: MeshGradient {
        MeshGradient(
            width: 3,
            height: 3,
            points: [
                .init(0, 0), .init(0.5, 0), .init(1, 0),
                .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
                .init(0, 1), .init(0.5, 1), .init(1, 1)
            ],
            colors: [
                Color(hex: 0xFF006E), Color(hex: 0xFF4B6A), Color(hex: 0xFF7F50),
                Color(hex: 0x8B00FF), Color(hex: 0x5E00FF), Color(hex: 0x0099FF),
                Color(hex: 0x00D4FF), Color(hex: 0x00FFE0), Color(hex: 0x00FF88)
            ]
        )
    }
}

// MARK: - Gradient View Modifiers

extension View {
    /// Applies a gradient background
    public func gradientBackground(_ gradient: LinearGradient) -> some View {
        self.background(gradient)
    }

    /// Applies a gradient overlay
    public func gradientOverlay(_ gradient: LinearGradient, opacity: Double = 1.0) -> some View {
        self.overlay(gradient.opacity(opacity))
    }

    /// Applies a gradient mask
    public func gradientMask(_ gradient: LinearGradient) -> some View {
        self.mask(gradient)
    }

    /// Creates a gradient text effect
    public func gradientForeground(_ gradient: LinearGradient) -> some View {
        self.foregroundStyle(gradient)
    }
}

// MARK: - Animated Gradient

public struct AnimatedGradient: View {
    @State private var animateGradient = false
    let colors: [Color]
    let animation: Animation

    public init(
        colors: [Color],
        animation: Animation = .linear(duration: 3).repeatForever(autoreverses: true)
    ) {
        self.colors = colors
        self.animation = animation
    }

    public var body: some View {
        LinearGradient(
            colors: animateGradient ? colors : colors.reversed(),
            startPoint: animateGradient ? .topLeading : .bottomTrailing,
            endPoint: animateGradient ? .bottomTrailing : .topLeading
        )
        .onAppear {
            withAnimation(animation) {
                animateGradient.toggle()
            }
        }
    }
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: UInt32, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255.0
        let green = Double((hex >> 8) & 0xff) / 255.0
        let blue = Double(hex & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}