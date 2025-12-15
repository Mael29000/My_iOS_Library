//
//  MVVMViews.swift
//  My_iOS_Library
//
//  Views demonstrating MVVM pattern usage
//

import SwiftUI

// MARK: - User Profile View

public struct UserProfileView: View {
    @StateObject private var viewModel = UserProfileViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme

    let userId: String

    public init(userId: String) {
        self.userId = userId
    }

    public var body: some View {
        Group {
            switch viewModel.state.userState {
            case .idle:
                ProgressView()
                    .onAppear {
                        viewModel.handle(.loadUser(userId))
                    }

            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())

            case .loaded(let user):
                profileContent(user: user)

            case .error(let error):
                ErrorView(error: error)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: .constant(viewModel.state.isEditingProfile)) {
            MVVMEditProfileView(user: viewModel.state.userState.data ?? User(name: "", email: ""))
                .presentationDetents([.medium])
        }
    }

    private func profileContent(user: User) -> some View {
        ScrollView {
            VStack(spacing: 24) {
                // Profile Header
                VStack(spacing: 16) {
                    // Avatar
                    AsyncImage(url: URL(string: user.avatarURL ?? "")) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 80))
                            .foregroundColor(theme.textSecondary)
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())

                    // Name and verification
                    HStack {
                        Text(user.name)
                            .font(theme.typography.heading2)
                            .foregroundColor(theme.textPrimary)

                        if user.isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(theme.primaryColor)
                                .font(.caption)
                        }
                    }

                    // Bio
                    if let bio = user.bio {
                        Text(bio)
                            .font(theme.typography.body2)
                            .foregroundColor(theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }

                    // Stats
                    HStack(spacing: 40) {
                        VStack(spacing: 4) {
                            Text("\(user.followersCount)")
                                .font(theme.typography.heading3)
                                .foregroundColor(theme.textPrimary)
                            Text("Followers")
                                .font(theme.typography.label2)
                                .foregroundColor(theme.textSecondary)
                        }

                        VStack(spacing: 4) {
                            Text("\(user.followingCount)")
                                .font(theme.typography.heading3)
                                .foregroundColor(theme.textPrimary)
                            Text("Following")
                                .font(theme.typography.label2)
                                .foregroundColor(theme.textSecondary)
                        }
                    }
                }

                // Actions
                VStack(spacing: 12) {
                    if user.id != "current" {
                        Button(action: {
                            if viewModel.state.isFollowing {
                                viewModel.handle(.unfollowUser)
                            } else {
                                viewModel.handle(.followUser)
                            }
                        }) {
                            Text(viewModel.state.isFollowing ? "Unfollow" : "Follow")
                                .font(theme.typography.body1)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    viewModel.state.isFollowing ?
                                    Color.secondary.opacity(0.2) :
                                    theme.primaryColor
                                )
                                .foregroundColor(
                                    viewModel.state.isFollowing ?
                                    theme.textPrimary :
                                    .white
                                )
                                .cornerRadius(12)
                        }
                    } else {
                        Button(action: {
                            viewModel.handle(.editProfile)
                        }) {
                            Label("Edit Profile", systemImage: "pencil")
                                .font(theme.typography.body1)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.secondary.opacity(0.2))
                                .foregroundColor(theme.textPrimary)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)

                // Member since
                Text("Member since \(user.joinDate.formatted(date: .long, time: .omitted))")
                    .font(theme.typography.label2)
                    .foregroundColor(theme.textSecondary)
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Post List View

public struct PostListView: View {
    @StateObject private var viewModel = PostListViewModel()
    @Environment(\.theme) private var theme

    public init() {}

