//
//  Models.swift
//  My_iOS_Library
//
//  Sample models for MVVM demo
//

import Foundation

// MARK: - User Model

public struct User: Identifiable, Codable, Equatable {
    public let id: String
    public let name: String
    public let email: String
    public let avatarURL: String?
    public let isVerified: Bool
    public let joinDate: Date
    public let bio: String?
    public let followersCount: Int
    public let followingCount: Int

    public init(
        id: String = UUID().uuidString,
        name: String,
        email: String,
        avatarURL: String? = nil,
        isVerified: Bool = false,
        joinDate: Date = Date(),
        bio: String? = nil,
        followersCount: Int = 0,
        followingCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.avatarURL = avatarURL
        self.isVerified = isVerified
        self.joinDate = joinDate
        self.bio = bio
        self.followersCount = followersCount
        self.followingCount = followingCount
    }
}

// MARK: - Post Model

public struct Post: Identifiable, Codable, Equatable {
    public let id: String
    public let userId: String
    public let title: String
    public let content: String
    public let imageURL: String?
    public let createdAt: Date
    public let updatedAt: Date
    public let likes: Int
    public let comments: Int
    public let isLiked: Bool

    public init(
        id: String = UUID().uuidString,
        userId: String,
        title: String,
        content: String,
        imageURL: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        likes: Int = 0,
        comments: Int = 0,
        isLiked: Bool = false
    ) {
        self.id = id
        self.userId = userId
        self.title = title
        self.content = content
        self.imageURL = imageURL
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.likes = likes
        self.comments = comments
        self.isLiked = isLiked
    }
}

// MARK: - Comment Model

public struct Comment: Identifiable, Codable, Equatable {
    public let id: String
    public let postId: String
    public let userId: String
    public let userName: String
    public let content: String
    public let createdAt: Date

    public init(
        id: String = UUID().uuidString,
        postId: String,
        userId: String,
        userName: String,
        content: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.postId = postId
        self.userId = userId
        self.userName = userName
        self.content = content
        self.createdAt = createdAt
    }
}