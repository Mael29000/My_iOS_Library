//
//  ViewModels.swift
//  My_iOS_Library
//
//  ViewModels demonstrating MVVM pattern
//

import SwiftUI
import Combine

// MARK: - User Profile ViewModel

@MainActor
public class UserProfileViewModel: ViewModelProtocol {

    // MARK: - State

    public struct State: Equatable {
        var userState: LoadingState<User> = .idle
        var isFollowing: Bool = false
        var isEditingProfile: Bool = false
    }

    // MARK: - Actions

    public enum Action {
        case loadUser(String)
        case followUser
        case unfollowUser
        case editProfile
        case logout
    }

    // MARK: - Properties

    @Published public private(set) var state = State()

    @Injected private var userService: UserServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init() {}

    // MARK: - Action Handler

    public func handle(_ action: Action) {
        switch action {
        case .loadUser(let userId):
            loadUser(userId: userId)

        case .followUser:
            followUser()

        case .unfollowUser:
            unfollowUser()

        case .editProfile:
            state.isEditingProfile = true

        case .logout:
            // In a real app, clear auth tokens and navigate to login
            print("Logging out...")
        }
    }

    // MARK: - Private Methods

    private func loadUser(userId: String) {
        Task {
            state.userState = .loading

            do {
                let user = try await userService.fetchUser(id: userId)
                state.userState = .loaded(user)
            } catch {
                state.userState = .error(ErrorState(
                    message: error.localizedDescription,
                    retry: { [weak self] in
                        self?.loadUser(userId: userId)
                    }
                ))
            }
        }
    }

    private func followUser() {
        guard case .loaded(let user) = state.userState else { return }

        Task {
            do {
                try await userService.followUser(id: user.id)
                state.isFollowing = true
            } catch {
                // Handle error - show alert or toast
                print("Failed to follow: \(error)")
            }
        }
    }

    private func unfollowUser() {
        guard case .loaded(let user) = state.userState else { return }

        Task {
            do {
                try await userService.unfollowUser(id: user.id)
                state.isFollowing = false
            } catch {
                // Handle error
                print("Failed to unfollow: \(error)")
            }
        }
    }
}

// MARK: - Post List ViewModel

@MainActor
public class PostListViewModel: ViewModelProtocol {

    // MARK: - State

    public struct State: Equatable {
        var posts: LoadingState<[Post]> = .idle
        var searchText: String = ""
        var selectedFilter: PostFilter = .all
        var isCreatePostPresented: Bool = false

        var filteredPosts: [Post] {
            guard case .loaded(let allPosts) = posts else { return [] }

            var filtered = allPosts

            // Apply filter
            switch selectedFilter {
            case .all:
                break
            case .liked:
                filtered = filtered.filter { $0.isLiked }
            case .byUser(let userId):
                filtered = filtered.filter { $0.userId == userId }
            }

            // Apply search
            if !searchText.isEmpty {
                filtered = filtered.filter { post in
                    post.title.localizedCaseInsensitiveContains(searchText) ||
                    post.content.localizedCaseInsensitiveContains(searchText)
                }
            }

            return filtered
        }
    }

    public enum PostFilter: Equatable {
        case all
        case liked
        case byUser(String)
    }

    // MARK: - Actions

    public enum Action {
        case loadPosts
        case refreshPosts
        case searchTextChanged(String)
        case filterChanged(PostFilter)
        case likePost(String)
        case deletePost(String)
        case createPost
    }

    // MARK: - Properties

    @Published public private(set) var state = State()

    @Injected private var postService: PostServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization

    public init() {
        // Auto-load posts on init
        handle(.loadPosts)
    }

    // MARK: - Action Handler

    public func handle(_ action: Action) {
        switch action {
        case .loadPosts:
            loadPosts()

        case .refreshPosts:
            loadPosts(isRefresh: true)

        case .searchTextChanged(let text):
            state.searchText = text

        case .filterChanged(let filter):
            state.selectedFilter = filter

        case .likePost(let postId):
            toggleLike(postId: postId)

        case .deletePost(let postId):
            deletePost(postId: postId)

        case .createPost:
            state.isCreatePostPresented = true
        }
    }

