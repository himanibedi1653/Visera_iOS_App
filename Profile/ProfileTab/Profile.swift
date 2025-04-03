import SwiftUI
import UniformTypeIdentifiers

struct ProfileView: View {
    @State private var selectedTab = "Posts"
    @StateObject private var userDataModel = UserDataModel.shared
    @State private var showCreatePost = false
    @State private var showPortfolioOptions = false
    @State private var showURLInput = false
    @State private var portfolioURLInput: String = ""
    @State private var showInvalidURLAlert = false
    @State private var showCreateCollection = false
    
    let tabs = ["Posts", "Collections"]
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack {
                        VStack {
                            if let profileImage = userDataModel.getUserImage(forUser: userDataModel.currentUser) {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 170, height: 170)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color("B69D53"), lineWidth: 2)
                                    )
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 150, height: 150)
                                    .clipShape(Circle())
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                            
                            Text(userDataModel.getUserName(forUser: userDataModel.currentUser))
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(userDataModel.getUserSkills(forUser: userDataModel.currentUser).joined(separator: " | "))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            HStack(spacing: 40) {
                                NavigationLink(destination: FollowersFollowingView(user: userDataModel.currentUser, initialTab: "Followers")) {
                                    VStack {
                                        Text("\(userDataModel.getNumberOfFollowers(forUser: userDataModel.currentUser))")
                                            .font(.title3)
                                            .foregroundColor(.black)
                                            .bold()
                                        Text("Followers")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                NavigationLink(destination: FollowersFollowingView(user: userDataModel.currentUser, initialTab: "Following")) {
                                    VStack {
                                        Text("\(userDataModel.getNumberOfFollowing(forUser: userDataModel.currentUser))")
                                            .font(.title3)
                                            .foregroundColor(.black)
                                            .bold()
                                        Text("Following")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                VStack {
                                    Text("\(userDataModel.getNumberOfPosts(forUser: userDataModel.currentUser))")
                                        .font(.title3)
                                        .bold()
                                    Text("Posts")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.top, 5)
                            
                            
                            // Portfolio Button - Modified to properly update and force refresh
                            Button(action: {
                                // Force refresh of portfolio before showing options
                                let hasPortfolio = userDataModel.getPortfolio(forUser: userDataModel.currentUser) != nil
                                if hasPortfolio {
                                    showPortfolioOptions = true
                                } else {
                                    showURLInput = true
                                    portfolioURLInput = "" // Clear previous input
                                }
                            }) {
                                Text(userDataModel.getPortfolio(forUser: userDataModel.currentUser) != nil ? "View Portfolio" : "Add Portfolio")
                                    .font(.headline)
                                    .foregroundColor(Color(hex: "B69D53"))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color(hex: "B69D53"), lineWidth: 2)
                                    )
                                    .padding(.horizontal)
                            }
                            .id(userDataModel.getPortfolio(forUser: userDataModel.currentUser)?.absoluteString ?? "no-portfolio") // Force refresh when portfolio changes
                            .actionSheet(isPresented: $showPortfolioOptions) {
                                ActionSheet(
                                    title: Text("Portfolio Options"),
                                    buttons: [
                                        .default(Text("View Portfolio")) {
                                            if let portfolioURL = userDataModel.getPortfolio(forUser: userDataModel.currentUser) {
                                                UIApplication.shared.open(portfolioURL)
                                            }
                                        },
                                        .destructive(Text("Delete Portfolio")) {
                                            userDataModel.updatePortfolio(forUserID: userDataModel.currentUser.userID, portfolio: nil)
                                        },
                                        .default(Text("Update Portfolio URL")) {
                                            portfolioURLInput = userDataModel.getPortfolio(forUser: userDataModel.currentUser)?.absoluteString ?? ""
                                            showURLInput = true
                                        },
                                        .cancel()
                                    ]
                                )
                            }
                            .alert(isPresented: $showInvalidURLAlert) {
                                Alert(
                                    title: Text("Invalid URL"),
                                    message: Text("Please enter a valid URL."),
                                    dismissButton: .default(Text("OK"))
                                )
                            }
                            .sheet(isPresented: $showURLInput) {
                                VStack {
                                    Text("Enter Portfolio URL")
                                        .font(.title2)
                                        .padding()
                                    
                                    TextField("https://example.com", text: $portfolioURLInput)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .autocapitalization(.none)
                                        .keyboardType(.URL)
                                        .padding()
                                    
                                    Button(action: {
                                        // Ensure URL starts with http:// or https://
                                        var urlString = portfolioURLInput.trimmingCharacters(in: .whitespacesAndNewlines)
                                        if !urlString.isEmpty && !urlString.lowercased().hasPrefix("http") {
                                            urlString = "https://" + urlString
                                        }
                                        
                                        if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                                            userDataModel.updatePortfolio(forUserID: userDataModel.currentUser.userID, portfolio: url)
                                            showURLInput = false
                                        } else {
                                            showInvalidURLAlert = true
                                        }
                                    }) {
                                        Text("Save")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                                    .padding()
                                    
                                    Button(action: {
                                        showURLInput = false
                                    }) {
                                        Text("Cancel")
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                            .padding()
                                    }
                                }
                                .padding()
                            }
                        }
                        .padding()
                        
                        // Segmented Control
                        Picker("", selection: $selectedTab) {
                            ForEach(tabs, id: \.self) { tab in
                                Text(tab).tag(tab)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                        
                        // Posts Grid View or Collections List View
                        if selectedTab == "Posts" {
                            PostsGridView(posts: userDataModel.getAllPosts(forUser: userDataModel.currentUser), showCreatePost: $showCreatePost)
                        } else {
                            CollectionsListView(
                                collections: userDataModel.getAllCollections(forUser: userDataModel.currentUser),
                                posts: userDataModel.getAllPosts(forUser: userDataModel.currentUser),
                                showCreateCollection: $showCreateCollection)
                        }
                    }
                }
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(
                    trailing: NavigationLink(destination: About(userDataModel: userDataModel)) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(Color(hex: "B69D53"))
                    }
                )
                .sheet(isPresented: $showCreatePost) {
                    CreatePostView(userDataModel: userDataModel, showCreatePost: $showCreatePost)
                }
                .sheet(isPresented: $showCreateCollection) {
                    CreateCollectionView(userDataModel: userDataModel, showCreateCollection: $showCreateCollection)
                }
            }
        }
    }
}
    
