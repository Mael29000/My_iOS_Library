//
//  Binding+Extensions.swift
//  My iOS library
//
//  Essential Binding extensions for productivity
//

import SwiftUI

extension Binding {

    // MARK: - Nil Coalescing

    /// Creates a binding that uses a default value when nil
    static func ?? <T>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
        Binding<T>(
            get: { lhs.wrappedValue ?? rhs },
            set: { lhs.wrappedValue = $0 }
        )
    }

    /// Creates a binding with a default value
    func defaultValue<T>(_ value: T) -> Binding<T> where Value == T? {
        Binding<T>(
            get: { self.wrappedValue ?? value },
            set: { self.wrappedValue = $0 }
        )
    }

    // MARK: - Optional Binding

    /// Converts optional binding to non-optional with default
    func toNonOptional<T>(defaultValue: T) -> Binding<T> where Value == T? {
        Binding<T>(
            get: { self.wrappedValue ?? defaultValue },
            set: { self.wrappedValue = $0 }
        )
    }

    /// Creates optional binding from non-optional
    func toOptional<T>() -> Binding<T?> where Value == T {
        Binding<T?>(
            get: { self.wrappedValue },
            set: { newValue in
                if let newValue = newValue {
                    self.wrappedValue = newValue
                }
            }
        )
    }

    // MARK: - Mapping

    /// Maps binding value with transform functions
    func map<T>(
        get: @escaping (Value) -> T,
        set: @escaping (T) -> Value
    ) -> Binding<T> {
        Binding<T>(
            get: { get(self.wrappedValue) },
            set: { self.wrappedValue = set($0) }
        )
    }

    /// Maps binding value (read-only transform)
    func map<T>(_ transform: @escaping (Value) -> T) -> Binding<T> where T == Value {
        Binding<T>(
            get: { transform(self.wrappedValue) },
            set: { self.wrappedValue = $0 }
        )
    }

    // MARK: - Boolean Operations

    /// Creates a negated boolean binding
    prefix static func ! (value: Binding<Bool>) -> Binding<Bool> {
        Binding<Bool>(
            get: { !value.wrappedValue },
            set: { value.wrappedValue = !$0 }
        )
    }

    /// Toggles boolean binding
    func toggle() where Value == Bool {
        wrappedValue.toggle()
    }

    // MARK: - String Operations
    // String-specific operations are in the extension below

    // MARK: - Numeric Operations
    // Numeric-specific operations are in the extensions below

    // MARK: - Collection Operations
    // Collection-specific operations are in the extension below

    // MARK: - Debugging

    /// Logs changes to the binding
    func logged(_ prefix: String = "Binding") -> Binding<Value> {
        Binding(
            get: {
                let value = self.wrappedValue
                print("\(prefix) - Get: \(value)")
                return value
            },
            set: { newValue in
                print("\(prefix) - Set: \(newValue)")
                self.wrappedValue = newValue
            }
        )
    }

    /// Adds onChange handler to binding
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }

    /// Adds validation to binding
    func validated(_ isValid: @escaping (Value) -> Bool) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                if isValid(newValue) {
                    self.wrappedValue = newValue
                }
            }
        )
    }

    // MARK: - Async Operations

    /// Debounces binding updates
    func debounced(delay: TimeInterval = 0.3) -> Binding<Value> {
        let timer = DebounceTimer(delay: delay)

        return Binding(
            get: { self.wrappedValue },
            set: { newValue in
                timer.debounce {
                    self.wrappedValue = newValue
                }
            }
        )
    }
}

// MARK: - Helper Classes

private class DebounceTimer {
    private var workItem: DispatchWorkItem?
    private let delay: TimeInterval
    private let queue: DispatchQueue

    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }

    func debounce(action: @escaping () -> Void) {
        workItem?.cancel()
        let workItem = DispatchWorkItem(block: action)
        self.workItem = workItem
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}

// MARK: - Constant Binding

extension Binding {
    /// Creates a constant binding (read-only)
    static func constant(_ value: Value) -> Binding<Value> {
        Binding(
            get: { value },
            set: { _ in }
        )
    }
}

// MARK: - Two-Way Binding Conversion

extension Binding {
    /// Converts between different numeric types
    func converted<T: BinaryInteger, U: BinaryInteger>() -> Binding<U> where Value == T {
        Binding<U>(
            get: { U(self.wrappedValue) },
            set: { self.wrappedValue = T($0) }
        )
    }

    /// Converts between numeric and string
    func stringified<T: LosslessStringConvertible>() -> Binding<String> where Value == T {
        Binding<String>(
            get: { String(self.wrappedValue) },
            set: { self.wrappedValue = T($0) ?? self.wrappedValue }
        )
    }
}

// MARK: - KeyPath Binding

extension Binding {
    /// Creates a binding to a property via keypath
    func binding<T>(keyPath: WritableKeyPath<Value, T>) -> Binding<T> {
        Binding<T>(
            get: { self.wrappedValue[keyPath: keyPath] },
            set: { self.wrappedValue[keyPath: keyPath] = $0 }
        )
    }
}

// MARK: - Comparable Binding Extensions

extension Binding where Value: Comparable {
    /// Creates a clamped numeric binding
    func clamped(to range: ClosedRange<Value>) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = Swift.min(Swift.max(newValue, range.lowerBound), range.upperBound)
            }
        )
    }
}

// MARK: - Double Binding Extensions

extension Binding where Value == Double {
    /// Creates a rounded double binding
    func rounded(toPlaces places: Int = 0) -> Binding<Double> {
        let multiplier = pow(10.0, Double(places))
        return Binding(
            get: { self.wrappedValue },
            set: { self.wrappedValue = (($0 * multiplier).rounded() / multiplier) }
        )
    }
}

// MARK: - Collection Binding Extensions

extension Binding where Value: Collection {
    /// Creates a binding to collection count
    var count: Binding<Int> {
        Binding<Int>(
            get: { self.wrappedValue.count },
            set: { _ in } // Read-only
        )
    }

    /// Creates a binding to isEmpty state
    var isEmpty: Binding<Bool> {
        Binding<Bool>(
            get: { self.wrappedValue.isEmpty },
            set: { _ in } // Read-only
        )
    }
}

// MARK: - String Binding Extensions

extension Binding where Value == String {
    /// Creates a binding that trims whitespace
    var trimmed: Binding<String> {
        Binding(
            get: { self.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines) },
            set: { self.wrappedValue = $0 }
        )
    }

    /// Creates a binding that filters input
    func filtered(by predicate: @escaping (String) -> Bool) -> Binding<String> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                if predicate(newValue) {
                    self.wrappedValue = newValue
                }
            }
        )
    }

    /// Creates a binding limited to max length
    func maxLength(_ length: Int) -> Binding<String> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = String(newValue.prefix(length))
            }
        )
    }
}

// MARK: - Array Binding Extensions

extension Binding where Value: MutableCollection, Value.Index == Int {
    /// Creates bindings for array elements
    func element(at index: Int) -> Binding<Value.Element>? {
        guard index < wrappedValue.count else { return nil }

        return Binding<Value.Element>(
            get: { self.wrappedValue[index] },
            set: { self.wrappedValue[index] = $0 }
        )
    }
}

// MARK: - Dictionary Binding Extensions

extension Binding where Value == [String: Any] {
    /// Creates a binding for dictionary value
    func value(for key: String, default defaultValue: Any = "") -> Binding<Any> {
        Binding<Any>(
            get: { self.wrappedValue[key] ?? defaultValue },
            set: { self.wrappedValue[key] = $0 }
        )
    }
}