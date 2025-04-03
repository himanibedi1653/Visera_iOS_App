//
//  HomeFeed.swift
//  Visera
//
//  Created by student2 on 17/03/25.
//

import Foundation
import SwiftUI
import SwiftUI
import SwiftUI
import UniformTypeIdentifiers
struct HomeFeedView: View {
    let loggedInUserID: Int
    @ObservedObject var userDataModel = UserDataModel.shared  // ✅ Observing changes
    @State private var showBlockConfirmation = false
    var currentUser: User? {
        userDataModel.getUserByID(userID: loggedInUserID)
    }

    var feedPosts: [Post] {
        if let user = currentUser {
            return userDataModel.getFeedPosts(for: user, allUsers: userDataModel.getAllUsers())
        }
        return []
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 5) {
                Text("Home Feed")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                if let user = currentUser {
                    if feedPosts.isEmpty {
                        Text("No matching posts found")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(feedPosts, id: \.id) { post in
                            if let postOwner = userDataModel.getUserByID(userID: post.userID) {
                                HomePostCardView(user: postOwner, post: post, loggedInUserID: loggedInUserID)
                            }
                        }
                    }
                } else {
                    Text("User not found")
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
    }
}
struct HomePostCardView: View {
    var user: User
    @State var post: Post
    var loggedInUserID: Int

    @State private var isFollowing: Bool
    @State private var isPresentingPostDetail = false

    init(user: User, post: Post, loggedInUserID: Int) {
        self.user = user
        self._post = State(initialValue: post)
        self.loggedInUserID = loggedInUserID
        _isFollowing = State(initialValue: UserDataModel.shared.isFollowing(currentUserID: loggedInUserID, targetUserID: user.userID))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                if let profileImage = user.profileData.profileImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }

                NavigationLink(destination: HomeProfileView(user: user, currentUserID: loggedInUserID)) {
                    Text(user.basicInfo.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }

                Spacer()

                if user.userID != loggedInUserID {
                    Button(action: {
                        toggleFollow()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(hex: "B69D53"), lineWidth: 3)
                                .frame(width: 100, height: 40)

                            Text(isFollowing ? "Following" : "Follow")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(hex: "B69D53"))
                        }
                    }
                    .frame(width: 100, height: 40)
                    .contentShape(Rectangle())
                }
            }

            Button(action: {
                isPresentingPostDetail.toggle()
            }) {
                ZStack(alignment: .bottom) {
                    Image(uiImage: post.postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 372)
                        .clipped()
                        .cornerRadius(10)
                        .contentShape(Rectangle())

                    VStack {
                        Spacer()
                        Button(action: {
                            toggleCrown()
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: post.isCrowned ? "crown.fill" : "crown")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(post.isCrowned ? Color(hex: "B69D53") : .gray)
                            }
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                        }
                        .contentShape(Rectangle())
                        .offset(y: 15)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: 372)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            // Delete Button
            if user.userID == loggedInUserID {
                Button(action: {
                    deletePost()
                }) {
                    Text("Delete Post")
                        .foregroundColor(.red)
                        .font(.subheadline)
                }
                .padding(.top, 5)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .center)
        .sheet(isPresented: $isPresentingPostDetail) {
            HomePostDetailView(post: post)
        }
        .onAppear {
            // ✅ Update following status on view appear
            isFollowing = UserDataModel.shared.isFollowing(currentUserID: loggedInUserID, targetUserID: user.userID)

            // ✅ Fetch updated crown status when the view appears
            if let updatedPost = UserDataModel.shared.getPostByID(postID: post.id) {
                DispatchQueue.main.async {
                    self.post = updatedPost
                }
            }
        }
    }

    private func toggleFollow() {
        UserDataModel.shared.toggleFollow(currentUserID: loggedInUserID, targetUserID: user.userID)
        isFollowing.toggle()
        UserDataModel.shared.objectWillChange.send()
    }

    private func toggleCrown() {
        // ✅ Optimistically update the UI
        post.isCrowned.toggle()

        UserDataModel.shared.toggleCrown(postID: post.id, userID: loggedInUserID)

        // ✅ Fetch updated post from UserDataModel after the change
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let updatedPost = UserDataModel.shared.getPostByID(postID: post.id) {
                self.post = updatedPost
            }
        }
    }

    private func deletePost() {
        UserDataModel.shared.removePost(postID: post.id)
    }
}




