//
//  View+Extensions.swift
//  My iOS library
//
//  Essential View extensions for productivity
//

import SwiftUI

// MARK: - Conditional Modifiers

extension View {
    /// Applies a modifier conditionally
    @ViewBuilder
    func `if`<T: View>(_ condition: Bool, transform: (Self) -> T) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Applies one of two modifiers based on a condition
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        if ifTransform: (Self) -> TrueContent,
        else elseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }

    /// Applies a modifier if a value is not nil
    @ViewBuilder
    func ifLet<Value, Content: View>(
        _ value: Value?,
        transform: (Self, Value) -> Content
    ) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

// MARK: - Corner Radius

extension View {
    /// Applies corner radius to specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Snapshot

extension View {
    /// Creates a UIImage snapshot of the view
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// MARK: - Keyboard

extension View {
    /// Hides the keyboard when called
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    /// Adds a tap gesture to hide keyboard
    func hideKeyboardOnTap() -> some View {
        self.onTapGesture {
            hideKeyboard()
        }
    }
}

// MARK: - Haptic Feedback

extension View {
    /// Triggers haptic feedback
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactFeedback = UIImpactFeedbackGenerator(style: style)
        impactFeedback.impactOccurred()
    }

    /// Triggers haptic notification feedback
    func hapticNotification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.notificationOccurred(type)
    }

    /// Triggers haptic selection feedback
    func hapticSelection() {
        let selectionFeedback = UISelectionFeedbackGenerator()
        selectionFeedback.selectionChanged()
    }
}

// MARK: - First Appear

extension View {
    /// Performs an action only on first appear
    func onFirstAppear(perform action: @escaping () -> Void) -> some View {
        modifier(FirstAppearModifier(action: action))
    }
}

struct FirstAppearModifier: ViewModifier {
    @State private var hasAppeared = false
    let action: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                hasAppeared = true
                action()
            }
        }
    }
}

// MARK: - Loading Overlay

extension View {
    /// Shows a loading overlay
    func loadingOverlay(isLoading: Bool) -> some View {
        ZStack {
            self

            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
        .animation(.easeInOut, value: isLoading)
    }
}

// MARK: - Error Handling

extension View {
    /// Shows an error alert
    func errorAlert(error: Binding<Error?>, buttonTitle: String = "OK") -> some View {
        alert(
            "Error",
            isPresented: .constant(error.wrappedValue != nil),
            actions: {
                Button(buttonTitle) {
                    error.wrappedValue = nil
                }
            },
            message: {
                if let error = error.wrappedValue {
                    Text(error.localizedDescription)
                }
            }
        )
    }
}

// MARK: - Device Specific

extension View {
    /// Applies modifier only on iPhone
    @ViewBuilder
    func onPhone<Content: View>(@ViewBuilder _ transform: @escaping (Self) -> Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            transform(self)
        } else {
            self
        }
    }

    /// Applies modifier only on iPad
    @ViewBuilder
    func onPad<Content: View>(@ViewBuilder _ transform: @escaping (Self) -> Content) -> some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            transform(self)
        } else {
            self
        }
    }
}

// MARK: - Size Reader

extension View {
    /// Reads the size of the view
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometry.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

// MARK: - Frame Helpers

extension View {
    /// Sets both width and height to the same value
    func frame(size: CGFloat) -> some View {
        frame(width: size, height: size)
    }

    /// Sets minimum and maximum width/height
    func frame(minSize: CGFloat? = nil, maxSize: CGFloat? = nil) -> some View {
        frame(
            minWidth: minSize,
            maxWidth: maxSize,
            minHeight: minSize,
            maxHeight: maxSize
        )
    }
}

// MARK: - Visibility

extension View {
    /// Shows or hides the view
    @ViewBuilder
    func visible(_ isVisible: Bool) -> some View {
        if isVisible {
            self
        } else {
            self.hidden()
        }
    }

    /// Removes the view from hierarchy when condition is false
    @ViewBuilder
    func removed(when condition: Bool) -> some View {
        if !condition {
            self
        }
    }
}

// MARK: - Animations

extension View {
    /// Adds a repeating animation
    func repeatingAnimation<V: Equatable>(
        _ animation: Animation = .default,
        value: V
    ) -> some View {
        self.animation(animation.repeatForever(autoreverses: true), value: value)
    }
}

// MARK: - Debug

extension View {
    /// Adds a debug border in debug builds
    func debugBorder(_ color: Color = .red, width: CGFloat = 1) -> some View {
        #if DEBUG
        return self.border(color, width: width)
        #else
        return self
        #endif
    }

    /// Prints a value in debug builds
    func debugPrint(_ items: Any...) -> some View {
        #if DEBUG
        print(items)
        #endif
        return self
    }
}