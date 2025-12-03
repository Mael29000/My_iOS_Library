# My iOS Library - Component Index

A comprehensive SwiftUI component library for rapid iOS development. This index provides quick access to all components with examples and usage guidelines.

## 🚀 Quick Start

```swift
// Import in your SwiftUI file
import SwiftUI

// Use any component
PrimaryButton("Get Started") {
    // Action
}
```

## 📱 Components Overview

### UI Components

#### Buttons
- [PrimaryButton](#primarybutton) - Feature-rich button with loading states
- SecondaryButton *(coming soon)*
- IconButton *(coming soon)*
- FloatingActionButton *(coming soon)*

#### Inputs
- [FloatingLabelTextField](#floatinglabeltextfield) - Modern text field with floating label
- ValidatedTextField *(coming soon)*
- SearchField *(coming soon)*
- PasswordField *(coming soon)*

#### Cards & Containers
- [Card](#card) - Versatile container with multiple styles
- SwipeableCard *(coming soon)*
- ExpandableCard *(coming soon)*
- ListCard *(coming soon)*

### Animations

#### Loading
- [SkeletonLoader](#skeletonloader) - Shimmer loading placeholders
- PulseAnimation *(coming soon)*
- ProgressRing *(coming soon)*
- LoadingDots *(coming soon)*

### Navigation
- TabBar *(coming soon)*
- SideMenu *(coming soon)*
- SegmentedControl *(coming soon)*
- Breadcrumb *(coming soon)*

### Extensions

#### SwiftUI
- [View+Extensions](Extensions/SwiftUI/View+Extensions.swift) - Conditional modifiers, haptics, keyboard
- [Color+Extensions](Extensions/SwiftUI/Color+Extensions.swift) - Hex colors, gradients, semantic colors
- [Font+Extensions](Extensions/SwiftUI/Font+Extensions.swift) - Typography system, dynamic type
- [Binding+Extensions](Extensions/SwiftUI/Binding+Extensions.swift) - Transformations, debugging

#### Foundation
- [String+Extensions](Extensions/Foundation/String+Extensions.swift) - Validation, formatting, regex
- [Array+Extensions](Extensions/Foundation/Array+Extensions.swift) - Safe access, chunking, operations
- [Date+Extensions](Extensions/Foundation/Date+Extensions.swift) - Formatting, comparisons, calculations

### Utilities
- [Logger](Utils/Helpers/Logger.swift) - Comprehensive logging system
- [Validator](Utils/Helpers/Validator.swift) - Input validation framework

---

## 🎯 Component Details

### PrimaryButton

A highly customizable button with loading states, animations, and haptic feedback.

**Location**: `Components/UI/Buttons/PrimaryButton/`

**Features**:
- Async action support with automatic loading state
- Success animation with checkmark
- Multiple sizes (small, medium, large)
- Predefined themes and color variants
- Haptic feedback

**Quick Example**:
```swift
// Basic usage
PrimaryButton("Submit") {
    await submitForm()
}

// With icon and style
PrimaryButton("Save", icon: "checkmark") {
    saveData()
}
.primaryButtonStyle(.large)

// Predefined styles
PrimaryButton.save {
    await saveDocument()
}
```

[Full Documentation →](Components/UI/Buttons/PrimaryButton/README.md)

---

### FloatingLabelTextField

Modern text field with animated floating label and built-in validation.

**Location**: `Components/UI/Inputs/FloatingLabelTextField/`

**Features**:
- Floating label animation
- Built-in validation rules
- Leading/trailing icons
- Helper text and error messages
- Password visibility toggle

**Quick Example**:
```swift
@State private var email = ""

// Email field with validation
FloatingLabelTextField.email(text: $email)

// Custom field
FloatingLabelTextField(
    "Username",
    text: $username,
    validation: .minLength(3),
    leadingIcon: "person"
)
```

[Full Documentation →](Components/UI/Inputs/FloatingLabelTextField/README.md)

---

### Card

Versatile container component with multiple style variants.

**Location**: `Components/UI/Cards/Card/`

**Features**:
- Multiple styles: elevated, outlined, filled, neumorphic, glass
- Customizable elevation and shadows
- Interactive with press effects
- Gradient support

**Quick Example**:
```swift
// Basic card
Card {
    Text("Card Content")
        .padding()
}
.cardStyle(.elevated)

// Interactive card
Card(action: { openDetail() }) {
    HStack {
        Image(systemName: "star")
        Text("Tap me")
        Spacer()
    }
    .padding()
}
```

[Full Documentation →](Components/UI/Cards/Card/README.md)

---

### SkeletonLoader

Animated loading placeholders with shimmer effect.

**Location**: `Components/Animations/Loading/SkeletonLoader/`

**Features**:
- Shimmer and pulse animations
- Multiple shapes: rectangle, circle, rounded
- Customizable colors and speed
- Preset layouts for lists and grids

**Quick Example**:
```swift
// Simple skeleton
SkeletonLoader()
    .skeleton(shape: .roundedRectangle(cornerRadius: 8))
    .frame(height: 60)

// List skeleton
SkeletonList(itemCount: 5)

// Custom colors
SkeletonLoader()
    .skeletonColors(base: .blue.opacity(0.1))
```

[Full Documentation →](Components/Animations/Loading/SkeletonLoader/README.md)

---

## 🔧 Common Patterns

### Loading States

```swift
struct ContentView: View {
    @State private var isLoading = true
    @State private var data: [Item] = []

    var body: some View {
        Group {
            if isLoading {
                SkeletonList()
            } else {
                ForEach(data) { item in
                    Card {
                        // Content
                    }
                }
            }
        }
    }
}
```

### Form with Validation

```swift
struct SignUpForm: View {
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            FloatingLabelTextField.email(text: $email)
            FloatingLabelTextField.password(text: $password)

            PrimaryButton("Sign Up") {
                await createAccount()
            }
            .disabled(email.isEmpty || password.isEmpty)
        }
        .padding()
    }
}
```

### Custom Card List

```swift
struct ItemList: View {
    let items: [Item]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(items) { item in
                    Card(action: { selectItem(item) }) {
                        HStack {
                            Image(systemName: item.icon)
                            VStack(alignment: .leading) {
                                Text(item.title)
                                    .font(.headline)
                                Text(item.subtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    .cardStyle(.outlined)
                }
            }
            .padding()
        }
    }
}
```

---

## 📋 Requirements

- **iOS**: 15.0+
- **Swift**: 5.5+
- **Xcode**: 13.0+
- **Dependencies**: None (pure SwiftUI)

---

## 🎨 Design Principles

1. **Consistency**: All components follow iOS design guidelines
2. **Customization**: Extensive modification options without complexity
3. **Performance**: Optimized for smooth 60fps animations
4. **Accessibility**: Full VoiceOver and Dynamic Type support
5. **Dark Mode**: Automatic adaptation to system appearance

---

## 🚧 Coming Soon

### Phase 2
- InfiniteScrollList
- BottomSheet
- SearchField
- ToastNotification
- SegmentedControl

### Phase 3
- ImagePicker
- BiometricAuth
- NetworkMonitor
- HapticManager
- ThemeManager

---

## 💡 Tips

1. **Import Once**: Add components to your project's main SwiftUI file
2. **Consistent Styling**: Use the same component variants throughout your app
3. **Leverage Extensions**: Many utility extensions are available on SwiftUI and Foundation types
4. **Check Examples**: Each component README includes comprehensive examples
5. **Performance**: Use `SkeletonLoader` for all loading states

---

## 📞 Support

For questions or issues:
- Check component-specific README files
- Review the example implementations
- Explore the Extensions folder for additional utilities

---

Last Updated: December 2025