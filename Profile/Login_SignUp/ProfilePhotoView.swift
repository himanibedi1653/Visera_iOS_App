import SwiftUI

// MARK: - Modified SignupFlow
struct SignupFlow: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentScreen = 1
    @State private var name: String
    @State private var username: String
    @State private var email: String
    @State private var password: String
    @State private var profileImage: UIImage? = nil
    @State private var portfolioLink = ""
    @State private var selectedSkills: [String] = []
    
    // Completion handler to navigate to home page with collected data
    var onSignupComplete: (UIImage?, String?, [String]) -> Void
    
    // Initialize with data from previous screen
    init(initialName: String, initialUsername: String, initialEmail: String, initialPassword: String, onSignupComplete: @escaping (UIImage?, String?, [String]) -> Void) {
        self._name = State(initialValue: initialName)
        self._username = State(initialValue: initialUsername)
        self._email = State(initialValue: initialEmail)
        self._password = State(initialValue: initialPassword)
        self.onSignupComplete = onSignupComplete
    }
    
    // Available skills for selection
    let skills = [
        "Hand", "Promotional", "Child",
        "Plus-Size", "Glamour", "Hair Stylist",
        "Alternative", "Lifestyle", "Editorial",
        "Make-up Artist", "Freelance", "Petite",
        "Commercial", "Tattooed", "Fitness",
        "Commercial", "Events", "High Fashion",
        "Runway", "Fashion", "Agencies",
        "Catalog", "Beauty", "Photography"
    ]
    
    var body: some View {
        // Using ProfilePhotoView.swift components
        switch currentScreen {
        case 1:
            ProfilePictureScreen(
                profileImage: $profileImage,
                goBack: {
                    // Go back to initial signup form
                    presentationMode.wrappedValue.dismiss()
                },
                goNext: { currentScreen = 2 }
            )
        case 2:
            PortfolioLinkScreen(
                portfolioLink: $portfolioLink,
                goBack: { currentScreen = 1 },
                goNext: { currentScreen = 3 }
            )
        case 3:
            SkillsSelectionScreen(
                selectedSkills: $selectedSkills,
                skills: skills,
                goBack: { currentScreen = 2 },
                onComplete: {
                    // Complete the signup process with all gathered data
                    onSignupComplete(profileImage, portfolioLink.isEmpty ? nil : portfolioLink, selectedSkills)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        default:
            ProfilePictureScreen(
                profileImage: $profileImage,
                goBack: {
                    presentationMode.wrappedValue.dismiss()
                },
                goNext: { currentScreen = 2 }
            )
        }
    }
}

struct ViseraLogo: View {
    var body: some View {
        ZStack {
            Text("V")
                .font(.custom("Georgia", size: 40))
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "b8a369"))
            
            // Simplified leaf design
            Path { path in
                path.move(to: CGPoint(x: 30, y: 15))
                path.addLine(to: CGPoint(x: 40, y: 10))
                path.addLine(to: CGPoint(x: 35, y: 25))
            }
            .stroke(Color(hex: "b8a369"), lineWidth: 1)
        }
        .frame(width: 60, height: 60)
    }
}

struct UserDetailsScreen: View {
    @Binding var name: String
    @Binding var username: String
    @Binding var email: String
    @Binding var password: String
    let goNext: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 60)
            
            VStack(spacing: 20) {
                Image("Logo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 90)
                
                HStack{
                    Text("Sign In for")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Image("Logo2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }
            }
            
            Spacer()
                .frame(height: 30)
            
            VStack(spacing: 15) {
                TextField("Full Name", text: $name)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                
                TextField("Username", text: $username)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
            
            Spacer()
            
            Text("1/4")
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 20)
            
            Button(action: goNext) {
                Text("Next")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 50)
                    .background(Color(hex: "b8a369"))
                    .cornerRadius(25)
            }
            .padding(.bottom, 40)
        }
    }
}

