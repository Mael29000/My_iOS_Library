# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build and Development Commands

### Building the Project
```bash
# Build for Debug
xcodebuild -project "My_iOS_Library.xcodeproj" -scheme "My_iOS_Library" -configuration Debug build

# Build for Release
xcodebuild -project "My_iOS_Library.xcodeproj" -scheme "My_iOS_Library" -configuration Release build

# Clean build folder
xcodebuild -project "My_iOS_Library.xcodeproj" -scheme "My_iOS_Library" clean

# Build and run in simulator
xcodebuild -project "My_iOS_Library.xcodeproj" -scheme "My_iOS_Library" -destination "platform=iOS Simulator,name=iPhone 15" build
```

### Project Information
```bash
# List available schemes and targets
xcodebuild -project "My_iOS_Library.xcodeproj" -list

# Show build settings
xcodebuild -project "My_iOS_Library.xcodeproj" -scheme "My_iOS_Library" -showBuildSettings
```

## Architecture Overview

This is a SwiftUI iOS application that includes a comprehensive utility library with extensions and helper classes. The project structure follows a modular approach with reusable components.

### Core Structure
- **Entry Point**: `My_iOS_LibraryApp.swift` - The `@main` App struct
- **Main View**: `ContentView.swift` - Root view of the application
- **Library**: `My_iOS_Library/Library/` - Contains all utility extensions and helpers

### Library Components

#### SwiftUI Extensions (`Library/Extensions/SwiftUI/`)
- **View+Extensions.swift**: Conditional modifiers, corner radius, snapshots, keyboard management, haptic feedback, loading overlays, device-specific modifiers
- **Color+Extensions.swift**: Color utilities and conversions
- **Font+Extensions.swift**: Font utilities
- **Binding+Extensions.swift**: Binding helpers

#### Foundation Extensions (`Library/Extensions/Foundation/`)
- **String+Extensions.swift**: Validation (email, URL, phone), case conversion, encoding/decoding, regex, subscript access
- **Date+Extensions.swift**: Date formatting and manipulation
- **Array+Extensions.swift**: Array utilities

#### Utility Helpers (`Library/Utils/Helpers/`)
- **Logger.swift**: Comprehensive logging system with os_log integration, file logging, performance measurement
- **Validator.swift**: Input validation utilities

## Key Features

### Logger Configuration
The project includes a sophisticated logging system that can be configured:
```swift
Logger.configure { config in
    config.minimumLevel = .debug
    config.saveToFile = true
    config.includeSourceLocation = true
}
```

### View Extensions Usage
The View extensions provide powerful modifiers:
```swift
// Conditional modifiers
.if(condition) { view in
    view.foregroundColor(.red)
}

// Device-specific layouts
.onPhone { view in
    view.padding(.horizontal, 16)
}
.onPad { view in
    view.padding(.horizontal, 32)
}

// Loading overlays
.loadingOverlay(isLoading: isProcessing)
```

### String Validation
Built-in validation methods for common formats:
```swift
email.isValidEmail
phoneNumber.isValidPhoneNumber
url.isValidURL
```

## Project Details
- **Bundle ID**: `com.trivial.My-iOS-library`
- **Deployment Target**: iOS 18.5
- **Swift Version**: 5.0
- **Supported Devices**: iPhone and iPad (Universal)
- **Development Team**: MM632MV27H
- **UI Framework**: Pure SwiftUI
- **External Dependencies**: None