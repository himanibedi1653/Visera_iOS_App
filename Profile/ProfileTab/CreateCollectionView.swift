import SwiftUI

struct CreateCollectionView2: View {
    @ObservedObject var userDataModel: UserDataModel
    @Binding var showCreateCollection: Bool
    let initialPostID: Int?
    
    @State private var collectionTitle = ""
    @State private var isPrivate = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Create New Collection")
                    .font(.headline)
                    .padding(.top)
                
                TextField("Collection Name", text: $collectionTitle)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                Toggle("Private Collection", isOn: $isPrivate)
                    .padding(.vertical)
                
                HStack {
                    Button("Cancel") {
                        showCreateCollection = false
                    }
                    .padding()
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Button("Create") {
                        createCollection()
                    }
                    .padding()
                    .foregroundColor(Color(hex: "B69D53"))
                    .disabled(collectionTitle.isEmpty)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    private func createCollection() {
        let collectionType: CollectionType = isPrivate ? .private : .public
        let initialPosts: [Int] = initialPostID != nil ? [initialPostID!] : []
        
        userDataModel.createCollection(
            title: collectionTitle,
            type: collectionType,
            initialPostIDs: initialPosts
        )
        
        // If creating with a post and that post isn't saved yet, save it
        if let postID = initialPostID,
           let post = userDataModel.getPostByID(postID: postID),
           !post.isSaved {
            userDataModel.toggleSaved(postID: postID)
        }
        
        showCreateCollection = false
    }
}


struct CreateCollectionView: View {
    @ObservedObject var userDataModel: UserDataModel
    @Binding var showCreateCollection: Bool
    
    @State private var collectionTitle: String = ""
    @State private var collectionType: CollectionType = .public
    @State private var selectedPostIDs: Set<Int> = []
    
    var availablePosts: [Post] {
        return userDataModel.getAllPosts(forUser: userDataModel.currentUser)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Collection Details")) {
                    TextField("Collection Name", text: $collectionTitle)
                    
                    Picker("Collection Type", selection: $collectionType) {
                        Text("Public").tag(CollectionType.public)
                        Text("Private").tag(CollectionType.private)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Select Photos")) {
                    if availablePosts.isEmpty {
                        Text("No posts available to add")
                            .foregroundColor(.gray)
                            .italic()
                    } else {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(availablePosts) { post in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: post.postImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .onTapGesture {
                                            if selectedPostIDs.contains(post.id) {
                                                selectedPostIDs.remove(post.id)
                                            } else {
                                                selectedPostIDs.insert(post.id)
                                            }
                                        }
                                    
                                    if selectedPostIDs.contains(post.id) {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.blue)
                                            .background(Circle().fill(Color.white))
                                            .padding(4)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
            }
            .navigationTitle("New Collection")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showCreateCollection = false
                },
                trailing: Button("Create") {
                    createNewCollection()
                    showCreateCollection = false
                }
                .disabled(collectionTitle.isEmpty || selectedPostIDs.isEmpty)
            )
        }
    }
    
    private func createNewCollection() {
        // Generate a unique ID for the new collection
        let existingCollections = userDataModel.getAllCollections(forUser: userDataModel.currentUser)
        let newID = (existingCollections.map { $0.id }.max() ?? 0) + 1
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: Date())
        
        // Create the new collection
        let newCollection = Collection(
            id: newID,
            title: collectionTitle,
            type: collectionType,
            postIDs: Array(selectedPostIDs),
            createdAt: dateString
        )
        
        // Add a function to UserDataModel to add the new collection
        userDataModel.addCollection(newCollection, forUser: userDataModel.currentUser.userID)
    }
}