    public var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state.posts {
                case .idle, .loading:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .loaded:
                    postList

                case .error(let error):
                    ErrorView(error: error)
                }
            }
            .navigationTitle("Posts")
            .searchable(
                text: Binding(
                    get: { viewModel.state.searchText },
                    set: { viewModel.handle(.searchTextChanged($0)) }
                ),
                prompt: "Search posts..."
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.handle(.createPost)
                    }) {
                        Image(systemName: "plus")
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button(action: {
                            viewModel.handle(.filterChanged(.all))
                        }) {
                            Label("All Posts", systemImage: "list.bullet")
                        }

                        Button(action: {
                            viewModel.handle(.filterChanged(.liked))
                        }) {
                            Label("Liked Posts", systemImage: "heart.fill")
                        }

                        Button(action: {
                            viewModel.handle(.filterChanged(.byUser("current")))
                        }) {
                            Label("My Posts", systemImage: "person.fill")
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .refreshable {
                viewModel.handle(.refreshPosts)
            }
            .sheet(isPresented: .constant(viewModel.state.isCreatePostPresented)) {
                NavigationStack {
                    CreatePostView { post in
                        viewModel.handle(.refreshPosts)
                    }
                }
            }
        }
    }

    private var postList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.state.filteredPosts) { post in
                    NavigationLink(destination: PostDetailView(postId: post.id)) {
                        PostCardView(
                            post: post,
                            onLike: {
                                viewModel.handle(.likePost(post.id))
                            },
                            onDelete: {
                                viewModel.handle(.deletePost(post.id))
                            }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}

// MARK: - Post Detail View

public struct PostDetailView: View {
    @StateObject private var viewModel = PostDetailViewModel()
    @Environment(\.theme) private var theme

    let postId: String

    public init(postId: String) {
        self.postId = postId
    }

    public var body: some View {
        Group {
            switch viewModel.state.post {
            case .idle:
                ProgressView()
                    .onAppear {
                        viewModel.loadPost(id: postId)
                    }

            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())

            case .loaded(let post):
                detailContent(post: post)

            case .error(let error):
                ErrorView(error: error)
            }
        }
        .navigationTitle("Post")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    viewModel.handle(.sharePost)
                }) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }

    private func detailContent(post: Post) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Post Content
                VStack(alignment: .leading, spacing: 16) {
                    Text(post.title)
                        .font(theme.typography.heading2)
                        .foregroundColor(theme.textPrimary)

                    if let imageURL = post.imageURL {
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.secondary.opacity(0.2))
                                .frame(height: 200)
                                .overlay(
                                    ProgressView()
                                )
                        }
                        .cornerRadius(12)
                    }

                    Text(post.content)
                        .font(theme.typography.body1)
                        .foregroundColor(theme.textPrimary)

                    // Post Metadata
                    HStack {
                        Label("\(post.likes)", systemImage: "heart.fill")
                            .foregroundColor(viewModel.state.isLiked ? theme.errorColor : .secondary)
                            .onTapGesture {
                                viewModel.handle(viewModel.state.isLiked ? .unlikePost : .likePost)
                            }

                        Spacer()

                        Text(post.createdAt.formatted(date: .abbreviated, time: .shortened))
                            .font(theme.typography.label2)
                            .foregroundColor(theme.textSecondary)
                    }
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)

                // Comments Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Comments")
                        .font(theme.typography.heading3)
                        .foregroundColor(theme.textPrimary)

                    switch viewModel.state.comments {
                    case .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity)

                    case .loaded(let comments):
                        if comments.isEmpty {
                            Text("No comments yet. Be the first!")
                                .font(theme.typography.body2)
                                .foregroundColor(theme.textSecondary)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(comments) { comment in
                                CommentView(comment: comment) {
                                    viewModel.handle(.deleteComment(comment.id))
                                }
                            }
                        }

                    default:
                        EmptyView()
                    }

                    // Add Comment
                    HStack {
                        TextField("Add a comment...", text: Binding(
                            get: { viewModel.state.newCommentText },
                            set: { text in
                                viewModel.handle(.updateCommentText(text))
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .disabled(viewModel.state.isAddingComment)

                        Button(action: {
                            viewModel.handle(.addComment)
                        }) {
                            if viewModel.state.isAddingComment {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "paperplane.fill")
                            }
                        }
                        .disabled(viewModel.state.newCommentText.isEmpty || viewModel.state.isAddingComment)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Create Post View

public struct CreatePostView: View {
    @StateObject private var viewModel = CreatePostViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme

    let onPostCreated: (Post) -> Void

    public init(onPostCreated: @escaping (Post) -> Void) {
        self.onPostCreated = onPostCreated
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(theme.typography.label1)
                        .foregroundColor(theme.textPrimary)

                    TextField("Enter post title", text: Binding(
                        get: { viewModel.state.title },
                        set: { viewModel.handle(.updateTitle($0)) }
                    ))
                    .textFieldStyle(.roundedBorder)
                    .disabled(viewModel.state.isCreating)

                    if let error = viewModel.state.validationErrors.first(where: {
                        $0 == .emptyTitle || $0 == .titleTooLong
                    }) {
                        Text(error.rawValue)
                            .font(theme.typography.label2)
                            .foregroundColor(theme.errorColor)
                    }
                }

                // Content Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Content")
                        .font(theme.typography.label1)
                        .foregroundColor(theme.textPrimary)

                    TextEditor(text: Binding(
                        get: { viewModel.state.content },
                        set: { viewModel.handle(.updateContent($0)) }
                    ))
                    .frame(minHeight: 150)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                    )
                    .disabled(viewModel.state.isCreating)

                    if let error = viewModel.state.validationErrors.first(where: {
                        $0 == .emptyContent || $0 == .contentTooShort
                    }) {
                        Text(error.rawValue)
                            .font(theme.typography.label2)
                            .foregroundColor(theme.errorColor)
                    }
                }

                // Image Picker Button
                Button(action: {
                    // In a real app, present image picker
                    print("Select image")
                }) {
                    Label("Add Image", systemImage: "photo")
                        .font(theme.typography.body2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(12)
                }
                .disabled(viewModel.state.isCreating)

                // Preview of selected image
                if viewModel.state.selectedImageData != nil {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.2))
                        .frame(height: 200)
                        .overlay(
                            Text("Image Selected")
                                .font(theme.typography.body2)
                                .foregroundColor(theme.textSecondary)
                        )
                }
            }
            .padding()
        }
        .navigationTitle("Create Post")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .disabled(viewModel.state.isCreating)
            }

            ToolbarItem(placement: .confirmationAction) {
                Button("Create") {
                    viewModel.handle(.createPost)
                }
                .disabled(!viewModel.state.isValid || viewModel.state.isCreating)
            }
        }
        .interactiveDismissDisabled(viewModel.state.isCreating)
        .onAppear {
            viewModel.onPostCreated = { post in
                onPostCreated(post)
                dismiss()
            }
        }
    }
}

