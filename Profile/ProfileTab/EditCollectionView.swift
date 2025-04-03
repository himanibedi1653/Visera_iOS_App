//
//  EditCollectionView.swift
//  Profile
//
//  Created by Himani Bedi on 25/03/25.
//

import SwiftUI

// Edit Collection View
struct EditCollectionView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var userDataModel = UserDataModel.shared
    
    let collection: Collection
    let posts: [Post]
    
    @State private var collectionTitle: String
    @State private var collectionType: CollectionType
    @State private var selectedPosts: Set<Int>
    @State private var showPostSelection = false
    
    init(collection: Collection, posts: [Post]) {
        self.collection = collection
        self.posts = posts
        _collectionTitle = State(initialValue: collection.title)
        _collectionType = State(initialValue: collection.type)
        _selectedPosts = State(initialValue: Set(collection.postIDs))
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Collection Title Section
                Section(header: Text("Collection Details")) {
                    TextField("Collection Name", text: $collectionTitle)
                    
                    Picker("Collection Type", selection: $collectionType) {
                        Text("Private").tag(CollectionType.private)
                        Text("Public").tag(CollectionType.public)
                    }
                }
                
                // Posts Section
                Section(header: Text("Posts in Collection")) {
                    Button(action: { showPostSelection = true }) {
                        HStack {
                            Text("Manage Posts")
                            Spacer()
                            Text("\(selectedPosts.count) Posts")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Delete Collection Section
                Section {
                    Button(action: deleteCollection) {
                        Text("Delete Collection")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Edit Collection")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    saveChanges()
                }
            )
            .sheet(isPresented: $showPostSelection) {
                PostSelectionView(
                    allPosts: posts,
                    selectedPosts: $selectedPosts
                )
            }
        }
    }
    
    private func saveChanges() {
        // Validate title
        guard !collectionTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // Show an alert that title cannot be empty
            return
        }
        
        // Determine posts to add and remove
        let currentPostIDs = Set(collection.postIDs)
        let postsToAdd = selectedPosts.subtracting(currentPostIDs)
        let postsToRemove = currentPostIDs.subtracting(selectedPosts)
        
        // Update the collection
        userDataModel.updateCollection(
            collectionID: collection.id,
            userID: userDataModel.currentUser.userID,
            newTitle: collectionTitle,
            newType: collectionType,
            addPostIDs: Array(postsToAdd),
            removePostIDs: Array(postsToRemove)
        )
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func deleteCollection() {
        userDataModel.deleteCollection(
            collectionID: collection.id,
            userID: userDataModel.currentUser.userID
        )
        presentationMode.wrappedValue.dismiss()
    }
}

// Post Selection View for Managing Collection Posts

struct PostSelectionView: View {
    let allPosts: [Post]
    @Binding var selectedPosts: Set<Int>
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                if allPosts.isEmpty {
                    Text("No posts available")
                        .foregroundColor(.gray)
                        .italic()
                } else {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                        ForEach(allPosts) { post in
                            ZStack(alignment: .topTrailing) {
                                Image(uiImage: post.postImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .onTapGesture {
                                        if selectedPosts.contains(post.id) {
                                            selectedPosts.remove(post.id)
                                        } else {
                                            selectedPosts.insert(post.id)
                                        }
                                    }
                                
                                if selectedPosts.contains(post.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                        .background(Circle().fill(Color.white))
                                        .padding(4)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Select Posts")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

// Helper View for Multiple Selection
struct MultipleSelectionRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            action()
        }
    }
}

// Modify CollectionDetailView to include Edit Button
extension CollectionDetailView {
    private func editCollection() {
        // Present Edit Collection View
    }
}
