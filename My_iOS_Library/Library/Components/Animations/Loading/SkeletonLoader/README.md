# SkeletonLoader

Animated skeleton loading placeholders with shimmer and pulse effects for content loading states.

## Features

- ✨ **Shimmer Animation**: Sliding highlight effect
- 🫀 **Pulse Animation**: Breathing opacity effect
- 🔷 **Multiple Shapes**: Rectangle, rounded rectangle, circle, capsule
- 🎨 **Customizable Colors**: Base and highlight colors
- ⚡ **Adjustable Speed**: Control animation duration
- 📱 **Preset Layouts**: List and grid skeleton templates
- 🌓 **Dark Mode**: Automatic color adaptation
- 🎯 **Lightweight**: Efficient rendering with SwiftUI

## Basic Usage

```swift
import SwiftUI

// Simple rectangle skeleton
SkeletonLoader()
    .frame(height: 60)

// Rounded rectangle
SkeletonLoader()
    .skeleton(shape: .roundedRectangle(cornerRadius: 12))
    .frame(height: 80)

// Circle skeleton
SkeletonLoader()
    .skeleton(shape: .circle)
    .frame(width: 60, height: 60)

// Capsule skeleton
SkeletonLoader()
    .skeleton(shape: .capsule)
    .frame(width: 120, height: 40)
```

## Animation Types

```swift
// Shimmer (default) - sliding highlight
SkeletonLoader()
    .skeleton(shape: .roundedRectangle(cornerRadius: 8))
    .skeletonAnimation(.shimmer)

// Pulse - breathing opacity
SkeletonLoader()
    .skeleton(shape: .roundedRectangle(cornerRadius: 8))
    .skeletonAnimation(.pulse)

// No animation - static placeholder
SkeletonLoader()
    .skeleton(shape: .roundedRectangle(cornerRadius: 8))
    .skeletonAnimation(.none)
```

## Customization

### Colors

```swift
// Custom base and highlight colors
SkeletonLoader()
    .skeletonColors(
        base: .gray.opacity(0.3),
        highlight: .gray.opacity(0.5)
    )

// Brand colors
SkeletonLoader()
    .skeletonColors(
        base: .blue.opacity(0.1),
        highlight: .blue.opacity(0.2)
    )

// Single color (auto-generates highlight)
SkeletonLoader()
    .skeletonColors(base: .purple.opacity(0.2))
```

### Animation Speed

```swift
// Fast animation (0.8 seconds)
SkeletonLoader()
    .skeletonSpeed(0.8)

// Slow animation (2.5 seconds)
SkeletonLoader()
    .skeletonSpeed(2.5)

// Default is 1.5 seconds
```

## Preset Layouts

### List Skeleton

```swift
// Default list (5 items)
SkeletonList()

// Custom list
SkeletonList(
    itemCount: 3,
    itemHeight: 100,
    spacing: 16
)

// List item component
SkeletonListItem()
    .frame(height: 80)
```

### Grid Skeleton

```swift
// Default grid (2x3)
SkeletonGrid()

// Custom grid
SkeletonGrid(
    columns: 3,
    rows: 2,
    spacing: 20
)

// Grid item component
SkeletonGridItem()
```

## Common Patterns

### Text Placeholder

```swift
VStack(alignment: .leading, spacing: 8) {
    // Title
    SkeletonLoader()
        .skeleton(shape: .roundedRectangle(cornerRadius: 4))
        .frame(width: 200, height: 24)

    // Subtitle
    SkeletonLoader()
        .skeleton(shape: .roundedRectangle(cornerRadius: 4))
        .frame(width: 150, height: 16)
        .opacity(0.7)

    // Body text
    SkeletonLoader()
        .skeleton(shape: .roundedRectangle(cornerRadius: 4))
        .frame(height: 14)
}
```

### Card Skeleton

```swift
struct CardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Image placeholder
            SkeletonLoader()
                .skeleton(shape: .roundedRectangle(cornerRadius: 8))
                .frame(height: 200)

            // Content
            VStack(alignment: .leading, spacing: 8) {
                SkeletonLoader()
                    .skeleton(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(height: 20)

                SkeletonLoader()
                    .skeleton(shape: .roundedRectangle(cornerRadius: 4))
                    .frame(width: 250, height: 16)
                    .opacity(0.7)
            }
            .padding(.horizontal)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
```

### Avatar with Text

```swift
HStack(spacing: 12) {
    // Avatar
    SkeletonLoader()
        .skeleton(shape: .circle)
        .frame(width: 50, height: 50)

    // User info
    VStack(alignment: .leading, spacing: 6) {
        SkeletonLoader()
            .skeleton(shape: .roundedRectangle(cornerRadius: 4))
            .frame(width: 120, height: 16)

        SkeletonLoader()
            .skeleton(shape: .roundedRectangle(cornerRadius: 4))
            .frame(width: 80, height: 14)
            .opacity(0.6)
    }

    Spacer()
}
```

## Loading State Management

```swift
struct ContentView: View {
    @State private var isLoading = true
    @State private var items: [Item] = []

    var body: some View {
        ScrollView {
            if isLoading {
                SkeletonList()
                    .padding()
            } else {
                LazyVStack(spacing: 12) {
                    ForEach(items) { item in
                        ItemRow(item: item)
                    }
                }
                .padding()
            }
        }
        .onAppear {
            loadData()
        }
    }

    func loadData() {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.items = fetchedItems
                self.isLoading = false
            }
        }
    }
}
```

## Conditional Skeleton

```swift
struct AsyncImage: View {
    @State private var image: UIImage?
    @State private var isLoading = true

    var body: some View {
        ZStack {
            if isLoading {
                SkeletonLoader()
                    .skeleton(shape: .roundedRectangle(cornerRadius: 8))
            }

            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .transition(.opacity)
            }
        }
        .onAppear {
            loadImage()
        }
    }
}
```

## Best Practices

1. **Match content shape** - Use skeleton shapes that match your actual content
2. **Consistent sizing** - Keep skeleton sizes close to real content dimensions
3. **Subtle animation** - Don't make animations too fast or distracting
4. **Loading states** - Always show skeletons during data fetching
5. **Smooth transitions** - Animate between skeleton and content

## Performance

- Skeletons use efficient SwiftUI animations
- Shimmer effect is GPU-accelerated
- Multiple skeletons animate in sync
- Minimal memory overhead

## Accessibility

- Skeletons are marked as decorative elements
- Screen readers announce "Loading content"
- Respects reduced motion preferences
- Focus is not trapped on skeleton elements

## Requirements

- iOS 15.0+
- SwiftUI
- No external dependencies