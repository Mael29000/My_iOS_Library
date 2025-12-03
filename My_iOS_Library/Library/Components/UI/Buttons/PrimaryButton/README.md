# PrimaryButton

A highly customizable primary button component with loading states, animations, and haptic feedback.

## Features

- 🔄 **Async Support**: Automatic loading state for async actions
- 📱 **Haptic Feedback**: Medium impact feedback on tap
- ✨ **Success Animation**: Checkmark animation on completion
- 🎨 **Themes**: Multiple predefined themes and styles
- 📏 **Sizes**: Small, medium, and large variants
- 🌓 **Dark Mode**: Full dark mode support
- ♿️ **Accessibility**: VoiceOver compatible

## Basic Usage

```swift
import SwiftUI

// Simple button
PrimaryButton("Submit") {
    print("Button tapped")
}

// With icon
PrimaryButton("Save", icon: "checkmark") {
    print("Save tapped")
}

// Async action with automatic loading
PrimaryButton("Upload") {
    await uploadData()
}

// Icon on trailing side
PrimaryButton("Next", icon: "arrow.right", iconPosition: .trailing) {
    navigateNext()
}
```

## Sizes

```swift
// Small (36pt height)
PrimaryButton("Small") { }
    .primaryButtonStyle(.small)

// Medium (44pt height) - Default
PrimaryButton("Medium") { }
    .primaryButtonStyle(.medium)

// Large (52pt height)
PrimaryButton("Large") { }
    .primaryButtonStyle(.large)
```

## Themes

```swift
// Default theme with shadows
PrimaryButton("Default") { }
    .primaryButtonTheme(.default)

// Flat theme (no shadows)
PrimaryButton("Flat") { }
    .primaryButtonTheme(.flat)

// Rounded/Pill shaped
PrimaryButton("Rounded") { }
    .primaryButtonTheme(.rounded)

// Outline style
PrimaryButton("Outline") { }
    .primaryButtonTheme(.outline)

// Ghost style (subtle background)
PrimaryButton("Ghost") { }
    .primaryButtonTheme(.ghost)
```

## Color Variants

```swift
// Predefined colors
PrimaryButton.blue("Blue Button") { }
PrimaryButton.green("Green Button") { }
PrimaryButton.red("Red Button") { }
PrimaryButton.purple("Purple Button") { }

// Gradient styles
PrimaryButton.blueGradient("Blue Gradient") { }
PrimaryButton.purpleGradient("Purple Gradient") { }
PrimaryButton.sunsetGradient("Sunset Gradient") { }
PrimaryButton.oceanGradient("Ocean Gradient") { }
```

## Common Presets

```swift
// Save button (green with checkmark)
PrimaryButton.save {
    await saveData()
}

// Delete button (red with trash icon)
PrimaryButton.delete {
    await deleteItem()
}

// Submit button (with paperplane icon)
PrimaryButton.submit {
    await submitForm()
}

// Navigation buttons
PrimaryButton.next {
    navigateNext()
}

PrimaryButton.back {
    navigateBack()
}
```

## Custom Colors

```swift
// Custom solid colors
PrimaryButton("Custom") { }
    .primaryButtonColors(
        background: { isEnabled, colorScheme in
            isEnabled ? Color.orange : Color.gray
        },
        foreground: { _, _ in
            Color.white
        }
    )

// Custom gradient
PrimaryButton("Gradient") { }
    .primaryButtonGradient { isEnabled, _ in
        isEnabled
            ? [Color.pink, Color.orange]
            : [Color.gray, Color.gray.opacity(0.5)]
    }
```

## Advanced Configuration

```swift
// Create custom configuration
let customConfig = PrimaryButtonStyleConfiguration(
    size: .medium,
    height: 48,
    fontSize: 17,
    iconSize: 18,
    spacing: 10,
    cornerRadius: 16,
    hasGradient: true,
    backgroundColor: { _, _ in Color.blue },
    foregroundColor: { _, _ in Color.white },
    gradientColors: { _, _ in [Color.blue, Color.purple] },
    shadowColor: { _, _ in Color.blue.opacity(0.3) }
)

PrimaryButton("Custom Config") { }
    .primaryButtonStyle(customConfig)
```

## States

```swift
// Disabled state
PrimaryButton("Disabled") { }
    .disabled(true)

// Loading state (automatic for async)
PrimaryButton("Loading") {
    try? await Task.sleep(nanoseconds: 3_000_000_000)
}
```

## Animation Details

- **Press**: Scale down to 0.98x with spring animation
- **Loading**: Circular progress indicator replaces content
- **Success**: Checkmark appears with spring animation for 1 second
- **Shadow**: Reduces on press for depth effect

## Best Practices

1. **Use async actions** for network requests or time-consuming operations
2. **Keep titles concise** - ideally 1-2 words
3. **Use icons sparingly** - only when they add clarity
4. **Choose appropriate size** - Large for primary CTAs, small for secondary actions
5. **Maintain consistency** - Use the same theme throughout your app

## Accessibility

- Full VoiceOver support with automatic labels
- Respects Dynamic Type settings
- Clear disabled states
- Loading state announced to screen readers

## Requirements

- iOS 15.0+
- SwiftUI
- No external dependencies