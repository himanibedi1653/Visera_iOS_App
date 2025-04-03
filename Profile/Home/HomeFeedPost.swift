//
//  HomeFeedPost.swift
//  Visera
//
//  Created by Himani Bedi on 23/03/25.
//

import Foundation
import SwiftUI
import SwiftUI
struct HomePostDetailView: View {
    @State private var post: Post
    @State private var isSaved: Bool
    @StateObject private var userDataModel = UserDataModel.shared
    @State private var dominantColor: Color = Color("B69D53")
    @State private var textColor: Color = .black
    @State private var selectedTag: String?

    @Environment(\.presentationMode) var presentationMode
    
    init(post: Post) {
        _post = State(initialValue: post)
        _isSaved = State(initialValue: post.isSaved)
    }

    var body: some View {
        NavigationStack { // ✅ Replace NavigationView with NavigationStack
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let user = userDataModel.getUser(byID: post.userID) {
                        HomeUserInfoSection(user: user, createdAt: post.createdAt, userDataModel: userDataModel)
                    }

                    HomePostImageSection(postImage: post.postImage, dominantColor: dominantColor)
                        .padding(.horizontal)

                    HomeInteractionButtons(post: post, isSaved: $isSaved)

                    // ✅ Fixed Navigation for tags
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(post.tags, id: \.self) { tag in
                                Button(action: {
                                    selectedTag = tag
                                }) {
                                    Text("#\(tag)")
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(dominantColor.opacity(1.0))
                                        .foregroundColor(textColor)
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    if let description = post.description {
                        Text(description)
                            .font(.body)
                            .padding(.horizontal)
                    }

                    HomeCommentSection(postID: post.id, userDataModel: userDataModel)

                    HomeRelatedPostsSection(
                        relatedPosts: userDataModel.getFeedPosts(for: userDataModel.currentUser, allUsers: userDataModel.users),
                        currentPostID: post.id
                    )

                    Spacer()
                }
                .padding(.vertical)
            }
            .navigationTitle("Post")
            .navigationBarTitleDisplayMode(.inline)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.height > 100 {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            )
            .onAppear {
                let (color, isDark) = extractDominantColor(from: post.postImage)
                dominantColor = color
                textColor = isDark ? .white : .black
            }
            // ✅ FIXED navigationDestination
            .navigationDestination(item: $selectedTag) { tag in
                SearchView(loggedInUserID: userDataModel.currentUser.userID ?? 0, searchQuery: tag)
            }
            }
        }
    
    // Function to toggle crown state
    private func toggleCrown() {
        userDataModel.toggleCrown(postID: post.id, userID: userDataModel.currentUser.userID ?? 0)
        
        // Fetch the updated post state
        if let updatedPost = userDataModel.getPostByID(postID: post.id) {
            post = updatedPost
        }
    }
    
    // Function to extract the dominant color from the image and determine if it's dark
    private func extractDominantColor(from image: UIImage) -> (Color, Bool) {
        guard let cgImage = image.cgImage else { return (Color(hex: "B69D53"), false) }
        
        let width = 100
        let height = 100
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        var rawData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)
        
        guard let context = CGContext(
            data: &rawData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return (Color(hex: "B69D53"), false) }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var colorFrequency: [UIColor: Int] = [:]
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * bytesPerRow) + (x * bytesPerPixel)
                let red = CGFloat(rawData[offset]) / 255.0
                let green = CGFloat(rawData[offset + 1]) / 255.0
                let blue = CGFloat(rawData[offset + 2]) / 255.0
                let alpha = CGFloat(rawData[offset + 3]) / 255.0
                let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
                
                colorFrequency[color] = (colorFrequency[color] ?? 0) + 1
            }
        }
        
        guard let dominantUIColor = colorFrequency.max(by: { $0.value < $1.value })?.key else {
            return (Color(hex: "B69D53"), false)
        }
        
        let ciColor = CIColor(color: dominantUIColor)
        let luminance = (0.299 * ciColor.red) + (0.587 * ciColor.green) + (0.114 * ciColor.blue)
        
        let isDark = luminance < 0.5
        
        return (Color(dominantUIColor), isDark)
    }
}


