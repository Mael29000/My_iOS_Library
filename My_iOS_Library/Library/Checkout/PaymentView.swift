//
//  PaymentView.swift
//  My_iOS_Library
//
//  Payment method and credit card form
//

import SwiftUI

// MARK: - Payment View

public struct PaymentView: View {
    @State private var selectedPaymentMethod: PaymentMethod = .creditCard
    @State private var cardDetails = CardDetails()
    @State private var saveCard = true
    @State private var agreeToTerms = false
    @State private var showingCardScanner = false
    @FocusState private var focusedField: CardField?

    @Environment(\.theme) private var theme

    let plan: SubscriptionPlan
    let onComplete: (PaymentMethod, CardDetails?) -> Void

    enum CardField {
        case number, name, expiry, cvv
    }

    public init(
        plan: SubscriptionPlan,
        onComplete: @escaping (PaymentMethod, CardDetails?) -> Void
    ) {
        self.plan = plan
        self.onComplete = onComplete
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 8) {
                    Text("Payment Details")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    Text("Complete your purchase of \(plan.name)")
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                // Order Summary
                OrderSummaryCard(plan: plan)

                // Payment Methods
                VStack(alignment: .leading, spacing: 16) {
                    Text("Payment Method")
                        .font(.headline)

                    VStack(spacing: 12) {
                        ForEach(PaymentMethod.allCases, id: \.self) { method in
                            if method.isAvailable {
                                PaymentMethodRow(
                                    method: method,
                                    isSelected: selectedPaymentMethod == method,
                                    onSelect: {
                                        withAnimation {
                                            selectedPaymentMethod = method
                                        }
                                    }
                                )
                            }
                        }
                    }
                }

                // Credit Card Form
                if selectedPaymentMethod == .creditCard {
                    CreditCardForm(
                        cardDetails: $cardDetails,
                        focusedField: $focusedField,
                        showScanner: $showingCardScanner
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }

                // Apple Pay Button
                if selectedPaymentMethod == .applePay {
                    ApplePayButton()
                        .transition(.opacity.combined(with: .scale))
                }

                // Save Card & Terms
                VStack(spacing: 16) {
                    if selectedPaymentMethod == .creditCard {
                        Toggle(isOn: $saveCard) {
                            Text("Save card for future purchases")
                                .font(.body)
                        }
                        .tint(.blue)
                    }

                    HStack(spacing: 8) {
                        Toggle(isOn: $agreeToTerms) {
                            HStack(spacing: 4) {
                                Text("I agree to the")
                                    .font(.footnote)
                                Button("Terms of Service") {
                                    // Show terms
                                }
                                .font(.footnote)
                                .foregroundColor(.blue)
                                Text("and")
                                    .font(.footnote)
                                Button("Privacy Policy") {
                                    // Show privacy
                                }
                                .font(.footnote)
                                .foregroundColor(.blue)
                            }
                        }
                        .tint(.blue)
                    }
                }

                // Pay Button
                Button(action: handlePayment) {
                    HStack {
                        Image(systemName: "lock.fill")
                            .font(.body)

                        Text("Pay \(plan.price.displayPrice)")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        isFormValid ? plan.colorTheme.primary : Color.gray
                    )
                    .cornerRadius(12)
                }
                .disabled(!isFormValid)

                // Security Badge
                SecurityBadge()
            }
            .padding()
        }
        .background(Color(UIColor.systemGroupedBackground))
        .sheet(isPresented: $showingCardScanner) {
            Text("Card Scanner Placeholder")
                .presentationDetents([.medium])
        }
    }

    private var isFormValid: Bool {
        agreeToTerms && (
            selectedPaymentMethod == .applePay ||
            (selectedPaymentMethod == .creditCard && cardDetails.isValid)
        )
    }

    private func handlePayment() {
        let details = selectedPaymentMethod == .creditCard ? cardDetails : nil
        onComplete(selectedPaymentMethod, details)
    }
}

// MARK: - Order Summary Card

