import SwiftUI
import PhotosUI

struct PersonalInformationView: View {
    @ObservedObject var userDataModel: UserDataModel
    
    // Use presentationMode to dismiss the view
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String
    @State private var userName: String
    @State private var email: String
    @State private var password: String
    @State private var profileImage: UIImage?
    @State private var showImagePicker = false
    
    init(userDataModel: UserDataModel) {
        self.userDataModel = userDataModel
        _name = State(initialValue: userDataModel.currentUser.basicInfo.name)
        _userName = State(initialValue: userDataModel.currentUser.basicInfo.userName)
        _email = State(initialValue: userDataModel.currentUser.basicInfo.email)
        _password = State(initialValue: userDataModel.currentUser.basicInfo.password)
        _profileImage = State(initialValue: userDataModel.currentUser.profileData.profileImage)
    }
    
    var body: some View {
        Form {
            // Profile Image Section
            Section(header: Text("Profile Image")) {
                VStack(alignment: .center) {
                    if let profileImage = profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color(hex: "B69D53"), lineWidth: 2)
                            )
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 170, height: 170)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                            )
                    }
                    
                    Button("Change Profile Image") {
                        showImagePicker = true
                    }
                    .foregroundColor(Color(hex: "B69D53"))
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
            }
            
            // Personal Information Section
            Section(header: Text("Personal Information")) {
                HStack {
                    Text("Name")
                        .frame(width: 100, alignment: .leading)
                    TextField("Enter your name", text: $name)
                }
                
                HStack {
                    Text("Username")
                        .frame(width: 100, alignment: .leading)
                    TextField("Enter your username", text: $userName)
                }
                
                HStack {
                    Text("Email")
                        .frame(width: 100, alignment: .leading)
                    TextField("Enter your email", text: $email)
                }
                
                HStack {
                    Text("Password")
                        .frame(width: 100, alignment: .leading)
                    SecureField("Enter your password", text: $password)
                }
            }
        }
        .navigationTitle("Personal Information")
        .navigationBarItems(trailing: Button("Done") {
            // Update the current user's personal information
            userDataModel.updatePersonalInformation(
                forUserID: userDataModel.currentUser.userID,
                name: name,
                userName: userName,
                email: email,
                password: password,
                profileImage: profileImage
            )
            
            // Dismiss the view after updating the data
            presentationMode.wrappedValue.dismiss()
        })
        .sheet(isPresented: $showImagePicker) {
            ImagePicker2(selectedImage: $profileImage)
        }
    }
}

struct ImagePicker2: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker2
        
        init(_ parent: ImagePicker2) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
