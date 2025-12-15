//
//  Services.swift
//  My_iOS_Library
//
//  Sample services for MVVM demo
//

import Foundation
import Combine

// MARK: - User Service Protocol

public protocol UserServiceProtocol: ServiceProtocol {
    func fetchCurrentUser() async throws -> User
    func fetchUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws -> User
    func followUser(id: String) async throws -> Void
    func unfollowUser(id: String) async throws -> Void
}

// MARK: - User Service Implementation

public class UserService: UserServiceProtocol {
    // In a real app, this would make network calls
    private var users: [String: User] = [:]

    public init() {
        // Create mock users
        createMockUsers()
    }

    public func fetchCurrentUser() async throws -> User {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)

        guard let user = users["current"] else {
            throw APIError.notFound
        }
        return user
    }

    public func fetchUser(id: String) async throws -> User {
        try await Task.sleep(nanoseconds: 300_000_000)

        guard let user = users[id] else {
            throw APIError.notFound
        }
        return user
    }

    public func updateUser(_ user: User) async throws -> User {
        try await Task.sleep(nanoseconds: 500_000_000)

        users[user.id] = user
        return user
    }

    public func followUser(id: String) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        // Update follow status
    }

    public func unfollowUser(id: String) async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
        // Update follow status
    }

    private func createMockUsers() {
        users["current"] = User(
            id: "current",
            name: "John Doe",
            email: "john@example.com",
            avatarURL: "https://picsum.photos/200",
            isVerified: true,
            bio: "iOS Developer | SwiftUI Enthusiast",
            followersCount: 1234,
            followingCount: 567
        )

        users["user1"] = User(
            id: "user1",
            name: "Alice Smith",
            email: "alice@example.com",
            avatarURL: "https://picsum.photos/201",
            followersCount: 890,
            followingCount: 234
        )

        users["user2"] = User(
            id: "user2",
            name: "Bob Johnson",
            email: "bob@example.com",
            avatarURL: "https://picsum.photos/202",
            isVerified: true,
            followersCount: 5678,
            followingCount: 123
        )
    }
}

// MARK: - Post Service Protocol

public protocol PostServiceProtocol: ServiceProtocol {
    func fetchPosts(userId: String?) async throws -> [Post]
    func fetchPost(id: String) async throws -> Post
    func createPost(_ post: Post) async throws -> Post
    func updatePost(_ post: Post) async throws -> Post
    func deletePost(id: String) async throws -> Void
    func likePost(id: String) async throws -> Post
    func unlikePost(id: String) async throws -> Post
}

// MARK: - Post Service Implementation

public class PostService: PostServiceProtocol {
    private var posts: [Post] = []

    public init() {
        createMockPosts()
    }

    public func fetchPosts(userId: String? = nil) async throws -> [Post] {
        try await Task.sleep(nanoseconds: 500_000_000)

        if let userId = userId {
            return posts.filter { $0.userId == userId }
        }
        return posts
    }

    public func fetchPost(id: String) async throws -> Post {
        try await Task.sleep(nanoseconds: 300_000_000)

        guard let post = posts.first(where: { $0.id == id }) else {
            throw APIError.notFound
        }
        return post
    }

    public func createPost(_ post: Post) async throws -> Post {
        try await Task.sleep(nanoseconds: 500_000_000)

        posts.insert(post, at: 0)
        return post
    }

    public func updatePost(_ post: Post) async throws -> Post {
        try await Task.sleep(nanoseconds: 500_000_000)

        if let index = posts.firstIndex(where: { $0.id == post.id }) {
            posts[index] = post
        }
        return post
    }

    public func deletePost(id: String) async throws {
        try await Task.sleep(nanoseconds: 300_000_000)

        posts.removeAll { $0.id == id }
    }

    public func likePost(id: String) async throws -> Post {
        try await Task.sleep(nanoseconds: 200_000_000)

        guard let index = posts.firstIndex(where: { $0.id == id }) else {
            throw APIError.notFound
        }

        var post = posts[index]
        post = Post(
            id: post.id,
            userId: post.userId,
            title: post.title,
            content: post.content,
            imageURL: post.imageURL,
            createdAt: post.createdAt,
            updatedAt: post.updatedAt,
            likes: post.likes + 1,
            comments: post.comments,
            isLiked: true
        )
        posts[index] = post
        return post
    }

    public func unlikePost(id: String) async throws -> Post {
        try await Task.sleep(nanoseconds: 200_000_000)

        guard let index = posts.firstIndex(where: { $0.id == id }) else {
            throw APIError.notFound
        }

        var post = posts[index]
        post = Post(
            id: post.id,
            userId: post.userId,
            title: post.title,
            content: post.content,
            imageURL: post.imageURL,
            createdAt: post.createdAt,
            updatedAt: post.updatedAt,
            likes: max(0, post.likes - 1),
            comments: post.comments,
            isLiked: false
        )
        posts[index] = post
        return post
    }

    private func createMockPosts() {
        let mockPosts = [
            Post(
                id: "post1",
                userId: "current",
                title: "Getting Started with SwiftUI",
                content: "SwiftUI is an amazing framework for building user interfaces...",
                imageURL: "https://picsum.photos/400/300",
                likes: 42,
                comments: 5,
                isLiked: true
            ),
            Post(
                id: "post2",
                userId: "user1",
                title: "MVVM Architecture in iOS",
                content: "Let's explore how to implement MVVM pattern in iOS apps...",
                imageURL: "https://picsum.photos/400/301",
                likes: 38,
                comments: 12
            ),
            Post(
                id: "post3",
                userId: "user2",
                title: "Async/Await Best Practices",
                content: "Here are some tips for using async/await effectively...",
                likes: 56,
                comments: 8
            ),
            Post(
                id: "post4",
                userId: "current",
                title: "Building Reusable Components",
                content: "Component-based architecture helps create maintainable apps...",
                imageURL: "https://picsum.photos/400/302",
                likes: 29,
                comments: 3
            )
        ]
        posts = mockPosts
    }
}

// MARK: - API Error

public enum APIError: LocalizedError {
    case notFound
    case unauthorized
    case serverError(String)
    case networkError
    case decodingError

    public var errorDescription: String? {
        switch self {
        case .notFound:
            return "Resource not found"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError(let message):
            return "Server error: \(message)"
        case .networkError:
            return "Network connection error"
        case .decodingError:
            return "Failed to decode response"
        }
    }
}

// MARK: - Network Service Protocol

public protocol NetworkServiceProtocol: ServiceProtocol {
    func request<T: Decodable>(_ endpoint: String, method: HTTPMethod, body: Data?) async throws -> T
}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}