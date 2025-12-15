//
//  MVVMDemo.swift
//  My_iOS_Library
//
//  MVVM pattern demonstration and guide
//

import SwiftUI

// MARK: - MVVM Demo View

public struct MVVMDemo: View {
    @State private var showingGuide = false
    @Environment(\.theme) private var theme

    public init() {
        // Register dependencies on app launch
        registerDependencies()
    }

    public var body: some View {
        NavigationStack {
            PostListView()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            showingGuide = true
                        }) {
                            Image(systemName: "info.circle")
                        }
                    }
                }
                .sheet(isPresented: $showingGuide) {
                    NavigationStack {
                        MVVMGuideView()
                    }
                }
        }
    }

    private func registerDependencies() {
        // Register services
        DependencyContainer.shared.register(
            UserService() as UserServiceProtocol,
            for: UserServiceProtocol.self
        )

        DependencyContainer.shared.register(
            PostService() as PostServiceProtocol,
            for: PostServiceProtocol.self
        )
    }
}

// MARK: - MVVM Guide View

struct MVVMGuideView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Introduction
                VStack(alignment: .leading, spacing: 16) {
                    Text("MVVM Architecture Guide")
                        .font(theme.typography.title)

                    Text("""
                    This example demonstrates a production-ready MVVM architecture pattern that balances simplicity with professionalism. The implementation is designed to be easily copied and adapted for your projects.
                    """)
                    .font(theme.typography.body1)
                    .foregroundColor(theme.textSecondary)
                }

                // Architecture Overview
                sectionView(
                    title: "Architecture Overview",
                    content: """
                    The MVVM (Model-View-ViewModel) pattern separates your app into three distinct layers:

                    • **Models**: Data structures (User, Post, Comment)
                    • **ViewModels**: Business logic and state management
                    • **Views**: UI presentation layer

                    This separation ensures testability, reusability, and maintainability.
                    """
                )

                // Key Components
                sectionView(
                    title: "Key Components",
                    examples: [
                        MVVMExample(
                            title: "ViewModelProtocol",
                            code: """
                            @MainActor
                            public protocol ViewModelProtocol: ObservableObject {
                                associatedtype State
                                associatedtype Action

                                var state: State { get }
                                func handle(_ action: Action)
                            }
                            """,
                            description: "Base protocol ensuring consistent ViewModel structure"
                        ),
                        MVVMExample(
                            title: "LoadingState",
                            code: """
                            public enum LoadingState<T: Equatable>: Equatable {
                                case idle
                                case loading
                                case loaded(T)
                                case error(ErrorState)
                            }
                            """,
                            description: "Generic loading state for async operations"
                        ),
                        MVVMExample(
                            title: "Dependency Injection",
                            code: """
                            @Injected private var userService: UserServiceProtocol

                            // Register on app startup
                            DependencyContainer.shared.register(
                                UserService(),
                                for: UserServiceProtocol.self
                            )
                            """,
                            description: "Simple but effective dependency management"
                        )
                    ]
                )

                // ViewModel Pattern
                sectionView(
                    title: "ViewModel Pattern",
                    examples: [
                        MVVMExample(
                            title: "State Management",
                            code: """
                            public struct State: Equatable {
                                var posts: LoadingState<[Post]> = .idle
                                var searchText: String = ""
                                var selectedFilter: PostFilter = .all
                            }

                            @Published public private(set) var state = State()
                            """,
                            description: "Immutable state with controlled updates"
                        ),
                        MVVMExample(
                            title: "Action Handling",
                            code: """
                            public enum Action {
                                case loadPosts
                                case searchTextChanged(String)
                                case likePost(String)
                                case deletePost(String)
                            }

                            public func handle(_ action: Action) {
                                switch action {
                                case .loadPosts:
                                    loadPosts()
                                // ... handle other actions
                                }
                            }
                            """,
                            description: "Clear action-based API for Views"
                        )
                    ]
                )

                // Service Layer
                sectionView(
                    title: "Service Layer",
                    examples: [
                        MVVMExample(
                            title: "Service Protocol",
                            code: """
                            public protocol PostServiceProtocol: ServiceProtocol {
                                func fetchPosts(userId: String?) async throws -> [Post]
                                func likePost(id: String) async throws -> Post
                                func createPost(_ post: Post) async throws -> Post
                            }
                            """,
                            description: "Protocol-based services for easy testing"
                        ),
                        MVVMExample(
                            title: "Async/Await Integration",
                            code: """
                            private func loadPosts() {
                                Task {
                                    state.posts = .loading
                                    do {
                                        let posts = try await postService.fetchPosts()
                                        state.posts = .loaded(posts)
                                    } catch {
                                        state.posts = .error(ErrorState(
                                            message: error.localizedDescription
                                        ))
                                    }
                                }
                            }
                            """,
                            description: "Modern concurrency with proper error handling"
                        )
                    ]
                )

                // View Integration
                sectionView(
                    title: "View Integration",
                    examples: [
                        MVVMExample(
                            title: "Using ViewModels",
                            code: """
                            struct PostListView: View {
                                @StateObject private var viewModel = PostListViewModel()

                                var body: some View {
                                    // Use viewModel.state for UI
                                    // Call viewModel.handle() for actions
                                }
                            }
                            """,
                            description: "Clean View-ViewModel binding"
                        ),
                        MVVMExample(
                            title: "Reactive UI",
                            code: """
                            switch viewModel.state.posts {
                            case .idle:
                                EmptyView()
                            case .loading:
                                ProgressView()
                            case .loaded(let posts):
                                PostListContent(posts: posts)
                            case .error(let error):
                                ErrorView(error: error)
                            }
                            """,
                            description: "UI automatically updates with state changes"
                        )
                    ]
                )

                // Best Practices
                sectionView(
                    title: "Best Practices",
                    content: """
                    • **Single Responsibility**: Each ViewModel manages one screen/feature
                    • **Immutable State**: Use structs for state, update via published property
                    • **Protocol-Oriented**: Define protocols for all services
                    • **Error Handling**: Always handle errors gracefully with retry options
                    • **Testing**: ViewModels are easily unit testable
                    • **Memory Management**: Use weak self in closures to avoid retain cycles
                    """
                )

                // Usage Guide
                sectionView(
                    title: "How to Use This Pattern",
                    content: """
                    1. **Copy the base files**: MVVMProtocols.swift contains reusable components
                    2. **Create your models**: Simple structs conforming to Identifiable/Codable
                    3. **Define service protocols**: Abstract your network/database operations
                    4. **Implement ViewModels**: Follow the State/Action pattern
                    5. **Build your Views**: Use @StateObject and bind to ViewModel state
                    6. **Register dependencies**: Set up DI container on app launch

                    The pattern scales from simple features to complex apps while maintaining clarity.
                    """
                )

                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("MVVM Guide")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }

    private func sectionView(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(theme.typography.heading2)

            Text(content)
                .font(theme.typography.body2)
                .foregroundColor(theme.textSecondary)
        }
    }

    private func sectionView(title: String, examples: [MVVMExample]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(theme.typography.heading2)

            ForEach(examples) { example in
                MVVMExampleView(example: example)
            }
        }
    }
}

// MARK: - Example View

struct MVVMExampleView: View {
    @Environment(\.theme) private var theme
    let example: MVVMExample

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(example.title)
                .font(theme.typography.heading3)

            if let description = example.description {
                Text(description)
                    .font(theme.typography.body2)
                    .foregroundColor(theme.textSecondary)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                Text(example.code)
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(theme.textPrimary)
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(8)
            }
        }
    }
}

struct MVVMExample: Identifiable {
    let id = UUID()
    let title: String
    let code: String
    let description: String?

    init(title: String, code: String, description: String? = nil) {
        self.title = title
        self.code = code
        self.description = description
    }
}

// MARK: - Preview

#Preview {
    MVVMDemo()
        .theme(DefaultTheme())
        .typography(DefaultTypography())
        .spacing(DefaultSpacing())
}