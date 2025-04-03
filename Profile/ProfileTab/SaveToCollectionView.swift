//
//  SaveToCollectionView.swift
//  Profile
//
//  Created by Himani Bedi on 02/04/25.
//

import SwiftUI

struct SaveToCollectionView: View {
    let post: Post
    @ObservedObject var userDataModel: UserDataModel
    @Binding var showCollectionsSheet: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var showCreateCollection = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Header
                Text("Save to Collection")
                    .font(.headline)
                    .padding()
                
                // Collections List
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        // Add Button for creating a new collection
                        Button(action: {
                            showCreateCollection = true
                        }) {
                            HStack(spacing: 20) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.1))
                                        .frame(width: 80, height: 80)
                                        .cornerRadius(10)
                                    
                                    VStack {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(Color(hex: "B69D53"))
                                        
                                        Text("Create")
                                            .font(.caption)
                                            .foregroundColor(Color(hex: "B69D53"))
                                    }
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Create Collection")
                                        .font(.headline)
                                        .foregroundColor(Color(hex: "B69D53"))
                                    Text("Create a new collection")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                        
                        // Existing Collections
                        let collections = userDataModel.getAllCollections(forUser: userDataModel.currentUser)
                        
                        if collections.isEmpty {
                            Text("No collections yet")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(collections, id: \.id) { collection in
                                CollectionRow(
                                    collection: collection,
                                    posts: userDataModel.getAllPosts(forUser: userDataModel.currentUser),
                                    containsPost: collection.postIDs.contains(post.id),
                                    action: {
                                        handleCollectionSelection(collection)
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Cancel Button
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showCreateCollection) {
                CreateCollectionView2(
                    userDataModel: userDataModel,
                    showCreateCollection: $showCreateCollection,
                    initialPostID: post.id
                )
            }
        }
    }
    
    private func handleCollectionSelection(_ collection: Collection) {
        // Use the more efficient toggle method
        userDataModel.togglePostInCollection(collectionID: collection.id, postID: post.id)
        
        // If not already saved, mark post as saved
        if !post.isSaved {
            userDataModel.toggleSaved(postID: post.id)
        }
        
        // Dismiss the sheet
        presentationMode.wrappedValue.dismiss()
    }
}

struct CollectionRow: View {
    let collection: Collection
    let posts: [Post]
    let containsPost: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 20) {
                // Collection thumbnail
                if let firstPostID = collection.postIDs.first,
                   let firstPost = posts.first(where: { $0.id == firstPostID }) {
                    Image(uiImage: firstPost.postImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                        .clipped()
                } else {
                    Image(systemName: "folder.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(hex: "B69D53"))
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(collection.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Circle()
                            .fill(collection.type == .private ? Color.red : Color.green)
                            .frame(width: 8, height: 8)
                        
                        Text(collection.type == .private ? "Private" : "Public")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Number of photos
                    Text("\(collection.postIDs.count) photos")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Check mark if post is already in collection
                if containsPost {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(hex: "B69D53"))
                        .padding(.trailing, 8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
