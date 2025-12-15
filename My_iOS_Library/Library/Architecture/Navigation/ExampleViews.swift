//
//  ExampleViews.swift
//  My_iOS_Library
//
//  Example views demonstrating the navigation system
//

import SwiftUI

// MARK: - Home View

struct HomeView: View {
    @Environment(NavigationRouter.self) private var router
    @Environment(\.theme) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Navigation Examples Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Navigation Examples")
                        .font(.headline)

                    // Push Navigation
                    Button(action: {
                        router.navigate(to: .profile(userId: "123"))
                    }) {
                        NavigationRow(
                            icon: "person.fill",
                            title: "Go to Profile",
                            subtitle: "Push navigation"
                        )
                    }

                    Button(action: {
                        router.navigate(to: .detail(itemId: "abc"))
                    }) {
                        NavigationRow(
                            icon: "doc.fill",
                            title: "View Detail",
                            subtitle: "Push to detail view"
                        )
                    }

                    Button(action: {
                        router.navigate(to: .settings)
                    }) {
                        NavigationRow(
                            icon: "gearshape.fill",
                            title: "Settings",
                            subtitle: "Push to settings"
                        )
                    }
                }

                Divider()

                // Sheet Examples Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Sheet Examples")
                        .font(.headline)

                    Button(action: {
                        router.presentSheet(.addItem)
                    }) {
                        NavigationRow(
                            icon: "plus.circle.fill",
                            title: "Add Item",
                            subtitle: "Present as sheet",
                            color: theme.primaryColor
                        )
                    }

                    Button(action: {
                        router.presentSheet(.filter(FilterOptions()))
                    }) {
                        NavigationRow(
                            icon: "line.3.horizontal.decrease.circle.fill",
                            title: "Filter",
                            subtitle: "Show filter sheet",
                            color: theme.secondaryColor
                        )
                    }
                }

                Divider()

                // Full Screen Examples
                VStack(alignment: .leading, spacing: 16) {
                    Text("Full Screen Examples")
                        .font(.headline)

                    Button(action: {
                        router.presentFullScreen(.premium)
                    }) {
                        NavigationRow(
                            icon: "star.fill",
                            title: "Go Premium",
                            subtitle: "Full screen cover",
                            color: theme.warningColor
                        )
                    }

                    Button(action: {
                        router.presentFullScreen(.videoPlayer(url: "https://example.com/video"))
                    }) {
                        NavigationRow(
                            icon: "play.rectangle.fill",
                            title: "Play Video",
                            subtitle: "Full screen player",
                            color: theme.errorColor
                        )
                    }
                }

                Divider()

                // Alert Examples
                VStack(alignment: .leading, spacing: 16) {
                    Text("Alert & Dialog Examples")
                        .font(.headline)

                    Button(action: {
                        router.showAlert(
                            title: "Success!",
                            message: "Your action was completed successfully.",
                            primaryButton: .ok
                        )
                    }) {
                        NavigationRow(
                            icon: "checkmark.circle.fill",
                            title: "Show Alert",
                            subtitle: "Simple alert",
                            color: theme.successColor
                        )
                    }

                    Button(action: {
                        router.showAlert(
                            title: "Delete Item?",
                            message: "This action cannot be undone.",
                            primaryButton: .delete {
                                print("Item deleted")
                            },
                            secondaryButton: .cancel
                        )
                    }) {
                        NavigationRow(
                            icon: "trash.fill",
                            title: "Delete Confirmation",
                            subtitle: "Alert with actions",
                            color: theme.errorColor
                        )
                    }

                    Button(action: {
                        router.showConfirmationDialog(
                            ConfirmationDialogConfig(
                                title: "Choose Action",
                                message: "What would you like to do?",
                                buttons: [
                                    DialogButton(title: "Share", action: {
                                        router.presentSheet(.share(content: ShareContent(title: "Check this out!")))
                                    }),
                                    DialogButton(title: "Edit", action: {
                                        router.presentSheet(.editProfile(userId: "123"))
                                    }),
                                    DialogButton(title: "Delete", role: .destructive, action: {
                                        print("Delete action")
                                    }),
                                    DialogButton(title: "Cancel", role: .cancel, action: {})
                                ]
                            )
                        )
                    }) {
                        NavigationRow(
                            icon: "ellipsis.circle.fill",
                            title: "Action Sheet",
                            subtitle: "Multiple options",
                            color: theme.infoColor
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Navigation Demo")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    router.switchToTab(.profile)
                }) {
                    Image(systemName: "person.circle")
                }
            }
        }
    }
}

// MARK: - Profile View

struct ProfileView: View {
    @Environment(NavigationRouter.self) private var router
    let userId: String

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                Circle()
                    .fill(LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Text("JD")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    )