    // MARK: - Private Methods

    private func loadPosts(isRefresh: Bool = false) {
        // Don't reload if already loading (unless it's a refresh)
        if case .loading = state.posts, !isRefresh {
            return
        }

        Task {
            state.posts = .loading

            do {
                let userId: String? = state.selectedFilter.userId
                let posts = try await postService.fetchPosts(userId: userId)
                state.posts = .loaded(posts)
            } catch {
                state.posts = .error(ErrorState(
                    message: error.localizedDescription,
                    retry: { [weak self] in
                        self?.loadPosts()
                    }
                ))
            }
        }
    }

    private func toggleLike(postId: String) {
        guard case .loaded(var posts) = state.posts,
              let index = posts.firstIndex(where: { $0.id == postId }) else {
            return
        }

        let post = posts[index]

        Task {
            do {
                let updatedPost = post.isLiked ?
                    try await postService.unlikePost(id: postId) :
                    try await postService.likePost(id: postId)

                posts[index] = updatedPost
                state.posts = .loaded(posts)
            } catch {
                // Handle error
                print("Failed to toggle like: \(error)")
            }
        }
    }

    private func deletePost(postId: String) {
        Task {
            do {
                try await postService.deletePost(id: postId)

                // Remove from local state
                if case .loaded(var posts) = state.posts {
                    posts.removeAll { $0.id == postId }
                    state.posts = .loaded(posts)
                }
            } catch {
                // Handle error
                print("Failed to delete post: \(error)")
            }
        }
    }
}

// MARK: - Post Filter Extension

extension PostListViewModel.PostFilter {
    var userId: String? {
        if case .byUser(let id) = self {
            return id
        }
        return nil
    }
}

// MARK: - Post Detail ViewModel

@MainActor
public class PostDetailViewModel: ViewModelProtocol {

    // MARK: - State

    public struct State: Equatable {
        var post: LoadingState<Post> = .idle
        var comments: LoadingState<[Comment]> = .idle
        var isLiked: Bool = false
        var newCommentText: String = ""
        var isAddingComment: Bool = false
    }

    // MARK: - Actions

    public enum Action {
        case loadPost(String)
        case loadComments
        case likePost
        case unlikePost
        case updateCommentText(String)
        case addComment
        case deleteComment(String)
        case sharePost
    }

    // MARK: - Properties

    @Published public private(set) var state = State()

    @Injected private var postService: PostServiceProtocol
    private var postId: String?

    // MARK: - Initialization

    public init() {}

    public func loadPost(id: String) {
        self.postId = id
        handle(.loadPost(id))
        handle(.loadComments)
    }

    // MARK: - Action Handler

    public func handle(_ action: Action) {
        switch action {
        case .loadPost(let id):
            loadPost(postId: id)

        case .loadComments:
            loadComments()

        case .likePost:
            toggleLike(true)

        case .unlikePost:
            toggleLike(false)

        case .updateCommentText(let text):
            state.newCommentText = text

        case .addComment:
            addComment()

        case .deleteComment(let commentId):
            deleteComment(commentId: commentId)

        case .sharePost:
            sharePost()
        }
    }

    // MARK: - Private Methods

    private func loadPost(postId: String) {
        Task {
            state.post = .loading

            do {
                let post = try await postService.fetchPost(id: postId)
                state.post = .loaded(post)
                state.isLiked = post.isLiked
            } catch {
                state.post = .error(ErrorState(
                    message: error.localizedDescription,
                    retry: { [weak self] in
                        self?.loadPost(postId: postId)
                    }
                ))
            }
        }
    }

    private func loadComments() {
        // In a real app, this would fetch comments from a service
        Task {
            state.comments = .loading

            // Simulate loading
            try? await Task.sleep(nanoseconds: 500_000_000)

            // Mock comments
            let mockComments = [
                Comment(
                    postId: postId ?? "",
                    userId: "user1",
                    userName: "Alice",
                    content: "Great post! Really helpful."
                ),
                Comment(
                    postId: postId ?? "",
                    userId: "user2",
                    userName: "Bob",
                    content: "Thanks for sharing this."
                )
            ]

            state.comments = .loaded(mockComments)
        }
    }

