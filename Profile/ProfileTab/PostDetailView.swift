import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct CollectionsView: View {
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

// MARK: - Snapshot Extension
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        
        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

// MARK: - UserInfoSection
struct UserInfoSection: View {
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
                .foregroundColor(Color(hex: "B69D53"))
        }
        .padding(.horizontal)
    }
}

// MARK: - PostImageSection
struct PostImageSection: View {
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
struct InteractionButtons: View {
    let post: Post
    @ObservedObject var userDataModel: UserDataModel
    @State private var showLikeAnimation: Bool = false
    @State private var showCollectionsSheet: Bool = false
    
    var body: some View {
        HStack(spacing: 20) {
            // Crown Button
            Button(action: {
                // Crown action logic
            }) {
                HStack(spacing: 5) {
                    Image(systemName: post.isCrowned ? "crown.fill" : "crown")
                        .foregroundColor(Color(hex: "B69D53"))
                        .font(.title2)
                        .bold()
                    Text("\(post.crownCount)")
                        .foregroundColor(.black)
                        .font(.title3)
                }
            }
            .overlay(
                Group {
                    if showLikeAnimation {
                        Image(systemName: "crown.fill")
                            .foregroundColor(Color(hex: "B69D53"))
                            .font(.largeTitle)
                            .transition(.scale.combined(with: .opacity))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation {
                                        showLikeAnimation = false
                                    }
                                }
                            }
                    }
                }
            )
            
            Spacer()
            
            // Share icon
            Button(action: {
                let image = PostDetailView(post: post, userDataModel: userDataModel).snapshot()
                let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
            }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color(hex: "B69D53"))
                    .font(.title2)
                    .bold()
            }
            
            // Pin icon - Updated to show collections sheet
            Button(action: {
                showCollectionsSheet = true
            }) {
                Image(systemName: "square.and.arrow.down.on.square.fill")
                    .foregroundColor(Color(hex: "B69D53"))
                    .font(.title2)
                    .bold()
            }
            .sheet(isPresented: $showCollectionsSheet) {
                SaveToCollectionView(post: post, userDataModel: userDataModel, showCollectionsSheet: $showCollectionsSheet)
            }
        }
        .padding(.horizontal)
    }
}


// MARK: - TagsSection
struct TagsSection: View {
    let tags: [String]
    let dominantColor: Color
    let textColor: Color
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(tags, id: \.self) { tag in
                    Text("#\(tag)")
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(dominantColor.opacity(1.0))
                        .foregroundColor(textColor)
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - CommentSection
struct CommentSection: View {
    let comments: [Comment]
    let userDataModel: UserDataModel
    @State private var showAllComments = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // Comment heading with count
            HStack {
                Text("Comments (\(comments.count))")
                    .font(.headline)
                Spacer()
                if comments.count > 2 {
                    Button(action: {
                        showAllComments.toggle()
                    }) {
                        Text(showAllComments ? "Hide" : "See All")
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "B69D53"))
                    }
                }
            }
            .padding(.horizontal)
            
            ForEach(comments.prefix(showAllComments ? comments.count : 2), id: \.content) { comment in
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
                        
                        Text(comment.timestamp)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $showAllComments) {
            AllCommentsView(comments: comments, userDataModel: userDataModel)
        }
    }
}

// MARK: - RelatedPostsSection
struct RelatedPostsSection: View {
    let relatedPosts: [Post]
    @ObservedObject var userDataModel = UserDataModel.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("More Posts")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(relatedPosts, id: \.id) { relatedPost in
                        NavigationLink(destination: PostDetailView(post: relatedPost, userDataModel: userDataModel)) {
                            Image(uiImage: relatedPost.postImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct AllCommentsView: View {
    let comments: [Comment]
    let userDataModel: UserDataModel
    @Environment(\.presentationMode) var presentationMode // Add this to dismiss the modal

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(comments, id: \.content) { comment in
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
                                
                                Text(comment.timestamp)
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
                        // Dismiss the modal
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - PostDetailView
struct PostDetailView: View {
    let post: Post
    @ObservedObject var userDataModel: UserDataModel
    @State private var dominantColor: Color = Color(hex: "B69D53")
    @State private var textColor: Color = .black
    @Environment(\.presentationMode) var presentationMode
    
    // Remove the isSaved state var since we'll use post.isSaved directly
    // We're now getting the current state from the model
    
    init(post: Post, userDataModel: UserDataModel = UserDataModel.shared) {
        self.post = post
        self._userDataModel = ObservedObject(wrappedValue: userDataModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let user = userDataModel.getUser(byID: post.userID) {
                    UserInfoSection(user: user, createdAt: post.createdAt, userDataModel: userDataModel)
                }
                
                PostImageSection(postImage: post.postImage, dominantColor: dominantColor)
                
                // Use the updated InteractionButtons that uses the current post state
                InteractionButtons(post: post, userDataModel: userDataModel)
                
                TagsSection(tags: post.tags, dominantColor: dominantColor, textColor: textColor)
                
                if let description = post.description {
                    Text(description)
                        .font(.body)
                        .padding(.horizontal)
                }
                
                CommentSection(comments: post.comments, userDataModel: userDataModel)
                
                RelatedPostsSection(relatedPosts: userDataModel.getAllPosts(forUser: userDataModel.currentUser))
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle("User Post")
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
        // Add id to force view refresh when post changes
        .id("post-\(post.id)-\(post.isSaved)")
    }
    
    // Function to extract the dominant color from the image and determine if it's dark
    private func extractDominantColor(from image: UIImage) -> (Color, Bool) {
        guard let cgImage = image.cgImage else { return (Color(hex: "B69D53"), false) }
        
        // Resize the image to a smaller size for faster processing
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
        
        // Analyze the pixel data to find the most frequent color
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
        
        // Find the most frequent color
        guard let dominantUIColor = colorFrequency.max(by: { $0.value < $1.value })?.key else {
            return (Color(hex: "B69D53"), false)
        }
        
        // Calculate luminance
        let ciColor = CIColor(color: dominantUIColor)
        let luminance = (0.299 * ciColor.red) + (0.587 * ciColor.green) + (0.114 * ciColor.blue)
        
        // Determine if the color is dark
        let isDark = luminance < 0.5
        
        return (Color(dominantUIColor), isDark)
    }
}

    
    #Preview {
        PostDetailView(post: Post(
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
            isSaved: true,
            isFollowed: false,
            collectionIDs: [1],
            isCrowned: true
        ))
    }
