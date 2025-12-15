//
//  CheckoutFlow.swift
//  My_iOS_Library
//
//  Complete checkout flow with navigation
//

import SwiftUI

// MARK: - Checkout Flow View

public struct CheckoutFlowView: View {
    @State private var currentStep: CheckoutStep = .selectPlan
    @State private var selectedPlan: SubscriptionPlan?
    @State private var paymentMethod: PaymentMethod?
    @State private var cardDetails: CardDetails?
    @State private var isProcessing = false
    @State private var showConfirmation = false

    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme

    let onComplete: ((SubscriptionPlan, PaymentMethod) -> Void)?

    public init(onComplete: ((SubscriptionPlan, PaymentMethod) -> Void)? = nil) {
        self.onComplete = onComplete
    }

    public var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()

                // Content
                VStack(spacing: 0) {
                    // Progress Bar
                    ProgressBar(currentStep: currentStep)
                        .padding()

                    // Steps
                    Group {
                        switch currentStep {
                        case .selectPlan:
                            PricingPlansView { plan in
                                selectedPlan = plan
                                withAnimation(.spring()) {
                                    currentStep = .payment
                                }
                            }
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))

                        case .payment:
                            if let plan = selectedPlan {
                                PaymentView(plan: plan) { method, details in
                                    paymentMethod = method
                                    cardDetails = details
                                    processPayment()
                                }
                                .transition(.asymmetric(
                                    insertion: .move(edge: .trailing),
                                    removal: .move(edge: .leading)
                                ))
                            }

                        case .confirmation:
                            ConfirmationView(
                                plan: selectedPlan,
                                paymentMethod: paymentMethod
                            )
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)
                            ))
                        }
                    }
                }

                // Processing Overlay
                if isProcessing {
                    ProcessingOverlay()
                }
            }
            .navigationTitle(currentStep.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if currentStep != .selectPlan {
                        Button(action: goBack) {
                            Image(systemName: "chevron.left")
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .interactiveDismissDisabled(isProcessing)
        }
    }

    private func goBack() {
        withAnimation(.spring()) {
            switch currentStep {
            case .payment:
                currentStep = .selectPlan
            case .confirmation:
                currentStep = .payment
            default:
                break
            }
        }
    }

    private func processPayment() {
        isProcessing = true

        // Simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring()) {
                isProcessing = false
                currentStep = .confirmation
                showConfirmation = true
            }

            // Call completion handler
            if let plan = selectedPlan, let method = paymentMethod {
                onComplete?(plan, method)
            }
        }
    }
}

// MARK: - Progress Bar

struct ProgressBar: View {
    let currentStep: CheckoutStep

    var progress: Double {
        Double(currentStep.rawValue + 1) / Double(CheckoutStep.allCases.count)
    }

    var body: some View {
        VStack(spacing: 8) {
            // Progress Line
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 8)

                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.spring(), value: progress)
                }
            }
            .frame(height: 8)

            // Step Labels
            HStack {
                ForEach(CheckoutStep.allCases, id: \.self) { step in
                    VStack(spacing: 4) {
                        Circle()
                            .fill(step.rawValue <= currentStep.rawValue ? Color.blue : Color.gray.opacity(0.3))
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 2)
                                    .opacity(step == currentStep ? 1 : 0)
                            )

                        Text(step.title)
                            .font(.caption2)
                            .foregroundColor(step.rawValue <= currentStep.rawValue ? .primary : .secondary)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Confirmation View

struct ConfirmationView: View {
    let plan: SubscriptionPlan?
    let paymentMethod: PaymentMethod?

    @State private var showAnimation = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // Success Animation
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 150, height: 150)
                    .scaleEffect(showAnimation ? 1 : 0.5)
                    .opacity(showAnimation ? 1 : 0)

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 80))
                    .foregroundColor(.green)
                    .scaleEffect(showAnimation ? 1 : 0.5)
                    .opacity(showAnimation ? 1 : 0)
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2), value: showAnimation)

            // Text
            VStack(spacing: 16) {
                Text("Payment Successful!")
                    .font(.largeTitle.bold())
                    .opacity(showAnimation ? 1 : 0)
                    .offset(y: showAnimation ? 0 : 20)

                Text("Welcome to \(plan?.name ?? "Pro") Plan")
                    .font(.title3)
                    .foregroundColor(.secondary)
                    .opacity(showAnimation ? 1 : 0)
                    .offset(y: showAnimation ? 0 : 20)
            }
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: showAnimation)

            // Details
            VStack(alignment: .leading, spacing: 16) {
                DetailRow(label: "Plan", value: plan?.name ?? "")
                DetailRow(label: "Amount", value: plan?.price.displayPrice ?? "")
                DetailRow(label: "Payment Method", value: paymentMethod?.rawValue ?? "")
                DetailRow(label: "Next Billing", value: nextBillingDate)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            .opacity(showAnimation ? 1 : 0)
            .offset(y: showAnimation ? 0 : 20)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.6), value: showAnimation)

            Spacer()

            // Done Button
            Button(action: {
                dismiss()
            }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .opacity(showAnimation ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.8), value: showAnimation)
        }
        .padding()
        .onAppear {
            showAnimation = true
        }
    }

    private var nextBillingDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"

        switch plan?.interval {
        case .monthly:
            return formatter.string(from: Date().addingTimeInterval(30 * 24 * 60 * 60))
        case .yearly:
            return formatter.string(from: Date().addingTimeInterval(365 * 24 * 60 * 60))
        default:
            return "Never"
        }
    }
}

// MARK: - Detail Row

struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body.bold())
        }
    }
}

// MARK: - Processing Overlay

struct ProcessingOverlay: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)

                Text("Processing Payment...")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(40)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
        }
    }
}

// MARK: - Preview

#Preview {
    CheckoutFlowView()
}