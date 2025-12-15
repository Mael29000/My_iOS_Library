//
//  CheckoutDemo.swift
//  My_iOS_Library
//
//  Checkout flow demonstration
//

import SwiftUI

// MARK: - Checkout Demo

public struct CheckoutDemo: View {
    @State private var showCheckout = false
    @State private var showStandaloneViews = false
    @State private var selectedView = 0
    @Environment(\.theme) private var theme

    public init() {}

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    // Hero Section
                    VStack(spacing: 16) {
                        Image(systemName: "creditcard.circle.fill")
                            .font(.system(size: 80))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text("Checkout Flow Demo")
                            .font(.largeTitle.bold())

                        Text("Professional subscription and payment UI")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)

                    // Demo Options
                    VStack(spacing: 16) {
                        // Full Checkout Flow
                        DemoCard(
                            icon: "cart.fill",
                            title: "Complete Checkout Flow",
                            description: "Experience the full checkout journey from plan selection to payment confirmation",
                            color: .blue
                        ) {
                            showCheckout = true
                        }

                        // Standalone Views
                        DemoCard(
                            icon: "square.stack.3d.up",
                            title: "Individual Components",
                            description: "Explore pricing plans, payment forms, and confirmation screens separately",
                            color: .purple
                        ) {
                            showStandaloneViews = true
                        }
                    }
                    .padding(.horizontal)

                    // Features
                    FeaturesSection()

                    // Implementation Guide
                    ImplementationSection()
                }
                .padding(.bottom, 30)
            }
            .navigationTitle("Checkout System")
            .fullScreenCover(isPresented: $showCheckout) {
                CheckoutFlowView { plan, method in
                    print("Purchased \(plan.name) with \(method.rawValue)")
                }
            }
            .sheet(isPresented: $showStandaloneViews) {
                StandaloneViewsSheet(selectedView: $selectedView)
            }
        }
    }
}

// MARK: - Demo Card

struct DemoCard: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(color.gradient.opacity(0.2))
                        .frame(width: 60, height: 60)

                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                }

                // Text
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "arrow.right.circle.fill")
                    .font(.title2)
                    .foregroundColor(color)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(16)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Features Section

struct FeaturesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Features")
                .font(.title2.bold())
                .padding(.horizontal)

            VStack(spacing: 12) {
                FeatureItem(icon: "square.3.layers.3d", text: "Multiple pricing tiers with feature comparison")
                FeatureItem(icon: "calendar", text: "Monthly/Yearly billing toggle with discounts")
                FeatureItem(icon: "creditcard", text: "Credit card form with validation")
                FeatureItem(icon: "applelogo", text: "Apple Pay integration ready")
                FeatureItem(icon: "lock.shield", text: "Secure payment UI with trust badges")
                FeatureItem(icon: "checkmark.circle", text: "Beautiful confirmation animations")
            }
            .padding(.horizontal)
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundColor(.blue)
                .frame(width: 30)

            Text(text)
                .font(.body)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Implementation Section

struct ImplementationSection: View {
    @State private var showCode = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Implementation")
                .font(.title2.bold())

            Text("The checkout system is designed to be easily integrated with your payment backend:")
                .font(.body)
                .foregroundColor(.secondary)

            Button(action: { showCode.toggle() }) {
                HStack {
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(showCode ? 90 : 0))
                    Text("View Code Example")
                        .font(.body.bold())
                }
                .foregroundColor(.blue)
            }

            if showCode {
                ScrollView(.horizontal, showsIndicators: false) {
                    Text("""
// Basic usage
CheckoutFlowView { plan, paymentMethod in
    // Handle purchase
    await purchaseSubscription(
        plan: plan,
        method: paymentMethod
    )
}

// Custom plans
let plans = [
    SubscriptionPlan(
        id: "basic",
        name: "Basic",
        price: Price(amount: 4.99),
        features: [...]
    ),
    // More plans...
]

PricingPlansView(plans: plans) { selected in
    // Handle selection
}
""")
                    .font(.system(.caption, design: .monospaced))
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Standalone Views Sheet

struct StandaloneViewsSheet: View {
    @Binding var selectedView: Int
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            TabView(selection: $selectedView) {
                // Pricing Plans
                PricingPlansView { plan in
                    print("Selected: \(plan.name)")
                }
                .tabItem {
                    Label("Plans", systemImage: "square.3.layers.3d")
                }
                .tag(0)

                // Payment Form
                NavigationView {
                    PaymentView(plan: SubscriptionPlan.samplePlans[1]) { method, details in
                        print("Payment: \(method.rawValue)")
                    }
                }
                .tabItem {
                    Label("Payment", systemImage: "creditcard")
                }
                .tag(1)

                // Confirmation
                ConfirmationView(
                    plan: SubscriptionPlan.samplePlans[1],
                    paymentMethod: .applePay
                )
                .tabItem {
                    Label("Success", systemImage: "checkmark.circle")
                }
                .tag(2)
            }
            .navigationTitle("Components")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    CheckoutDemo()
        .theme(DefaultTheme())
}