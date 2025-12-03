# FloatingLabelTextField

A modern text field with animated floating label, built-in validation, and rich customization options.

## Features

- 🏷️ **Floating Label**: Animated label that floats above the field when focused or filled
- ✅ **Validation**: Built-in and custom validation rules with error messages
- 🎨 **Icons**: Support for leading and trailing SF Symbol icons
- 🔒 **Secure Entry**: Password field with show/hide toggle
- 💬 **Helper Text**: Persistent helper text or validation messages
- 🎯 **Focus States**: Visual feedback for focused and error states
- 🌓 **Dark Mode**: Automatic adaptation to color scheme
- ♿️ **Accessibility**: Full VoiceOver support

## Basic Usage

```swift
import SwiftUI

struct FormView: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            // Basic field
            FloatingLabelTextField(
                "Username",
                text: $username
            )

            // With validation
            FloatingLabelTextField(
                "Email",
                text: $email,
                validation: .email,
                leadingIcon: "envelope"
            )

            // Password field
            FloatingLabelTextField(
                "Password",
                text: $password,
                validation: .password,
                leadingIcon: "lock",
                isSecure: true
            )
        }
    }
}
```

## Preset Fields

```swift
// Email field with icon and validation
FloatingLabelTextField.email(text: $email)

// Password field with validation and toggle
FloatingLabelTextField.password(text: $password)

// Phone number field with validation
FloatingLabelTextField.phone(text: $phoneNumber)

// Search field with icon
FloatingLabelTextField.search(text: $searchQuery)
```

## Validation

### Built-in Validations

```swift
// Required field
FloatingLabelTextField(
    "Name",
    text: $name,
    validation: .required
)

// Email validation
FloatingLabelTextField(
    "Email",
    text: $email,
    validation: .email
)

// Minimum length
FloatingLabelTextField(
    "Bio",
    text: $bio,
    validation: .minLength(10)
)

// Maximum length
FloatingLabelTextField(
    "Username",
    text: $username,
    validation: .maxLength(20)
)

// Phone number
FloatingLabelTextField(
    "Phone",
    text: $phone,
    validation: .phoneNumber
)

// URL
FloatingLabelTextField(
    "Website",
    text: $website,
    validation: .url
)

// Numeric only
FloatingLabelTextField(
    "Age",
    text: $age,
    validation: .numeric
)

// Password (8+ chars, uppercase, lowercase, number)
FloatingLabelTextField(
    "Password",
    text: $password,
    validation: .password
)
```

### Custom Validation

```swift
// Regex validation
FloatingLabelTextField(
    "Username",
    text: $username,
    validation: .regex("^[a-zA-Z0-9_]+$", message: "Only letters, numbers, and underscores allowed")
)

// Custom validation function
let customValidation = ValidationRule { value in
    if value.count < 5 {
        return ValidationResult(isValid: false, message: "Too short")
    }
    if value.contains("@") {
        return ValidationResult(isValid: false, message: "@ symbol not allowed")
    }
    return ValidationResult(isValid: true)
}

FloatingLabelTextField(
    "Custom Field",
    text: $text,
    validation: customValidation
)
```

## Customization

### Icons

```swift
// Leading icon
FloatingLabelTextField(
    "Email",
    text: $email,
    leadingIcon: "envelope"
)

// Trailing icon
FloatingLabelTextField(
    "Search",
    text: $search,
    trailingIcon: "magnifyingglass"
)

// Both icons
FloatingLabelTextField(
    "Amount",
    text: $amount,
    leadingIcon: "dollarsign",
    trailingIcon: "info.circle"
)
```

### Helper Text

```swift
// Static helper text
FloatingLabelTextField(
    "Username",
    text: $username,
    helperText: "Choose a unique username"
)

// Helper text with validation
FloatingLabelTextField(
    "Email",
    text: $email,
    validation: .email,
    helperText: "We'll never share your email"
)
```

### Keyboard Configuration

```swift
// Email keyboard
FloatingLabelTextField(
    "Email",
    text: $email,
    keyboardType: .emailAddress,
    textInputAutocapitalization: .never
)

// Number pad
FloatingLabelTextField(
    "Phone",
    text: $phone,
    keyboardType: .phonePad
)

// URL keyboard
FloatingLabelTextField(
    "Website",
    text: $website,
    keyboardType: .URL,
    autocorrectionDisabled: true
)

// Decimal pad
FloatingLabelTextField(
    "Price",
    text: $price,
    keyboardType: .decimalPad
)
```

### Placeholder

```swift
// With placeholder
FloatingLabelTextField(
    "Website",
    text: $website,
    placeholder: "https://example.com"
)
```

## States

### Disabled State

```swift
FloatingLabelTextField(
    "Disabled Field",
    text: $text
)
.disabled(true)
```

### Focus Management

```swift
struct FocusExample: View {
    @State private var email = ""
    @FocusState private var emailFocused: Bool

    var body: some View {
        VStack {
            FloatingLabelTextField(
                "Email",
                text: $email
            )
            .focused($emailFocused)

            Button("Focus Email") {
                emailFocused = true
            }
        }
    }
}
```

## Styling

The component automatically adapts to:
- Light/Dark mode
- Dynamic Type
- Accent color
- Disabled state

### State Colors

- **Normal**: Gray border and icons
- **Focused**: Accent color border and label
- **Error**: Red border, label, and error message
- **Disabled**: Gray background and reduced opacity

## Animation Details

- **Label Float**: Spring animation (0.3s) when focusing or typing
- **Border Width**: Animates from 1px to 2px when focused
- **Colors**: Smooth transitions between states
- **Error Messages**: Fade in/out with slide animation

## Best Practices

1. **Always use validation** for user inputs that have requirements
2. **Provide helper text** for complex fields
3. **Use appropriate keyboard types** to improve user experience
4. **Choose meaningful icons** that clarify the field's purpose
5. **Keep labels concise** - use helper text for additional info

## Accessibility

- Floating label serves as the accessibility label
- Error messages are announced to VoiceOver
- Secure text toggle is labeled for screen readers
- Respects Dynamic Type settings

## Requirements

- iOS 15.0+
- SwiftUI
- Depends on: String+Extensions.swift (for validation methods)