    private func toggleLike(_ isLiked: Bool) {
        guard let postId = postId else { return }

        Task {
            do {
                let updatedPost = isLiked ?
                    try await postService.likePost(id: postId) :
                    try await postService.unlikePost(id: postId)

                state.post = .loaded(updatedPost)
                state.isLiked = updatedPost.isLiked
            } catch {
                // Handle error
                print("Failed to toggle like: \(error)")
            }
        }
    }

    private func addComment() {
        guard !state.newCommentText.isEmpty,
              let postId = postId else { return }

        state.isAddingComment = true

        Task {
            // Simulate adding comment
            try? await Task.sleep(nanoseconds: 500_000_000)

            let newComment = Comment(
                postId: postId,
                userId: "current",
                userName: "You",
                content: state.newCommentText
            )

            if case .loaded(var comments) = state.comments {
                comments.append(newComment)
                state.comments = .loaded(comments)
            }

            state.newCommentText = ""
            state.isAddingComment = false
        }
    }

    private func deleteComment(commentId: String) {
        if case .loaded(var comments) = state.comments {
            comments.removeAll { $0.id == commentId }
            state.comments = .loaded(comments)
        }
    }

    private func sharePost() {
        guard case .loaded(let post) = state.post else { return }

        // In a real app, this would present a share sheet
        print("Sharing post: \(post.title)")
    }
}

// MARK: - Create Post ViewModel

@MainActor
public class CreatePostViewModel: ViewModelProtocol {

    // MARK: - State

    public struct State: Equatable {
        var title: String = ""
        var content: String = ""
        var selectedImageData: Data?
        var isCreating: Bool = false
        var validationErrors: [ValidationError] = []

        var isValid: Bool {
            !title.isEmpty && !content.isEmpty
        }
    }

    public enum ValidationError: String, Equatable {
        case emptyTitle = "Title is required"
        case emptyContent = "Content is required"
        case titleTooLong = "Title must be less than 100 characters"
        case contentTooShort = "Content must be at least 10 characters"
    }

    // MARK: - Actions

    public enum Action {
        case updateTitle(String)
        case updateContent(String)
        case selectImage(Data?)
        case createPost
        case validate
    }

    // MARK: - Properties

    @Published public private(set) var state = State()

    @Injected private var postService: PostServiceProtocol

    // Completion handler
    public var onPostCreated: ((Post) -> Void)?

    // MARK: - Initialization

    public init() {}

    // MARK: - Action Handler

    public func handle(_ action: Action) {
        switch action {
        case .updateTitle(let title):
            state.title = title
            validateIfNeeded()

        case .updateContent(let content):
            state.content = content
            validateIfNeeded()

        case .selectImage(let imageData):
            state.selectedImageData = imageData

        case .createPost:
            createPost()

        case .validate:
            validate()
        }
    }

    // MARK: - Private Methods

    private func validateIfNeeded() {
        if !state.validationErrors.isEmpty {
            validate()
        }
    }

    private func validate() {
        var errors: [ValidationError] = []

        if state.title.isEmpty {
            errors.append(.emptyTitle)
        } else if state.title.count > 100 {
            errors.append(.titleTooLong)
        }

        if state.content.isEmpty {
            errors.append(.emptyContent)
        } else if state.content.count < 10 {
            errors.append(.contentTooShort)
        }

        state.validationErrors = errors
    }

    private func createPost() {
        validate()

        guard state.isValid else { return }

        state.isCreating = true

        Task {
            do {
                // In a real app, upload image first if selected
                let imageURL: String? = nil // Would be set after image upload

                let newPost = Post(
                    userId: "current",
                    title: state.title,
                    content: state.content,
                    imageURL: imageURL
                )

                let createdPost = try await postService.createPost(newPost)

                // Call completion handler
                onPostCreated?(createdPost)

                // Reset state
                state = State()
            } catch {
                state.isCreating = false
                // Handle error - show alert
                print("Failed to create post: \(error)")
            }
        }
    }
}