// Posts Grid View with Add Button as first cell
struct PostsGridView: View {
    let posts: [Post]
    @Binding var showCreatePost: Bool
    let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                // Add Button as the first cell
                Button(action: {
                    showCreatePost = true
                }) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color(hex: "B69D53"))
                        
                        Text("Add Post")
                            .font(.caption)
                            .foregroundColor(Color(hex: "B69D53"))
                    }
                    .frame(width: 120, height: 160)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                
                // Regular post cells
                ForEach(posts, id: \.id) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        Image(uiImage: post.postImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 160)
                            .clipped()
                    }
                }
            }
            .padding(5)
        }
    }
}
    
// Collections List View with Add Button as first item
struct CollectionsListView: View {
    let collections: [Collection]
    let posts: [Post]
    @Binding var showCreateCollection: Bool
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            // Add Button as first collection item
            Button(action: {
                showCreateCollection = true
            }) {
                HStack(spacing: 20) {
                    ZStack {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                        
                        VStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(hex: "B69D53"))
                            
                            Text("Add Collection")
                                .font(.caption)
                                .foregroundColor(Color(hex: "B69D53"))
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Create Collection")
                            .font(.title2)
                            .foregroundColor(Color(hex: "B69D53"))
                            .bold()
                        Text("Private/Public")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 100.0)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            }
            
            // Regular collection items
            ForEach(collections, id: \.id) { collection in
                NavigationLink(destination: CollectionDetailView(collection: collection, posts: posts)) {
                    HStack(spacing: 20) {
                        // Fetch the first post's image for the collection
                        if let firstPostID = collection.postIDs.first,
                           let firstPost = posts.first(where: { $0.id == firstPostID }) {
                            Image(uiImage: firstPost.postImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .clipped()
                        } else {
                            // Fallback image if no post is found
                            Image(systemName: "folder.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                                .clipped()
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                                Text(collection.title)
                                    .font(.title2)
                                    .foregroundColor(Color(hex: "B69D53"))
                                    .bold()
                            
                            
                            HStack(spacing: 4) {
                                Circle()
                                    .fill(collection.type == .private ? Color.red : Color.green)
                                    .frame(width: 8, height: 5)
                                
                                Text(collection.type == .private ? "Private" : "Public")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            // Number of photos
                            HStack(spacing: 4) {
                                Image(systemName: "photo.stack")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(collection.postIDs.count) photos")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            // Last updated date
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("Updated \(getLastUpdatedDate(for: collection))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 100.0)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
            }
        }
        .padding(.horizontal)
    }
    
    // Function to get the last updated date for a collection
    private func getLastUpdatedDate(for collection: Collection) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let collectionPosts = posts.filter { collection.postIDs.contains($0.id) }
        let sortedDates = collectionPosts.compactMap { post -> Date? in
            dateFormatter.date(from: post.createdAt)
        }.sorted(by: >)
        
        if let mostRecentDate = sortedDates.first {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: mostRecentDate)
        }
        
        return "N/A"
    }
}


extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (no alpha)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
    
struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.data], asCopy: true)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            if let url = urls.first {
                parent.onPick(url)
            }
        }
    }
}
    
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

// https://www.demilanigan.com
