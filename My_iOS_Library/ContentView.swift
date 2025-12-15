//
//  ContentView.swift
//  My_iOS_Library
//
//  Created by Maël Suard on 01/12/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedDemo = 0

    var body: some View {
        TabView(selection: $selectedDemo) {
            ThemeAndTypographyShowcase()
                .tabItem {
                    Label("Design System", systemImage: "paintbrush.fill")
                }
                .tag(0)

            NavigationDemo()
                .tabItem {
                    Label("Navigation", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                }
                .tag(1)

            NavigationGuide()
                .tabItem {
                    Label("Guide", systemImage: "book.fill")
                }
                .tag(2)

            MVVMDemo()
                .tabItem {
                    Label("MVVM", systemImage: "rectangle.3.group.fill")
                }
                .tag(3)

            OnboardingShowcase()
                .tabItem {
                    Label("Onboarding", systemImage: "person.crop.circle.badge.checkmark")
                }
                .tag(4)

            CheckoutDemo()
                .tabItem {
                    Label("Checkout", systemImage: "creditcard.fill")
                }
                .tag(5)
        }
    }
}

#Preview {
    ContentView()
        .theme(DefaultTheme())
        .typography(DefaultTypography())
        .spacing(DefaultSpacing())
}
