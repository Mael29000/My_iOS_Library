# Navigation Architecture

A simple, centralized navigation system for SwiftUI apps using the Observable framework (iOS 17+).

## Features

- ✅ Centralized navigation router
- ✅ Type-safe routing
- ✅ Push navigation support
- ✅ Sheet presentation
- ✅ Full screen covers
- ✅ Alerts and confirmation dialogs
- ✅ Tab navigation
- ✅ Easy to extend and customize

## Quick Start

### 1. Basic Setup

```swift
// In your App.swift
import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationContainer {
                HomeView()
            }
        }
    }
}
```

### 2. Tab-based Setup

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            TabNavigationContainer()
        }
    }
}
```

## Usage

### Access the Router

```swift
struct MyView: View {
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        // Your view content
    }
}
```

### Push Navigation

```swift
// Navigate to a view
router.navigate(to: .profile(userId: "123"))

// Navigate to multiple views at once
router.navigate(to: [.settings, .profile(userId: "123")])

// Pop back
router.pop()

// Pop to root
router.popToRoot()

// Replace entire stack
router.replaceStack(with: [.home, .settings])
```

### Sheets

```swift
// Present a sheet
router.presentSheet(.addItem)

// Present with parameters
router.presentSheet(.editProfile(userId: "123"))

// Dismiss
router.dismissSheet()
```

### Full Screen Covers

```swift
// Present full screen
router.presentFullScreen(.onboarding)

// Present with parameters
router.presentFullScreen(.videoPlayer(url: "https://..."))

// Dismiss
router.dismissFullScreen()
```

### Alerts

```swift
// Simple alert
router.showAlert(
    title: "Success!",
    message: "Your action was completed"
)

// Alert with actions
router.showAlert(
    title: "Delete Item?",
    message: "This action cannot be undone",
    primaryButton: .delete {
        // Perform delete
    },
    secondaryButton: .cancel
)
```

### Confirmation Dialogs

```swift
router.showConfirmationDialog(
    ConfirmationDialogConfig(
        title: "Choose Action",
        message: "What would you like to do?",
        buttons: [
            DialogButton(title: "Edit", action: { /* ... */ }),
            DialogButton(title: "Delete", role: .destructive, action: { /* ... */ }),
            DialogButton(title: "Cancel", role: .cancel, action: {})
        ]
    )
)
```

### Tab Navigation

```swift
// Switch tabs
router.switchToTab(.profile)

// Get current tab
let currentTab = router.selectedTab
```

## Adding New Routes

### 1. Define the Route

```swift
// In Route.swift
enum Route: Hashable {
    // Add your route
    case myNewView(id: String)
}
```

### 2. Handle Navigation

```swift
// In NavigationContainer.swift, update RouteView
struct RouteView: View {
    var body: some View {
        switch route {
        // ... existing cases
        case .myNewView(let id):
            MyNewView(id: id)
        }
    }
}
```

### 3. For Sheets

```swift
// In Route.swift
enum SheetRoute: Hashable {
    case mySheet(data: String)
}

// In NavigationContainer.swift, update SheetView
struct SheetView: View {
    var body: some View {
        switch route {
        // ... existing cases
        case .mySheet(let data):
            MySheetView(data: data)
        }
    }
}
```

## Best Practices

1. **Keep Routes Simple**: Use simple data types in route parameters (String, Int, etc.)
2. **Use Environment**: Always access the router via `@Environment` for automatic updates
3. **Handle Deep Links**: The router makes it easy to handle deep links by constructing the appropriate navigation path
4. **Reset Navigation**: Use `router.reset()` to dismiss all presentations and return to the root

## Architecture Benefits

- **Centralized**: All navigation logic in one place
- **Testable**: Easy to test navigation flows
- **Type-safe**: Compiler ensures all routes are handled
- **Flexible**: Easy to add new navigation types
- **Observable**: Automatic UI updates with @Observable

## Example App Structure

```
MyApp/
├── Navigation/
│   ├── Route.swift           // Route definitions
│   ├── NavigationRouter.swift // Router logic
│   └── NavigationContainer.swift // Container views
├── Views/
│   ├── Home/
│   │   └── HomeView.swift
│   ├── Profile/
│   │   └── ProfileView.swift
│   └── Settings/
│       └── SettingsView.swift
└── MyApp.swift
```

## Customization

You can easily extend the system:

- Add new route types
- Implement custom transitions
- Add navigation history tracking
- Implement deep linking
- Add analytics tracking

This navigation system provides a solid foundation that can grow with your app's needs.