struct OrderSummaryCard: View {
    let plan: SubscriptionPlan

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Order Summary")
                    .font(.headline)
                Spacer()
            }

            VStack(spacing: 12) {
                HStack {
                    Text("\(plan.name) Plan")
                        .font(.body)
                    Spacer()
                    Text(plan.price.displayPrice)
                        .font(.body.bold())
                }

                if plan.interval != .lifetime {
                    HStack {
                        Text("Billing")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(plan.interval.displayName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Divider()

                HStack {
                    Text("Total")
                        .font(.body.bold())
                    Spacer()
                    Text(plan.price.displayPrice)
                        .font(.title3.bold())
                        .foregroundColor(plan.colorTheme.primary)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

// MARK: - Payment Method Row

struct PaymentMethodRow: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                Image(systemName: method.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .primary)
                    .frame(width: 40)

                Text(method.rawValue)
                    .font(.body)
                    .foregroundColor(isSelected ? .white : .primary)

                Spacer()

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .white : .secondary)
            }
            .padding()
            .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Credit Card Form

struct CreditCardForm: View {
    @Binding var cardDetails: CardDetails
    var focusedField: FocusState<PaymentView.CardField?>.Binding
    @Binding var showScanner: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Card Information")
                .font(.headline)

            VStack(spacing: 16) {
                // Card Number
                HStack {
                    TextField("Card Number", text: $cardDetails.number)
                        .keyboardType(.numberPad)
                        .focused(focusedField, equals: .number)
                        .onChange(of: cardDetails.number) { newValue in
                            // Format card number
                            let cleaned = newValue.replacingOccurrences(of: " ", with: "")
                            if cleaned.count <= 16 {
                                cardDetails.number = cleaned
                            }
                        }

                    Button(action: { showScanner = true }) {
                        Image(systemName: "camera")
                            .foregroundColor(.blue)
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .cornerRadius(12)

                // Card Holder Name
                TextField("Card Holder Name", text: $cardDetails.holderName)
                    .textContentType(.name)
                    .focused(focusedField, equals: .name)
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(12)

                // Expiry and CVV
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        TextField("MM", text: $cardDetails.expiryMonth)
                            .keyboardType(.numberPad)
                            .frame(width: 40)
                            .multilineTextAlignment(.center)
                            .onChange(of: cardDetails.expiryMonth) { newValue in
                                if newValue.count > 2 {
                                    cardDetails.expiryMonth = String(newValue.prefix(2))
                                }
                            }

                        Text("/")
                            .foregroundColor(.secondary)

                        TextField("YY", text: $cardDetails.expiryYear)
                            .keyboardType(.numberPad)
                            .frame(width: 40)
                            .multilineTextAlignment(.center)
                            .onChange(of: cardDetails.expiryYear) { newValue in
                                if newValue.count > 2 {
                                    cardDetails.expiryYear = String(newValue.prefix(2))
                                }
                            }
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(12)

                    TextField("CVV", text: $cardDetails.cvv)
                        .keyboardType(.numberPad)
                        .focused(focusedField, equals: .cvv)
                        .frame(width: 80)
                        .onChange(of: cardDetails.cvv) { newValue in
                            if newValue.count > 4 {
                                cardDetails.cvv = String(newValue.prefix(4))
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(12)
                }
            }
        }
    }
}

// MARK: - Apple Pay Button

struct ApplePayButton: View {
    var body: some View {
        VStack(spacing: 16) {
            // Mock Apple Pay button
            Button(action: {
                // Handle Apple Pay
            }) {
                HStack {
                    Image(systemName: "applelogo")
                    Text("Pay")
                }
                .font(.title3.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.black)
                .cornerRadius(12)
            }

            Text("Double click to pay with Apple Pay")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Security Badge

struct SecurityBadge: View {
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "lock.shield.fill")
                .font(.title3)
                .foregroundColor(.green)

            VStack(alignment: .leading, spacing: 2) {
                Text("Secure Payment")
                    .font(.footnote.bold())

                Text("Your payment info is encrypted and secure")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.green.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Preview

#Preview {
    PaymentView(plan: SubscriptionPlan.samplePlans[1]) { method, details in
        print("Payment method: \(method)")
    }
}