                Text("John Doe")
                    .font(.title2)
                    .bold()

                Text("User ID: \(userId)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                // Actions
                VStack(spacing: 12) {
                    Button(action: {
                        router.presentSheet(.editProfile(userId: userId))
                    }) {
                        Label("Edit Profile", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        router.navigate(to: .list(category: "posts"))
                    }) {
                        Label("View Posts", systemImage: "doc.richtext")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.secondary.opacity(0.2))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Detail View

struct DetailView: View {
    let itemId: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Item Details")
                    .font(.title2)
                    .bold()

                Text("ID: \(itemId)")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("This is a detail view demonstrating navigation to a specific item. You can add any content here based on the item ID.")
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        List {
            Section("Account") {
                Button(action: {
                    router.navigate(to: .profile(userId: "current"))
                }) {
                    Label("Profile", systemImage: "person.circle")
                }

                Button(action: {
                    router.showAlert(
                        title: "Sign Out?",
                        message: "Are you sure you want to sign out?",
                        primaryButton: AlertButton(title: "Sign Out", role: .destructive) {
                            router.reset()
                        },
                        secondaryButton: .cancel
                    )
                }) {
                    Label("Sign Out", systemImage: "arrow.right.square")
                        .foregroundColor(.red)
                }
            }

            Section("Preferences") {
                Toggle("Notifications", isOn: .constant(true))
                Toggle("Dark Mode", isOn: .constant(false))
            }
        }
        .navigationTitle("Settings")
    }
}

// MARK: - List View

struct ListView: View {
    let category: String

    var body: some View {
        List(0..<20) { index in
            NavigationLink(value: Route.detail(itemId: "\(category)-\(index)")) {
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 60, height: 60)

                    VStack(alignment: .leading) {
                        Text("Item \(index + 1)")
                            .font(.headline)
                        Text("Category: \(category)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle(category.capitalized)
    }
}

// MARK: - Sheet Views

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Item")
                .font(.title2)
                .bold()

            TextField("Item Name", text: .constant(""))
                .textFieldStyle(.roundedBorder)

            TextEditor(text: .constant(""))
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )

            Button(action: {
                dismiss()
            }) {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Add Item")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileView: View {
    let userId: String

    var body: some View {
        Text("Edit Profile for User: \(userId)")
            .navigationTitle("Edit Profile")
    }
}

struct FilterView: View {
    let options: FilterOptions

    var body: some View {
        Text("Filter Options")
            .navigationTitle("Filter")
    }
}

struct ShareView: View {
    let content: ShareContent

    var body: some View {
        Text("Share: \(content.title)")
            .navigationTitle("Share")
    }
}

struct ImagePickerView: View {
    var body: some View {
        Text("Image Picker Placeholder")
            .navigationTitle("Choose Image")
    }
}

// MARK: - Full Screen Views

struct OnboardingView: View {
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        VStack(spacing: 40) {
            Text("Welcome!")
                .font(.largeTitle)
                .bold()

            Text("This is an onboarding flow")

            Button(action: {
                router.dismissFullScreen()
            }) {
                Text("Get Started")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

struct LoginView: View {
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: .constant(""))
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: .constant(""))
                .textFieldStyle(.roundedBorder)

            Button(action: {
                router.dismissFullScreen()
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct PremiumView: View {
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "star.fill")
                .font(.system(size: 60))
                .foregroundColor(.yellow)

            Text("Go Premium")
                .font(.largeTitle)
                .bold()

            Text("Unlock all features")
                .font(.title3)
                .foregroundStyle(.secondary)

            Button(action: {
                router.dismissFullScreen()
            }) {
                Text("Subscribe")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .bold()
            }
            .padding(.horizontal)

            Button(action: {
                router.dismissFullScreen()
            }) {
                Text("Maybe Later")
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct VideoPlayerView: View {
    let url: String

    var body: some View {
        Text("Video Player: \(url)")
    }
}

// MARK: - Tab Views

struct ExploreView: View {
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        List {
            ForEach(["Technology", "Design", "Business", "Health"], id: \.self) { category in
                Button(action: {
                    router.navigate(to: .list(category: category.lowercased()))
                }) {
                    Label(category, systemImage: "folder")
                }
            }
        }
        .navigationTitle("Explore")
    }
}

struct FavoritesView: View {
    var body: some View {
        Text("Favorites")
            .navigationTitle("Favorites")
    }
}

struct ProfileTabView: View {
    @Environment(NavigationRouter.self) private var router

    var body: some View {
        ProfileView(userId: "current")
    }
}

// MARK: - Helper Views

struct NavigationRow: View {
    let icon: String
    let title: String
    let subtitle: String
    var color: Color = .blue

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
    }
}