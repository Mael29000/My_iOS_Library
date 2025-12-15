//
//  MVVMProtocols.swift
//  My_iOS_Library
//
//  Base protocols for MVVM architecture
//

import SwiftUI
import Combine

// MARK: - ViewModel Protocol

/// Base protocol for all ViewModels
@MainActor
public protocol ViewModelProtocol: ObservableObject {
    associatedtype State
    associatedtype Action

    var state: State { get }
    func handle(_ action: Action)
}

// MARK: - Service Protocol

/// Base protocol for services
public protocol ServiceProtocol {
    // Services can be customized based on needs
}

// MARK: - Loading State

/// Common loading states for async operations
public enum LoadingState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case error(ErrorState)

    public var data: T? {
        if case .loaded(let value) = self {
            return value
        }
        return nil
    }
}

public struct ErrorState: Equatable {
    public let message: String
    public let retry: (() -> Void)?

    public init(message: String, retry: (() -> Void)? = nil) {
        self.message = message
        self.retry = retry
    }

    public static func == (lhs: ErrorState, rhs: ErrorState) -> Bool {
        lhs.message == rhs.message
    }
}

// MARK: - Dependency Injection

/// Simple dependency container
@MainActor
public class DependencyContainer: ObservableObject {
    private var services: [String: Any] = [:]

    public static let shared = DependencyContainer()

    private init() {}

    /// Register a service
    public func register<T>(_ service: T, for type: T.Type) {
        let key = String(describing: type)
        services[key] = service
    }

    /// Resolve a service
    public func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let service = services[key] as? T else {
            fatalError("Service \(key) not registered")
        }
        return service
    }
}

// MARK: - Property Wrappers

/// Injects a service from the dependency container
@propertyWrapper
@MainActor
public struct Injected<T> {
    private let keyPath: WritableKeyPath<DependencyContainer, T>?

    public var wrappedValue: T {
        get {
            if let keyPath = keyPath {
                return DependencyContainer.shared[keyPath: keyPath]
            }
            return DependencyContainer.shared.resolve(T.self)
        }
    }

    public init() {
        self.keyPath = nil
    }
}

// MARK: - Async State Helper

/// Helper to manage async state in ViewModels
@MainActor
public class AsyncState<T: Equatable>: ObservableObject {
    @Published public var state: LoadingState<T> = .idle

    public var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    public var hasError: Bool {
        if case .error = state { return true }
        return false
    }

    public var data: T? {
        if case .loaded(let data) = state { return data }
        return nil
    }

    public init() {}

    public func load(action: @escaping () async throws -> T) {
        Task {
            await load(action: action)
        }
    }

    @MainActor
    public func load(action: @escaping () async throws -> T) async {
        state = .loading
        do {
            let data = try await action()
            state = .loaded(data)
        } catch {
            state = .error(ErrorState(
                message: error.localizedDescription,
                retry: { [weak self] in
                    self?.load(action: action)
                }
            ))
        }
    }
}