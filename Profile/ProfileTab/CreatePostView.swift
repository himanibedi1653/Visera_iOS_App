//
//  CreatePostView.swift
//  Profile
//
//  Created by Himani Bedi on 22/03/25.
//

import SwiftUI
import UIKit

struct CreatePostView: View {
    @ObservedObject var userDataModel: UserDataModel
    @Binding var showCreatePost: Bool
    
    @State private var description: String = ""
    @State private var tags: String = ""
    @State private var image: UIImage? = nil
    @State private var showImagePicker = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Description")) {
                    TextField("Write a description...", text: $description)
                }
                
                Section(header: Text("Tags")) {
                    TextField("Add tags (comma separated)...", text: $tags)
                }
                
                Section(header: Text("Photo")) {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                        } else {
                            Text("Tap to select a photo")
                        }
                    }
                }
            }
            .navigationTitle("Create Post")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showCreatePost = false
                },
                trailing: Button("Post") {
                    postNewPhoto()
                    showCreatePost = false
                }
            )
            .sheet(isPresented: $showImagePicker) {
                ImagePicker3(image: $image)
            }
        }
    }
    
    private func postNewPhoto() {
        guard let image = image else { return }
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Set the desired date format
            let dateString = dateFormatter.string(from: Date()) // Get the current date as a string
        
        let newPost = Post(
            id: userDataModel.currentUser.profileData.posts.count + 1,
            userID: userDataModel.currentUser.userID,
            tags: tags.components(separatedBy: ","),
            postImage: image,
            description: description,
            createdAt: dateString,
            crownCount: 0,
            comments: [],
            isSaved: false,
            isFollowed: false,
            collectionIDs: [],
            isCrowned: false
        )
        
        userDataModel.currentUser.profileData.posts.insert(newPost, at: 0)
    }
}

struct ImagePicker3: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker3
        
        init(_ parent: ImagePicker3) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    let userDataModel = UserDataModel.shared
    userDataModel.currentUser = user1
    @State var showCreatePost = true
    return CreatePostView(userDataModel: userDataModel, showCreatePost: $showCreatePost)
}