struct ProfilePictureScreen: View {
    @Binding var profileImage: UIImage?
    let goBack: () -> Void
    let goNext: () -> Void
    
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 60)
            
            VStack(spacing: 20) {
                Image("Logo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 90)
                
                HStack{
                    Text("Welcome To")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Image("Logo2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }
                
                Spacer()
                    .frame(height: 80)
                
                VStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(UIColor.systemGray6))
                            .frame(width: 200, height: 200)
                        
                        if let image = profileImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 200, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(hex: "b8a369"))
                        }
                    }
                    .onTapGesture {
                        showingImagePicker = true
                    }
                    
                    Text("Upload Your Profile Picture")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("2/4")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)
                
                HStack {
                    Button(action: goBack) {
                        Text("Back")
                            .foregroundColor(Color(hex: "b8a369"))
                            .padding(.leading, 20)
                    }
                    
                    Spacer()
                    
                    Button(action: goNext) {
                        Text(profileImage == nil ? "Skip" : "Next")
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color(hex: "b8a369"))
                            .cornerRadius(30)
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 40)
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker4(image: $profileImage)
            }
        }
    }
}
    struct PortfolioLinkScreen: View {
        @Binding var portfolioLink: String
        let goBack: () -> Void
        let goNext: () -> Void
        
        var body: some View {
            VStack {
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 20) {
                    Image("Logo1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 90)
                    
                    HStack{
                        Text("Welcome To")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Image("Logo2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 40)
                    }
                }
                
                Spacer()
                    .frame(height: 40)
                
                VStack(spacing: 20) {
                    TextField("Enter portfolio link", text: $portfolioLink)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    
                    Text("Upload Link of Portfolio")
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text("3/4")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)
                
                HStack {
                    Button(action: goBack) {
                        Text("Back")
                            .foregroundColor(Color(hex: "b8a369"))
                            .padding(.leading, 20)
                    }
                    
                    Spacer()
                    
                    Button(action: goNext) {
                        Text(portfolioLink.isEmpty ? "Skip" : "Next")
                            .foregroundColor(.white)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color(hex: "b8a369"))
                            .cornerRadius(30)
                    }
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    struct SkillsSelectionScreen: View {
        @Binding var selectedSkills: [String]
        let skills: [String]
        let goBack: () -> Void
        let onComplete: () -> Void
        
        // Check if at least one skill is selected
        private var isAtLeastOneSkillSelected: Bool {
            return !selectedSkills.isEmpty
        }
        
        var body: some View {
            VStack {
                Spacer()
                    .frame(height: 60)
                
                VStack(spacing: 20) {
                    Image("Logo1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 90)
                    
                    Text("Let's find out your tastes.\nWhat you're into?")
                        .font(.system(size: 18))
                        .multilineTextAlignment(.center)
                        .padding(.top, 20)
                    }
                
                ScrollView {
                    HStack {
                        Spacer()
                        FlowLayout(spacing: 8) {
                            ForEach(skills, id: \.self) { skill in
                                SkillButton(
                                    title: skill,
                                    isSelected: selectedSkills.contains(skill),
                                    action: {
                                        if selectedSkills.contains(skill) {
                                            selectedSkills.removeAll { $0 == skill }
                                        } else {
                                            selectedSkills.append(skill)
                                        }
                                    }
                                )
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
                
                Text("4/4")
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 20)
                
                HStack {
                    Button(action: goBack) {
                        Text("Back")
                            .foregroundColor(Color(hex: "b8a369"))
                            .padding(.leading, 20)
                    }
                    
                    Spacer()
                    
                    Button(action: onComplete) {
                        Text("Get Started")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .bold))
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                            .background(isAtLeastOneSkillSelected ? Color(hex: "b8a369") : Color.clear)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color(hex: "b8a369"), lineWidth: 1)
                            )
                    }
                    .disabled(!isAtLeastOneSkillSelected)
                    .padding(.trailing, 20)
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    struct SkillButton: View {
        let title: String
        let isSelected: Bool
        let action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(title)
                    .foregroundColor(isSelected ? .white : Color(hex: "b8a369"))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(isSelected ? Color(hex: "b8a369") : Color.clear)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(hex: "b8a369"), lineWidth: 1)
                    )
            }
        }
    }
    
    // Implementation of a flow layout for the skills
    struct FlowLayout: Layout {
        var spacing: CGFloat
        
        func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
            let width = proposal.width ?? 0
            var height: CGFloat = 0
            var x: CGFloat = 0
            var y: CGFloat = 0
            var maxHeight: CGFloat = 0
            
            for view in subviews {
                let size = view.sizeThatFits(.unspecified)
                
                if x + size.width > width {
                    x = 0
                    y += maxHeight + spacing
                    maxHeight = 0
                }
                
                maxHeight = max(maxHeight, size.height)
                x += size.width + spacing
                
                if x > width {
                    height = y + maxHeight
                }
            }
            
            return CGSize(width: width, height: max(height, y + maxHeight))
        }
        
        func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
            var x = bounds.minX
            var y = bounds.minY
            var maxHeight: CGFloat = 0
            let width = bounds.width
            
            for view in subviews {
                let size = view.sizeThatFits(.unspecified)
                
                if x + size.width > width + bounds.minX {
                    x = bounds.minX
                    y += maxHeight + spacing
                    maxHeight = 0
                }
                
                view.place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                maxHeight = max(maxHeight, size.height)
                x += size.width + spacing
            }
        }
    }
    
    // Helper for UIImage picker
    struct ImagePicker4: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        @Environment(\.presentationMode) var presentationMode
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.allowsEditing = true
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            let parent: ImagePicker4
            
            init(_ parent: ImagePicker4) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let editedImage = info[.editedImage] as? UIImage {
                    parent.image = editedImage
                } else if let originalImage = info[.originalImage] as? UIImage {
                    parent.image = originalImage
                }
                parent.presentationMode.wrappedValue.dismiss()
            }
        }
    }
