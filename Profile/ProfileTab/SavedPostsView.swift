//
//  SavedPostsView.swift
//  Profile
//
//  Created by Himani Bedi on 21/03/25.
//

import SwiftUI

struct SavedPostsView: View {
    @ObservedObject var userDataModel: UserDataModel
    var user: User
    @State private var gridLayout = [GridItem(.adaptive(minimum: 150))]
    
    var savedPosts: [Post] {
        // Re-fetch saved posts each time to ensure we have the latest data
        userDataModel.getSavedPosts(forUser: user)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                // Center content both horizontally and vertically
                VStack {
                    Spacer(minLength: 0)
                    
                    HStack {
                        Spacer(minLength: 0)
                        
                        if savedPosts.isEmpty {
                            emptyStateView
                        } else {
                            savedPostsGrid
                        }
                        
                        Spacer(minLength: 0)
                    }
                    
                    Spacer(minLength: 0)
                }
                .frame(minHeight: geometry.size.height) // Ensure VStack takes full height
            }
            .navigationTitle("Saved Posts")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "pin.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
                .foregroundColor(Color(hex: "B69D53"))
            
            Text("No Saved Posts")
                .font(.headline)
            
            Text("Posts you save will appear here")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        // No need for additional spacers as the parent VStack handles vertical centering
    }
    
    private var savedPostsGrid: some View {
        // Add a VStack with a fixed width to center the grid
        VStack {
            LazyVGrid(columns: gridLayout, spacing: 10) {
                ForEach(savedPosts, id: \.id) { post in
                    NavigationLink(destination: PostDetailView(post: post, userDataModel: userDataModel)) {
                        SavedPostCard(post: post, userDataModel: userDataModel)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .id(post.id) // Add an id to force refresh when post changes
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 15)
        }
        // Use a frame with maxWidth to limit the width and center the content
        .frame(maxWidth: min(UIScreen.main.bounds.width, 600))
    }
}

struct SavedPostCard: View {
    let post: Post
    @ObservedObject var userDataModel: UserDataModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            ZStack(alignment: .topTrailing) {
                Image(uiImage: post.postImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .cornerRadius(12)
                    .clipped()
                
                // Pin icon with tap gesture to unsave
                Button(action: {
                    userDataModel.toggleSaved(postID: post.id)
                }) {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(hex: "B69D53"))
                        .padding(6)
                        .background(Color.white)
                        .clipShape(Circle())
                }
                .padding(8)
            }
            
            VStack(alignment: .leading, spacing: 3) {
                // Tags display
                if !post.tags.isEmpty {
                    Text("#\(post.tags.first ?? "")")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "B69D53"))
                        .lineLimit(1)
                }
                
                // Description
                if let description = post.description {
                    Text(description)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                }
                
                // Engagement stats
                HStack(spacing: 10) {
                    Label("\(post.crownCount)", systemImage: "crown.fill")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Label("\(post.comments.count)", systemImage: "message")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 3)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 1)
    }
}
