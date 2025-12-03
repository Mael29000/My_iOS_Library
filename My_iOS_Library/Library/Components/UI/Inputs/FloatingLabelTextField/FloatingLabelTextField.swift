//
//  FloatingLabelTextField.swift
//  My_iOS_Library
//
//  A text field with animated floating label, validation, and rich customization options
//
//  Usage:
//  ```swift
//  FloatingLabelTextField(
//      "Email",
//      text: $email,
//      validation: .email
//  )
//  ```
//
//  Customization:
//  - Validation: Built-in or custom validation rules
//  - Icons: Leading/trailing icons with SF Symbols
//  - Helper text: Persistent or validation-based messages
//  - Secure entry: Password field support
//
//  Dependencies: String+Extensions.swift (for validation)
//  iOS Requirement: 15.0+
//

import SwiftUI
import UIKit

// MARK: - Floating Label TextField

public struct FloatingLabelTextField: View {
    // MARK: - Properties

    private let label: String
    @Binding private var text: String
    private let placeholder: String
    private let validation: ValidationRule?
    private let leadingIcon: String?
    private let trailingIcon: String?
    private let helperText: String?
    private let isSecure: Bool
    private let keyboardType: UIKeyboardType
    private let textInputAutocapitalization: TextInputAutocapitalization?
    private let autocorrectionDisabled: Bool

    @State private var isEditing = false
    @State private var isValid = true
    @State private var validationMessage = ""
    @State private var showPassword = false

    @FocusState private var isFocused: Bool
    @Environment(\.isEnabled) private var isEnabled

    // Animation
    private var shouldFloat: Bool {
        isEditing || !text.isEmpty
    }

    // MARK: - Initialization

    public init(
        _ label: String,
        text: Binding<String>,
        placeholder: String = "",
        validation: ValidationRule? = nil,
        leadingIcon: String? = nil,
        trailingIcon: String? = nil,
        helperText: String? = nil,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        textInputAutocapitalization: TextInputAutocapitalization? = nil,
        autocorrectionDisabled: Bool = false
    ) {
        self.label = label
        self._text = text
        self.placeholder = placeholder
        self.validation = validation
        self.leadingIcon = leadingIcon
        self.trailingIcon = trailingIcon
        self.helperText = helperText
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.textInputAutocapitalization = textInputAutocapitalization
        self.autocorrectionDisabled = autocorrectionDisabled
    }