import Foundation
import SwiftUI
import UniformTypeIdentifiers
struct HomeProfileView: View {
    var user: User
    var currentUserID: Int
    var navigationSource: NavigationSource
    
    enum NavigationSource {
        case search
        case other
        case normal
    }
    
    @State private var selectedTab = "Posts"
    @StateObject private var userDataModel = UserDataModel.shared
    @State private var isFollowing = false
    @State private var followersCount = 0
    @State private var isBlocked = false
    @Environment(\.presentationMode) var presentationMode

    let tabs = ["Posts", "Collections"]

    init(user: User, currentUserID: Int, navigationSource: NavigationSource = .normal) {
        self.user = user
        self.currentUserID = currentUserID
        self.navigationSource = navigationSource
    }
    @State private var showBlockConfirmation = false
    var body: some View {
        ScrollView {
            VStack {
                if let profileImage = userDataModel.getUserImage(forUser: user) {
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 170, height: 170)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color("B69D53"), lineWidth: 2))
                } else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                }
                
                Text(userDataModel.getUserName(forUser: user))
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(userDataModel.getUserSkills(forUser: user).joined(separator: " | "))
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 40) {
                    NavigationLink(destination: FollowersFollowingView(user: user, initialTab: "Followers")) {
                        VStack {
                            Text("\(followersCount)")
                                .font(.title3)
                                .foregroundColor(.black)
                                .bold()
                            Text("Followers")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: FollowersFollowingView(user: user, initialTab: "Following")) {
                        VStack {
                            Text("\(userDataModel.getNumberOfFollowing(forUser: user))")
                                .font(.title3)
                                .foregroundColor(.black)
                                .bold()
                            Text("Following")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    VStack {
                        Text("\(userDataModel.getNumberOfPosts(forUser: user))")
                            .font(.title3)
                            .bold()
                        Text("Posts")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 5)
                
                if let portfolioURL = userDataModel.getPortfolio(forUser: user) {
                    Button(action: {
                        UIApplication.shared.open(portfolioURL)
                    }) {
                        Text("View Portfolio")
                            .font(.headline)
                            .foregroundColor(Color(hex: "B69D53"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "B69D53"), lineWidth: 2))
                    }
                    .padding(.horizontal)
                }
                
                if user.userID != currentUserID {
                    HStack {
                        Button(action: {
                            toggleFollow()
                        }) {
                            Text(isFollowing ? "Following" : "Follow")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(isFollowing ? .white : Color(hex: "B69D53"))
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, minHeight: 36)
                                .background(isFollowing ? Color(hex: "B69D53") : Color.clear)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "B69D53"), lineWidth: 2))
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            // Do nothing for now
                        }) {
                            Text("Message")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .frame(maxWidth: .infinity, minHeight: 36)
                                .background(Color(hex: "B69D53"))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "B69D53"), lineWidth: 2))
                                .cornerRadius(8)
                                
                        }
                    }
                    .padding(.horizontal)
                }

            }
            .padding()
            .onAppear {
                isFollowing = userDataModel.isFollowing(currentUserID: currentUserID, targetUserID: user.userID)
                followersCount = userDataModel.getNumberOfFollowers(forUser: user)
                isBlocked = userDataModel.currentUser.userPreferences.blockedUserIDs.contains(user.userID)

                // ✅ Update crown status using the function
                userDataModel.updateCrownStatus(forUser: user)
            }

            
            Picker("", selection: $selectedTab) {
                ForEach(tabs, id: \ .self) { tab in
                    Text(tab).tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedTab == "Posts" {
                let posts = userDataModel.getAllPosts(forUser: user)
                if posts.isEmpty {
                    Text("Nothing to Show").font(.headline).foregroundColor(.gray).padding()
                } else {
                    HomePostsGridView(posts: posts)
                }
            } else {
                HomeCollectionsListView(
                    collections: userDataModel.getAllCollections(forUser: user),
                    posts: userDataModel.getAllPosts(forUser: user)
                )
            }
        }
        .navigationBarItems(trailing:
                                Group {
            if user.userID != currentUserID {
                Menu {
                    Button(action: {
                        showBlockConfirmation = true // ✅ Show confirmation before blocking
                    }) {
                        Label(isBlocked ? "Unblock User" : "Block User", systemImage: isBlocked ? "person.fill.checkmark" : "person.slash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color(hex: "B69D53"))
                        .font(.system(size: 18))
                }
            }

        }
        )
        .alert(isPresented: $showBlockConfirmation) {
            Alert(
                title: Text("Block \(user.basicInfo.name)?"),
                message: Text("Blocking this user will prevent them from seeing your posts and interacting with you. You can unblock them later in settings."),
                primaryButton: .destructive(Text("Block")) {
                    blockUser()
                },
                secondaryButton: .cancel(Text("Cancel"))
            )
        }

        .navigationBarBackButtonHidden(navigationSource == .search)
    }
    func toggleFollow() {
        userDataModel.toggleFollow(currentUserID: currentUserID, targetUserID: user.userID)
        withAnimation {
            isFollowing = userDataModel.isFollowing(currentUserID: currentUserID, targetUserID: user.userID)
            followersCount = userDataModel.getNumberOfFollowers(forUser: user)
        }
    }
    
func blockUser() {
        userDataModel.blockUser(currentUserID: currentUserID, userToBlockID: user.userID)
        isBlocked.toggle()
        if isBlocked {
            presentationMode.wrappedValue.dismiss()
        }
    }
}


struct HomePostsGridView: View {
    let posts: [Post]
    let columns = Array(repeating: GridItem(.flexible(), spacing: 5), count: 3)

    @State private var selectedPost: Post?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(posts) { post in  // No need for id: \.id anymore
                    Button(action: {
                        selectedPost = post  // Set the selected post
                    }) {
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
        .sheet(item: $selectedPost) { post in
            HomePostDetailView(post: post)
        }
    }
}
struct HomeCollectionsListView: View {
    let collections: [Collection]
    let posts: [Post]
    @StateObject private var userDataModel = UserDataModel.shared
    
    // Computed property to filter only public collections
    private var publicCollections: [Collection] {
        collections.filter { $0.type == .public }
    }
    
    // Function to get the first image for a collection
    private func getFirstCollectionImage(for collection: Collection) -> UIImage? {
        // Find the first post in the collection
        guard let firstPostID = collection.postIDs.first,
              let firstPost = posts.first(where: { $0.id == firstPostID }) else {
            return nil
        }
        return firstPost.postImage
    }
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            // Use publicCollections instead of collections
            ForEach(publicCollections, id: \.id) { collection in
                NavigationLink(destination: CollectionDetailView(collection: collection, posts: posts)) {
                    HStack(spacing: 20) {
                        // Fetch the first post's image for the collection
                        if let firstPostID = collection.postIDs.first,
                           let firstPost = posts.first(where: { $0.id == firstPostID }) {
                            Image(uiImage: firstPost.postImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 120)
                                .cornerRadius(10)
                                .clipped()
                        } else {
                            // Fallback image if no post is found
                            Image(systemName: "folder.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 100)
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
                                    .frame(width: 8, height: 8)
                                
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
        
        if let date = dateFormatter.date(from: collection.createdAt) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        
        return "N/A"
    }
}


struct HomeCollectionDetailView: View {
    let collection: Collection
    let posts: [Post]
    
    // Compute collection posts
    private var collectionPosts: [Post] {
        posts.filter { collection.postIDs.contains($0.id) }
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
                    // If no posts in collection, show a message
                    if collectionPosts.isEmpty {
                        Text("No posts in this collection")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        LazyVGrid(columns: [
                            GridItem(.adaptive(minimum: 150), spacing: 16),
                            GridItem(.adaptive(minimum: 150), spacing: 16)
                        ], spacing: 16) {
                            ForEach(collectionPosts, id: \.id) { post in
                                NavigationLink(destination: PostDetailView(post: post)) {
                                    PostCardView(post: post)
                                        .scaleEffect(1)
                                        .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: 1)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .navigationTitle(collection.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    shareCollection()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(Color(hex: "333333"))
                }
            }
        }
    }
    
    // Function to share the collection
    private func shareCollection() {
        // Create a string with the collection title and a link (or any other content you want to share)
        let shareText = "Check out this public collection: \(collection.title)\n\n[Link to Collection]"
        
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