// MARK: - Supporting Views

struct PostCardView: View {
    @Environment(\.theme) private var theme

    let post: Post
    let onLike: () -> Void
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            Text(post.title)
                .font(theme.typography.heading3)
                .foregroundColor(theme.textPrimary)
                .lineLimit(2)

            // Content Preview
            Text(post.content)
                .font(theme.typography.body2)
                .foregroundColor(theme.textSecondary)
                .lineLimit(3)

            // Image Preview
            if let imageURL = post.imageURL {
                AsyncImage(url: URL(string: imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 150)
                        .clipped()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.secondary.opacity(0.2))
                        .frame(height: 150)
                }
                .cornerRadius(8)
            }

            // Actions
            HStack {
                Button(action: onLike) {
                    Label("\(post.likes)", systemImage: post.isLiked ? "heart.fill" : "heart")
                        .font(theme.typography.label2)
                        .foregroundColor(post.isLiked ? theme.errorColor : .secondary)
                }
                .buttonStyle(PlainButtonStyle())

                Label("\(post.comments)", systemImage: "bubble.right")
                    .font(theme.typography.label2)
                    .foregroundColor(.secondary)

                Spacer()

                if post.userId == "current" {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(theme.typography.label2)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Text(post.createdAt.formatted(date: .omitted, time: .shortened))
                    .font(theme.typography.label2)
                    .foregroundColor(theme.textSecondary)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct CommentView: View {
    @Environment(\.theme) private var theme

    let comment: Comment
    let onDelete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(comment.userName)
                    .font(theme.typography.body2)
                    .bold()

                Spacer()

                if comment.userId == "current" {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            Text(comment.content)
                .font(theme.typography.body2)
                .foregroundColor(theme.textPrimary)

            Text(comment.createdAt.formatted(date: .omitted, time: .shortened))
                .font(theme.typography.label2)
                .foregroundColor(theme.textSecondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(8)
    }
}

struct MVVMEditProfileView: View {
    let user: User

    var body: some View {
        Text("Edit Profile for \(user.name)")
            .navigationTitle("Edit Profile")
    }
}

struct ErrorView: View {
    @Environment(\.theme) private var theme

    let error: ErrorState

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(theme.errorColor)

            Text("Something went wrong")
                .font(theme.typography.heading3)

            Text(error.message)
                .font(theme.typography.body2)
                .foregroundColor(theme.textSecondary)
                .multilineTextAlignment(.center)

            if let retry = error.retry {
                Button(action: retry) {
                    Text("Try Again")
                        .font(theme.typography.body1)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(theme.primaryColor)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}