    // MARK: - Body

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ZStack(alignment: .leading) {
                // Floating label
                Text(label)
                    .font(.system(size: shouldFloat ? 12 : 16, weight: .regular, design: .default))
                    .foregroundColor(labelColor)
                    .offset(y: shouldFloat ? -20 : 0)
                    .scaleEffect(shouldFloat ? 0.8 : 1, anchor: .leading)

                // Text field with icons
                HStack(spacing: 12) {
                    if let leadingIcon = leadingIcon {
                        Image(systemName: leadingIcon)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(iconColor)
                    }

                    textFieldContent

                    if isSecure {
                        secureToggleButton
                    } else if let trailingIcon = trailingIcon {
                        Image(systemName: trailingIcon)
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .foregroundColor(iconColor)
                    }
                }
                .padding(.top, shouldFloat ? 16 : 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(backgroundView)
            .overlay(borderView)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: shouldFloat)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isEditing)
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isValid)

            // Helper/Error text
            if let message = currentHelperText {
                Text(message)
                    .font(.caption)
                    .foregroundColor(helperTextColor)
                    .padding(.horizontal, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .onChange(of: text) { _ in
            validateInput()
        }
        .onChange(of: isFocused) { newValue in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                isEditing = newValue
            }
            if !newValue {
                validateInput()
            }
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var textFieldContent: some View {
        if isSecure && !showPassword {
            SecureField(placeholder, text: $text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(textColor)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(textInputAutocapitalization)
                .autocorrectionDisabled(autocorrectionDisabled)
                .disabled(!isEnabled)
        } else {
            TextField(placeholder, text: $text)
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(textColor)
                .focused($isFocused)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(textInputAutocapitalization)
                .autocorrectionDisabled(autocorrectionDisabled)
                .disabled(!isEnabled)
        }
    }

    @ViewBuilder
    private var secureToggleButton: some View {
        Button {
            showPassword.toggle()
        } label: {
            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                .font(.system(size: 16, weight: .regular, design: .default))
                .foregroundColor(iconColor)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var backgroundView: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(backgroundColor)
    }

    @ViewBuilder
    private var borderView: some View {
        RoundedRectangle(cornerRadius: 12)
            .strokeBorder(borderColor, lineWidth: borderWidth)
    }

    // MARK: - Colors

    private var labelColor: Color {
        if !isEnabled {
            return .gray
        } else if isEditing {
            return isValid ? .accentColor : .red
        } else {
            return .gray
        }
    }

    private var textColor: Color {
        isEnabled ? .primary : .gray
    }

    private var iconColor: Color {
        if !isEnabled {
            return .gray
        } else if isEditing {
            return isValid ? .accentColor : .red
        } else {
            return .gray.opacity(0.6)
        }
    }

    private var backgroundColor: Color {
        if !isEnabled {
            return Color.gray.opacity(0.1)
        } else if isEditing {
            return Color.accentColor.opacity(0.05)
        } else {
            return Color.gray.opacity(0.05)
        }
    }

    private var borderColor: Color {
        if !isEnabled {
            return .clear
        } else if !isValid {
            return .red
        } else if isEditing {
            return .accentColor
        } else {
            return .gray.opacity(0.2)
        }
    }

    private var borderWidth: CGFloat {
        isEditing || !isValid ? 2 : 1
    }

    private var helperTextColor: Color {
        isValid ? .gray : .red
    }

    private var currentHelperText: String? {
        if !isValid && !validationMessage.isEmpty {
            return validationMessage
        }
        return helperText
    }

    // MARK: - Validation

    private func validateInput() {
        guard let validation = validation else {
            isValid = true
            return
        }

        let result = validation.validate(text)
        isValid = result.isValid
        validationMessage = result.errorMessage ?? ""
    }
}

// MARK: - Validation Rules

public struct TextFieldValidationRule {
    public let validate: (String) -> ValidationResult

    public init(validate: @escaping (String) -> ValidationResult) {
        self.validate = validate
    }
}

// Create a type alias for backward compatibility
public typealias ValidationRule = TextFieldValidationRule

// MARK: - Built-in Validations

extension ValidationRule {
    // Email validation
    public static let email = ValidationRule { value in
        if value.isEmpty {
            return .invalid("Email is required")
        }
        return value.isValidEmail ? .valid : .invalid("Please enter a valid email")
    }

    // Required field
    public static let required = ValidationRule { value in
        !value.isEmpty ? .valid : .invalid("This field is required")
    }

    // Minimum length
    public static func minLength(_ length: Int) -> ValidationRule {
        ValidationRule { value in
            value.count >= length ? .valid : .invalid("Minimum \(length) characters required")
        }
    }

    // Maximum length
    public static func maxLength(_ length: Int) -> ValidationRule {
        ValidationRule { value in
            value.count <= length ? .valid : .invalid("Maximum \(length) characters allowed")
        }
    }

    // Password validation
    public static let password = ValidationRule { value in
        if value.isEmpty {
            return .invalid("Password is required")
        }
        if value.count < 8 {
            return .invalid("Password must be at least 8 characters")
        }
        let hasUppercase = value.contains(where: { $0.isUppercase })
        let hasLowercase = value.contains(where: { $0.isLowercase })
        let hasNumber = value.contains(where: { $0.isNumber })

        if !hasUppercase || !hasLowercase || !hasNumber {
            return .invalid("Password must contain uppercase, lowercase, and numbers")
        }
        return .valid
    }

    // Phone number
    public static let phoneNumber = ValidationRule { value in
        if value.isEmpty {
            return .invalid("Phone number is required")
        }
        return value.isValidPhoneNumber ? .valid : .invalid("Please enter a valid phone number")
    }

    // URL validation
    public static let url = ValidationRule { value in
        if value.isEmpty {
            return .invalid("URL is required")
        }
        return value.isValidURL ? .valid : .invalid("Please enter a valid URL")
    }

    // Numeric only
    public static let numeric = ValidationRule { value in
        (value.isEmpty || value.isNumeric) ? .valid : .invalid("Only numbers are allowed")
    }

    // Custom regex
    public static func regex(_ pattern: String, message: String) -> ValidationRule {
        ValidationRule { value in
            (value.isEmpty || value.matches(pattern: pattern)) ? .valid : .invalid(message)
        }
    }
}

// MARK: - Convenience Extensions

extension FloatingLabelTextField {
    // Email field preset
    public static func email(_ label: String = "Email", text: Binding<String>) -> FloatingLabelTextField {
        FloatingLabelTextField(
            label,
            text: text,
            validation: .email,
            leadingIcon: "envelope",
            keyboardType: .emailAddress,
            textInputAutocapitalization: .never,
            autocorrectionDisabled: true
        )
    }

    // Password field preset
    public static func password(_ label: String = "Password", text: Binding<String>) -> FloatingLabelTextField {
        FloatingLabelTextField(
            label,
            text: text,
            validation: .password,
            leadingIcon: "lock",
            isSecure: true,
            textInputAutocapitalization: .never,
            autocorrectionDisabled: true
        )
    }

    // Phone field preset
    public static func phone(_ label: String = "Phone", text: Binding<String>) -> FloatingLabelTextField {
        FloatingLabelTextField(
            label,
            text: text,
            validation: .phoneNumber,
            leadingIcon: "phone",
            keyboardType: .phonePad
        )
    }

    // Search field preset
    public static func search(_ label: String = "Search", text: Binding<String>) -> FloatingLabelTextField {
        FloatingLabelTextField(
            label,
            text: text,
            leadingIcon: "magnifyingglass",
            autocorrectionDisabled: true
        )
    }
}

// MARK: - Preview

#Preview("Floating Label Fields") {
    ScrollView {
        VStack(spacing: 20) {
            FloatingLabelTextField(
                "Username",
                text: .constant(""),
                validation: .required,
                leadingIcon: "person"
            )

            FloatingLabelTextField.email(text: .constant(""))

            FloatingLabelTextField.password(text: .constant(""))

            FloatingLabelTextField(
                "Website",
                text: .constant(""),
                placeholder: "https://",
                validation: .url,
                leadingIcon: "globe",
                helperText: "Enter your website URL",
                keyboardType: .URL
            )

            FloatingLabelTextField.phone(text: .constant(""))

            FloatingLabelTextField(
                "Description",
                text: .constant(""),
                validation: .maxLength(100),
                helperText: "Maximum 100 characters"
            )

            FloatingLabelTextField(
                "Disabled Field",
                text: .constant("Disabled content"),
                leadingIcon: "lock.fill"
            )
            .disabled(true)
        }
        .padding()
    }
}

#Preview("Field States") {
    struct TestView: View {
        @State private var email = ""
        @State private var password = ""

        var body: some View {
            VStack(spacing: 20) {
                FloatingLabelTextField.email(text: $email)
                FloatingLabelTextField.password(text: $password)

                Button("Fill Valid") {
                    email = "test@example.com"
                    password = "Password123"
                }

                Button("Fill Invalid") {
                    email = "invalid-email"
                    password = "weak"
                }

                Button("Clear") {
                    email = ""
                    password = ""
                }
            }
            .padding()
        }
    }

    return TestView()
}