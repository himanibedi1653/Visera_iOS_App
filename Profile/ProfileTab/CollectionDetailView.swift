//
//  CollectionDetailView.swift
//  Profile
//
//  Created by Himani Bedi on 22/03/25.
//

import SwiftUI

struct PostCardView: View {
    let post: Post
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Post Image with Shadow and Rounded Corners
            Image(uiImage: post.postImage)
                .resizable()
                .scaledToFill()
                .frame(width: 180, height: 200)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            
            // Gradient Overlay for Text
            LinearGradient(
                gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(15)
            
            // Post Description (if available)
            if let description = post.description {
                Text(description)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding(8)
            }
        }
        .frame(width: 180, height: 200)
    }
}

struct CollectionDetailView: View {
    let collection: Collection
    let posts: [Post]
    @StateObject private var userDataModel = UserDataModel.shared
    @State private var showEditCollection = false
    
    // Compute the collection posts
    private var collectionPosts: [Post] {
        posts.filter { collection.postIDs.contains($0.id) }
    }
    
    // Calculate the last updated date (most recent post creation date)
    private var lastUpdatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let sortedPosts = collectionPosts.compactMap { post -> Date? in
            dateFormatter.date(from: post.createdAt)
        }.sorted(by: >)
        
        if let mostRecentDate = sortedPosts.first {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: mostRecentDate)
        }
        
        return "N/A"
    }
    
    var body: some View {
        ZStack {
            // Gradient Background for a Premium Look
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "F5F5F5"), Color(hex: "E0E0E0")]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Collection Title with Custom Font
                    Text(collection.title)
                        .font(.custom("Helvetica Neue", size: 28, relativeTo: .title))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "333333"))
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    // Collection metadata: photo count and last updated date
                    HStack {
                        // Photo count
                        HStack(spacing: 4) {
                            Image(systemName: "photo.stack")
                                .foregroundColor(Color(hex: "666666"))
                            Text("\(collectionPosts.count) photos")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "666666"))
                        }
                        
                        Spacer()
                        
                        // Last updated date
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .foregroundColor(Color(hex: "666666"))
                            Text("Updated \(lastUpdatedDate)")
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "666666"))
                        }
                    }
                    .padding(.horizontal)
                    
                    // Grid Layout for Posts
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16), GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16) {
                        ForEach(collectionPosts, id: \.id) { post in
                            NavigationLink(destination: PostDetailView(post: post)) {
                                PostCardView(post: post)
                                    .scaleEffect(1)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: 1)
                            }
                            .buttonStyle(PlainButtonStyle()) // Remove default button styling
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 20)
            }
        }
        .navigationTitle(collection.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Share Button
                Button(action: {
                    shareCollection()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color(hex: "333333"))
                }
                
                // Edit Button (only show for the current user's collections)
                if userDataModel.currentUser.profileData.collections.contains(where: { $0.id == collection.id }) {
                    Button(action: {
                        showEditCollection = true
                    }) {
                        Image(systemName: "pencil")
                            .foregroundColor(Color(hex: "333333"))
                    }
                }
            }
        }
        .sheet(isPresented: $showEditCollection) {
            EditCollectionView(collection: collection, posts: posts)
        }
    }
    
    // Function to share the collection
    private func shareCollection() {
        // Create a string with the collection title and a link (or any other content you want to share)
        let shareText = "Check out this collection: \(collection.title)\n\n[Link to Collection]"
        
        // Convert the string to an activity item
        let activityViewController = UIActivityViewController(
            activityItems: [shareText],
            applicationActivities: nil
        )
        
        // Present the share sheet
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

#Preview {
    // Mock Collection
    let mockCollection = Collection(
        id: 1,
        title: "Beach Vibes",
        type: .private,
        postIDs: [101, 102, 103],
        createdAt: "2025-01-04"
    )
    
    // Mock Posts
    let mockPosts = [
        Post(
            id: 101,
            userID: 1,
            tags: ["fashion", "lifestyle"],
            postImage: UIImage(named: "post1")!,
            description: "I got to work with one of the best fashion designers in the world!",
            createdAt: "2025-01-01",
            crownCount: 15,
            comments: [
                Comment(userID: 2, content: "Amazing outfit!", timestamp: "2025-01-02"),
                Comment(userID: 3, content: "You look stunning!", timestamp: "2025-01-02")
            ],
            isSaved: true,
            isFollowed: false,
            collectionIDs: [1],
            isCrowned: true
        ),
        Post(
            id: 102,
            userID: 1,
            tags: ["fashion", "lifestyle"],
            postImage: UIImage(named: "post2")!,
            description: "Elegance is an attitude. ✨ #EditorialMagic",
            createdAt: "2025-01-01",
            crownCount: 13,
            comments: [
                Comment(userID: 2, content: "This look is everything! 💖", timestamp: "2025-01-02"),
                Comment(userID: 4, content: "Killing it as always!", timestamp: "2025-01-03")
            ],
            isSaved: false,
            isFollowed: false,
            collectionIDs: [1],
            isCrowned: true
        ),
        Post(
            id: 103,
            userID: 1,
            tags: ["Modeling", "lifestyle"],
            postImage: UIImage(named: "post3")!,
            description: "Chasing dreams, one photoshoot at a time. 📸✨",
            createdAt: "2025-01-01",
            crownCount: 12,
            comments: [
                Comment(userID: 5, content: "The confidence in this shot is unmatched! 😍", timestamp: "2025-01-02"),
                Comment(userID: 6, content: "Serving elegance and grace. ✨!", timestamp: "2025-01-03")
            ],
            isSaved: true,
            isFollowed: false,
            collectionIDs: [1],
            isCrowned: true
        )
    ]
    
    // Return the CollectionDetailView with mock data
    return CollectionDetailView(collection: mockCollection, posts: mockPosts)
}
