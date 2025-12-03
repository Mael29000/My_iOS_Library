# Card

A versatile container component with multiple style variants, elevation levels, and interactive capabilities.

## Features

- 🎨 **Multiple Styles**: Elevated, outlined, filled, neumorphic, glass, gradient
- 🏔️ **Elevation Levels**: None, low, medium, high shadow depths
- 🎯 **Interactive**: Optional tap actions with press effects
- 🌈 **Gradient Support**: Custom gradient backgrounds
- 📱 **Responsive**: Adapts to light/dark mode
- ✨ **Animations**: Smooth press and interaction effects
- ♿️ **Accessibility**: Full VoiceOver support

## Basic Usage

```swift
import SwiftUI

// Simple card with content
Card {
    VStack {
        Text("Card Title")
            .font(.headline)
        Text("Card description goes here")
            .font(.body)
            .foregroundColor(.secondary)
    }
    .padding()
}

// Interactive card
Card(action: {
    print("Card tapped")
}) {
    Text("Tap me!")
        .padding()
}
```

## Card Styles

```swift
// Elevated (default) - with shadow
Card {
    Text("Elevated Card")
        .padding()
}
.cardStyle(.elevated)

// Outlined - border, no shadow
Card {
    Text("Outlined Card")
        .padding()
}
.cardStyle(.outlined)

// Filled - solid background, no shadow
Card {
    Text("Filled Card")
        .padding()
}
.cardStyle(.filled)

// Neumorphic - soft UI design
Card {
    Text("Neumorphic Card")
        .padding()
}
.cardStyle(.neumorphic)

// Glass - translucent material
Card {
    Text("Glass Card")
        .padding()
}
.cardStyle(.glass)

// Gradient - custom gradient background
Card {
    Text("Gradient Card")
        .padding()
}
.cardGradient([.blue, .purple])
```

## Elevation Levels

```swift
// No elevation
Card { content }
    .cardElevation(.none)

// Low elevation (4pt shadow)
Card { content }
    .cardElevation(.low)

// Medium elevation (8pt shadow) - default
Card { content }
    .cardElevation(.medium)

// High elevation (16pt shadow)
Card { content }
    .cardElevation(.high)

// Custom elevation
let customElevation = CardStyleConfiguration.Elevation(
    shadowRadius: 12,
    shadowOffset: CGSize(width: 0, height: 6)
)
Card { content }
    .cardElevation(customElevation)
```

## Convenience Initializers

```swift
// Simple card with title and subtitle
Card.simple(
    title: "Account Settings",
    subtitle: "Manage your account preferences",
    icon: "person.circle",
    action: {
        // Navigate to settings
    }
)

// Info card with large icon
Card.info(
    image: "checkmark.circle.fill",
    title: "Success!",
    description: "Your changes have been saved successfully.",
    action: {
        // Dismiss
    }
)
```

## Customization

### Corner Radius

```swift
// Custom corner radius
Card { content }
    .cardCornerRadius(8)

// Rounded corners
Card { content }
    .cardCornerRadius(24)
```

### Gradient Backgrounds

```swift
// Two-color gradient
Card { content }
    .cardGradient([.orange, .pink])

// Multi-color gradient
Card { content }
    .cardGradient([.blue, .purple, .pink])

// Subtle gradient
Card { content }
    .cardGradient([Color.blue.opacity(0.8), Color.blue.opacity(0.4)])
```

### Custom Configuration

```swift
// Create custom card style
let customStyle = CardStyleConfiguration(
    variant: .elevated,
    cornerRadius: 20,
    elevation: .high,
    backgroundColor: { _ in Color.indigo.opacity(0.1) },
    borderColor: Color.indigo,
    borderWidth: 2,
    gradientColors: nil
)

Card { content }
    .cardStyle(customStyle)
```

## Common Use Cases

### List Item Card

```swift
Card(action: { selectItem() }) {
    HStack {
        Image(systemName: "doc.text")
            .font(.title2)
            .foregroundColor(.accentColor)

        VStack(alignment: .leading, spacing: 4) {
            Text("Document.pdf")
                .font(.headline)
            Text("2.4 MB • Modified today")
                .font(.caption)
                .foregroundColor(.secondary)
        }

        Spacer()

        Image(systemName: "chevron.right")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}
.cardStyle(.outlined)
```

### Dashboard Card

```swift
Card {
    VStack(alignment: .leading, spacing: 12) {
        HStack {
            Text("Revenue")
                .font(.headline)
            Spacer()
            Image(systemName: "arrow.up.right")
                .foregroundColor(.green)
        }

        Text("$12,543")
            .font(.largeTitle.bold())

        Text("+23% from last month")
            .font(.caption)
            .foregroundColor(.green)
    }
    .padding()
}
.cardStyle(.elevated)
.cardElevation(.high)
```

### Feature Card

```swift
Card {
    VStack(spacing: 16) {
        Image(systemName: "bolt.circle.fill")
            .font(.system(size: 60))
            .foregroundColor(.yellow)
            .background(
                Circle()
                    .fill(Color.yellow.opacity(0.2))
                    .frame(width: 80, height: 80)
            )

        Text("Lightning Fast")
            .font(.title3.bold())

        Text("Experience blazing fast performance with our optimized engine")
            .font(.body)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
    }
    .padding(24)
}
.cardStyle(.filled)
```

## States

### Disabled State

```swift
Card(action: { }) {
    Text("Disabled Card")
        .padding()
}
.disabled(true)
```

### Loading State

```swift
Card {
    HStack {
        ProgressView()
        Text("Loading...")
            .foregroundColor(.secondary)
    }
    .padding()
}
.cardStyle(.outlined)
```

## Animation Details

- **Press Effect**: Scales down to 0.98x with spring animation
- **Shadow Animation**: Reduces shadow on press for depth effect
- **Color Transitions**: Smooth transitions between states
- **Haptic Feedback**: Light impact on tap (interactive cards only)

## Best Practices

1. **Choose appropriate styles** - Elevated for primary content, outlined for lists
2. **Use consistent elevation** - Higher elevation for more important content
3. **Keep padding consistent** - Use standard padding values across cards
4. **Limit gradient use** - Reserve gradients for special emphasis
5. **Consider accessibility** - Ensure sufficient contrast in custom colors

## Performance Tips

- Cards are lightweight and render efficiently
- Use `.drawingGroup()` for complex card content
- Gradient cards have slightly higher rendering cost
- Glass style uses system materials (iOS 15+)

## Requirements

- iOS 15.0+
- SwiftUI
- No external dependencies