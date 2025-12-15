//
//  PricingPlansView.swift
//  My_iOS_Library
//
//  Pricing plans selection view
//

import SwiftUI

// MARK: - Pricing Plans View

public struct PricingPlansView: View {
    @State private var selectedPlan: SubscriptionPlan?
    @State private var billingInterval: BillingInterval = .monthly
    @Environment(\.theme) private var theme

    let plans: [SubscriptionPlan]
    let onSelectPlan: (SubscriptionPlan) -> Void

    public init(
        plans: [SubscriptionPlan]? = nil,
        onSelectPlan: @escaping (SubscriptionPlan) -> Void
    ) {
        self.plans = plans ?? SubscriptionPlan.samplePlans
        self.onSelectPlan = onSelectPlan
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 16) {
                    Text("Choose Your Plan")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Select the perfect plan for your needs")
                        .font(.body)
                        .foregroundColor(.secondary)

                    // Billing Toggle
                    if plans.contains(where: { $0.interval != .lifetime }) {
                        BillingToggle(selection: $billingInterval)
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal)

                // Plans
                VStack(spacing: 16) {
                    ForEach(filteredPlans) { plan in
                        PlanCard(
                            plan: plan,
                            isSelected: selectedPlan?.id == plan.id,
                            onSelect: {
                                withAnimation(.spring()) {
                                    selectedPlan = plan
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)

                // Continue Button
                if selectedPlan != nil {
                    Button(action: {
                        if let plan = selectedPlan {
                            onSelectPlan(plan)
                        }
                    }) {
                        Text("Continue with \(selectedPlan?.name ?? "")")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(selectedPlan?.colorTheme.primary ?? .blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .padding(.vertical, 30)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }

    private var filteredPlans: [SubscriptionPlan] {
        if billingInterval == .yearly {
            // Apply yearly discount (20% off)
            return plans.map { plan in
                if plan.price.amount == 0 { return plan }

                var yearlyPlan = plan
                let yearlyAmount = plan.price.amount * 12 * 0.8 // 20% discount
                let yearlyPrice = Price(amount: yearlyAmount, currency: plan.price.currency)

                return SubscriptionPlan(
                    id: plan.id,
                    name: plan.name,
                    price: yearlyPrice,
                    interval: .yearly,
                    features: plan.features,
                    isPopular: plan.isPopular,
                    colorTheme: plan.colorTheme
                )
            }
        }
        return plans
    }
}

// MARK: - Plan Card

struct PlanCard: View {
    @Environment(\.theme) private var theme
    let plan: SubscriptionPlan
    let isSelected: Bool
    let onSelect: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 0) {
                // Header
                ZStack {
                    plan.colorTheme.gradient
                        .opacity(isSelected ? 1 : 0.8)

                    VStack(spacing: 8) {
                        if plan.isPopular {
                            Text("MOST POPULAR")
                                .font(.caption.bold())
                                .foregroundColor(.white.opacity(0.9))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(12)
                        }

                        Text(plan.name)
                            .font(.title2.bold())
                            .foregroundColor(.white)

                        HStack(alignment: .top, spacing: 2) {
                            Text(plan.price.currency.symbol)
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.8))
                                .offset(y: 4)

                            Text(String(format: "%.0f", plan.price.amount))
                                .font(.system(size: 42, weight: .bold))
                                .foregroundColor(.white)

                            Text(plan.interval.shortName)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.8))
                                .offset(y: 20)
                        }
                    }
                    .padding(.vertical, 30)
                }

                // Features
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(plan.features) { feature in
                        PlanFeatureRow(feature: feature, planColor: plan.colorTheme.primary)
                    }
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(UIColor.systemBackground))
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(
                        isSelected ? plan.colorTheme.primary : Color.clear,
                        lineWidth: 3
                    )
            )
            .shadow(
                color: isSelected ? plan.colorTheme.primary.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 20 : 10,
                y: isSelected ? 10 : 5
            )
            .scaleEffect(isHovered ? 1.02 : 1)
            .animation(.spring(response: 0.3), value: isHovered)
            .animation(.spring(response: 0.4), value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Plan Feature Row

struct PlanFeatureRow: View {
    let feature: PlanFeature
    let planColor: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: feature.isIncluded ? "checkmark.circle.fill" : "xmark.circle")
                .font(.body)
                .foregroundColor(feature.isIncluded ? planColor : .gray.opacity(0.5))

            Text(feature.title)
                .font(.body)
                .foregroundColor(feature.isIncluded ? .primary : .secondary)
                .strikethrough(!feature.isIncluded, color: .secondary)

            if let tooltip = feature.tooltip {
                Image(systemName: "info.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .help(tooltip)
            }

            Spacer()
        }
    }
}

// MARK: - Billing Toggle

struct BillingToggle: View {
    @Binding var selection: BillingInterval

    var body: some View {
        HStack(spacing: 0) {
            ForEach([BillingInterval.monthly, .yearly], id: \.self) { interval in
                Button(action: {
                    withAnimation(.spring()) {
                        selection = interval
                    }
                }) {
                    VStack(spacing: 4) {
                        Text(interval.displayName)
                            .font(.body.bold())
                            .foregroundColor(selection == interval ? .white : .primary)

                        if interval == .yearly {
                            Text("Save 20%")
                                .font(.caption)
                                .foregroundColor(selection == interval ? .white.opacity(0.8) : .green)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background(
                        selection == interval ? Color.blue : Color.clear
                    )
                }
            }
        }
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Preview

#Preview {
    PricingPlansView { plan in
        print("Selected plan: \(plan.name)")
    }
}