// MARK: - TagsSection
struct HomeTagsSection: View {
    let tags: [String]
    let dominantColor: Color
    let textColor: Color
    var tagTapped: ((String) -> Void)?  // Closure for tag tap action

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Button(action: {
                        tagTapped?(tag)  // Call closure when tag is tapped
                    }) {
                        Text("#\(tag)")
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(dominantColor.opacity(1.0))
                            .foregroundColor(textColor)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
struct HomeCollectionsView: View {
    let collections: [Collection]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List(collections, id: \.id) { collection in
                VStack(alignment: .leading) {
                    Text(collection.title)
                        .font(.headline)
                    Text(collection.type == .private ? "Private" : "Public")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .onTapGesture {
                    // Save the post to this collection
                    // You can add logic here to handle saving the post
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationTitle("Save to Collection")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - UserInfoSection
struct HomeUserInfoSection: View {
    let user: User
    let createdAt: String
    let userDataModel: UserDataModel
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            if let profileImage = userDataModel.getUserImage(forUser: user) {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(userDataModel.getUserName(forUser: user))
                    .font(.headline)
                Text(userDataModel.getUserHandle(forUser: user))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(createdAt)
                .font(.subheadline)
                .bold()
                .foregroundColor(Color("B69D53"))
        }
        .padding(.horizontal)
    }
}

// MARK: - PostImageSection
struct HomePostImageSection: View {
    let postImage: UIImage
    let dominantColor: Color
    @State private var scale: CGFloat = 1.0
    @State private var isZoomed: Bool = false
    
    var body: some View {
        Image(uiImage: postImage)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: 500)
            .clipped()
            .cornerRadius(10)
            .scaleEffect(scale)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = value
                        isZoomed = true
                    }
                    .onEnded { _ in
                        if scale < 1.0 {
                            scale = 1.0
                            isZoomed = false
                        }
                    }
            )
            .padding(.horizontal)
    }
}

// MARK: - InteractionButtons
struct HomeInteractionButtons: View {
    @State private var post: Post
    @State private var showCollectionsSheet: Bool = false
    @Binding var isSaved: Bool
    @StateObject private var userDataModel = UserDataModel.shared
    @State private var crownCount: Int
    @State private var isSharePresented = false

    init(post: Post, isSaved: Binding<Bool>) {
        self.post = post
        self._isSaved = isSaved
        self._crownCount = State(initialValue: post.crownCount)
    }

    var body: some View {
        HStack(spacing: 20) {
            // Crown icon
            Button(action: {
                toggleCrown()
            }) {
                HStack(spacing: 5) {
                    Image(systemName: post.isCrowned ? "crown.fill" : "crown")
                        .foregroundColor(post.isCrowned ? Color(hex: "B69D53") : .gray)
                        .font(.title2)
                        .bold()
                    Text("\(crownCount)")
                        .foregroundColor(.black)
                        .font(.title3)
                }
            }

            Spacer()

            // Share icon
            Button(action: {
                sharePost()
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color(hex: "B69D53"))
                    .font(.title2)
                    .bold()
            }

            // Save icon with "Save to Collection" feature
            Button(action: {
                toggleSave()
            }) {
                Image(systemName: isSaved ? "pin.fill" : "pin")
                    .foregroundColor(isSaved ? Color(hex: "B69D53") : .gray)
                    .font(.title2)
                    .bold()
            }
        }
        .padding(.horizontal)
    }

    private func toggleCrown() {
        userDataModel.toggleCrown(postID: post.id, userID: userDataModel.currentUser.userID)

        if let updatedPost = userDataModel.posts.first(where: { $0.id == post.id }) {
            post = updatedPost
            crownCount = updatedPost.crownCount
        }
    }

    private func toggleSave() {
        userDataModel.toggleSave(postID: String(post.id))  // Convert ID to String
        isSaved.toggle()
    }

    private func sharePost() {
        // Create an array of items to share
        var itemsToShare: [Any] = []

        // Add post image
        itemsToShare.append(post.postImage)

        // Add post description if available
        if let description = post.description {
            itemsToShare.append(description)
        }

        // Add tags as text
        let tagsText = "#" + post.tags.joined(separator: " #")
        itemsToShare.append(tagsText)

        // Present the activity view controller
        let activityViewController = UIActivityViewController(
            activityItems: itemsToShare,
            applicationActivities: nil
        )

        // Get the top-most view controller to present the share sheet
        if let rootViewController = UIApplication.shared.windows.first?.rootViewController {
            var topViewController = rootViewController
            while let presentedViewController = topViewController.presentedViewController {
                topViewController = presentedViewController
            }
            
            topViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

//
//// MARK: - TagsSection
//struct HomeTagsSection: View {
//    let tags: [String]
//    let dominantColor: Color
//    let textColor: Color
//    var tagTapped: ((String) -> Void)?  // Closure for tag tap action
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 10) {
//                ForEach(tags, id: \.self) { tag in
//                    Button(action: {
//                        tagTapped?(tag)  // Call closure when tag is tapped
//                    }) {
//                        Text("#\(tag)")
//                            .font(.subheadline)
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 6)
//                            .background(dominantColor.opacity(1.0))
//                            .foregroundColor(textColor)
//                            .cornerRadius(20)
//                    }
//                }
//            }
//            .padding(.horizontal)
//        }
//    }
//}
//
//import SwiftUI

struct HomeCommentSection: View {
    let postID: Int
    @ObservedObject var userDataModel: UserDataModel
    @State private var newComment = ""
    @State private var showAllComments = false

    var body: some View {
        VStack(alignment: .leading) {
            // Comment heading with count
            HStack {
                Text("Comments (\(userDataModel.getComments(for: postID).count))")
                    .font(.headline)
                Spacer()
                if userDataModel.getComments(for: postID).count > 2 {
                    Button(action: {
                        showAllComments.toggle()
                    }) {
                        Text("See All")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "B69D53"))
                    }
                }
            }
            .padding(.horizontal)
            
            // Show latest comments (newest first, max 2)
            ForEach(userDataModel.getComments(for: postID)
                        .sorted { $0.timestamp > $1.timestamp }
                        .prefix(2), id: \.timestamp) { comment in
                if let commentUser = userDataModel.getUser(byID: comment.userID) {
                    HStack(alignment: .top, spacing: 10) {
                        if let profileImage = userDataModel.getUserImage(forUser: commentUser) {
                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(commentUser.basicInfo.userName)
                                .font(.subheadline)
                                .bold()
                            Text(comment.content)
                                .font(.body)
                        }
                        
                        Spacer()
                        
                        Text(formatDate(comment.timestamp)) // ✅ Fixes Date Formatting
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
            }
            
            // Comment Input Field
            HStack {
                TextField("Add a comment...", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: addComment) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(newComment.isEmpty ? .gray : Color(hex: "B69D53"))
                }
                .disabled(newComment.isEmpty)
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $showAllComments) {
            HomeAllCommentsView(comments: userDataModel.getComments(for: postID), userDataModel: userDataModel)
        }
    }
    
    // ✅ Function to properly format timestamp as YYYY-MM-DD
    private func formatDate(_ timestamp: String) -> String {
        let inputFormats = [
            "yyyy-MM-dd HH:mm:ss Z",   // Example: 2025-03-25 09:18:34 +0000
            "yyyy-MM-dd'T'HH:mm:ssZ",  // Example: 2025-03-25T09:18:34Z
            "yyyy-MM-dd"               // Example: 2025-01-07
        ]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"

        for format in inputFormats {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = format
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let date = inputFormatter.date(from: timestamp) {
                return outputFormatter.string(from: date)
            }
        }

        return timestamp // Fallback if parsing fails
    }
    
    private func addComment() {
        guard !newComment.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        userDataModel.addComment(toPostID: postID, byUserID: userDataModel.currentUser.userID, content: newComment)
        newComment = "" // Clear input field
    }
}


// MARK: - RelatedPostsSection
struct HomeRelatedPostsSection: View {
    let relatedPosts: [Post]
    @ObservedObject var userDataModel = UserDataModel.shared
    @State private var selectedPost: Post?  // Track selected post
    let currentPostID: Int  // Change the type of currentPostID to Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("More Posts")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    // Filter out the current post from the related posts
                    ForEach(relatedPosts.filter { $0.id != currentPostID }.prefix(8), id: \.id) { relatedPost in
                        Image(uiImage: relatedPost.postImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedPost = relatedPost  // Open sheet on tap
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
        .sheet(item: $selectedPost) { post in
            HomePostDetailView(post: post)
        }
    }
}


struct HomeAllCommentsView: View {
    let comments: [Comment]
    let userDataModel: UserDataModel
    @Environment(\.presentationMode) var presentationMode // For dismissing the modal

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Display latest comments first
                    ForEach(comments.sorted { $0.timestamp > $1.timestamp }, id: \.timestamp) { comment in
                        if let commentUser = userDataModel.getUser(byID: comment.userID) {
                            HStack(alignment: .top, spacing: 10) {
                                if let profileImage = userDataModel.getUserImage(forUser: commentUser) {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(commentUser.basicInfo.userName)
                                        .font(.subheadline)
                                        .bold()
                                    Text(comment.content)
                                        .font(.body)
                                }
                                
                                Spacer()
                                
                                Text(formatDate(comment.timestamp)) // ✅ Fixes Date Formatting
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("All Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss() // Dismiss modal
                    }
                }
            }
        }
    }
    
    // ✅ Function to format timestamp as YYYY-MM-DD
    private func formatDate(_ timestamp: String) -> String {
        let inputFormats = [
            "yyyy-MM-dd HH:mm:ss Z",   // Example: 2025-03-25 09:18:34 +0000
            "yyyy-MM-dd'T'HH:mm:ssZ",  // Example: 2025-03-25T09:18:34Z
            "yyyy-MM-dd"               // Example: 2025-01-07
        ]
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd"

        for format in inputFormats {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = format
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            inputFormatter.timeZone = TimeZone(abbreviation: "UTC")
            
            if let date = inputFormatter.date(from: timestamp) {
                return outputFormatter.string(from: date)
            }
        }

        return timestamp // Fallback if parsing fails
    }
}



// MARK: - PostDetailView


#Preview {
    HomePostDetailView(post: Post(
        id: 101,
        userID: 1,
        tags: ["fashion", "lifestyle", "beauty", "makeup", "event", "runway"],
        postImage: UIImage(named: "post1")!,
        description: "I got to work with one of the best fashion designers in the world! Check out this incredible collection! Where I slay the runway!",
        createdAt: "2025-01-01",
        crownCount: 15,
        comments: [
            Comment(userID: 2, content: "Amazing outfit!", timestamp: "2025-01-02"),
            Comment(userID: 3, content: "You look stunning!", timestamp: "2025-01-02"),
            Comment(userID: 2, content: "Amazing outfit!", timestamp: "2025-01-02"),
            Comment(userID: 3, content: "You look stunning!", timestamp: "2025-01-02"),
            Comment(userID: 2, content: "Amazing outfit!", timestamp: "2025-01-02"),
            Comment(userID: 3, content: "You look stunning!", timestamp: "2025-01-02")
        ],
        isSaved: false,
        isFollowed: false,
        collectionIDs: [1],
        isCrowned: true
    ))
}
