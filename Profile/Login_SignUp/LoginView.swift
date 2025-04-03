import SwiftUI

// MARK: - Custom TextField Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
    }
}


// MARK: - LoginView
struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isActive: Bool = false // Add navigation state
    @EnvironmentObject var userDataModel: UserDataModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image("Logo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 90)
                
                HStack{
                    Text("Sign In To")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Image("Logo2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }
                
                VStack(spacing: 15) {
                    TextField("Email Address", text: $email)
                        .textFieldStyle(CustomTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(CustomTextFieldStyle())
                    
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            // TODO: Implement forgot password functionality
                        }
                        .foregroundColor(Color("B69D53"))
                    }
                    
                    if showError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                    
                    Button(action: login) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "B69D53"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .fontWeight(.bold)
                    }
                }
                .padding()
                
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(
                        destination: SignUpView(),
                        isActive: $isActive
                    ) {
                        Text("Sign Up")
                            .foregroundColor(Color(hex: "B69D53"))
                            .fontWeight(.bold)
                            .onTapGesture {
                                isActive = true
                            }
                    }
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
    
    func login() {
        // Validate email and password
        guard !email.isEmpty, !password.isEmpty else {
            showError = true
            errorMessage = "Please enter both email and password"
            return
        }
        
        // Find user by email and password
        if let user = userDataModel.users.first(where: { $0.basicInfo.email.lowercased() == email.lowercased() && $0.basicInfo.password == password }) {
            // Set current user
            userDataModel.currentUser = user
            
            // Dismiss the navigation view and present LaunchingScreen
            presentationMode.wrappedValue.dismiss()
            
            // Assuming you have a way to present LaunchingScreen as a full-screen cover or root view
            let rootView = Landing_Page()
            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: rootView)
            UIApplication.shared.windows.first?.makeKeyAndVisible()
            
            print("Login successful for user: \(user.basicInfo.name)")
        } else {
            showError = true
            errorMessage = "Invalid email or password"
        }
    }
}

// MARK: - SignUpView
struct SignUpView: View {
    @State private var name: String = ""
    @State private var userName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var showingSignupFlow: Bool = false
    @EnvironmentObject var userDataModel: UserDataModel
    @Environment(\.presentationMode) var presentationMode
    
    // Computed property to check if all fields are valid
    private var isFormValid: Bool {
        return !name.isEmpty &&
               !userName.isEmpty &&
               !email.isEmpty &&
               !password.isEmpty &&
               password == confirmPassword &&
               isValidEmail(email) &&
               password.count >= 6
    }
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 20) {
                Image("Logo1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 90)
                
                HStack{
                    Text("Sign Up for")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Image("Logo2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                }
            }
            
            VStack(spacing: 15) {
                TextField("Name", text: $name)
                    .textFieldStyle(CustomTextFieldStyle())
                
                TextField("User Name", text: $userName)
                    .textFieldStyle(CustomTextFieldStyle())
                
                TextField("Email Address", text: $email)
                    .textFieldStyle(CustomTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(CustomTextFieldStyle())
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(CustomTextFieldStyle())
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: validateAndProceed) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormValid ? Color(hex: "B69D53") : Color.clear)
                        .foregroundColor(isFormValid ? .white : Color(hex: "B69D53"))
                        .cornerRadius(10)
                        .fontWeight(.bold)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(hex: "B69D53"), lineWidth: 1)
                        )
                }
                .disabled(!isFormValid)
            }
            .padding()
            
            HStack {
                Text("Already have an account?")
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Sign In")
                        .foregroundColor(Color(hex: "B69D53"))
                        .fontWeight(.bold)
                }
            }
        }
        .navigationBarHidden(true)
        .fullScreenCover(isPresented: $showingSignupFlow) {
            SignupFlow(
                initialName: name,
                initialUsername: userName,
                initialEmail: email,
                initialPassword: password,
                onSignupComplete: { profileImage, portfolioLink, selectedSkills in
                    // Create complete user with all profile data
                    createUser(profileImage: profileImage, portfolioLink: portfolioLink, skills: selectedSkills)
                }
            )
        }
    }
    
    // Modified to only validate and then show the detailed signup flow
    func validateAndProceed() {
        // Validate inputs
        guard validateInputs() else { return }
        
        // Check if user already exists
        guard !userDataModel.users.contains(where: { $0.basicInfo.email.lowercased() == email.lowercased() }) else {
            showError = true
            errorMessage = "Email already in use"
            return
        }
        
        // Proceed to detailed signup flow
        showingSignupFlow = true
    }
    
    // This will be called only after the complete signup flow is finished
    func createUser(profileImage: UIImage?, portfolioLink: String?, skills: [String]) {
        // Create new user with complete profile data
        let interests = skills.compactMap { skill -> Interest? in
                // Normalize the skill string to match enum case format
                let normalizedSkill = skill
                    .lowercased()
                    .replacingOccurrences(of: "-", with: "")
                    .replacingOccurrences(of: " ", with: "")
                
                // Try to create an Interest enum value
                return Interest(rawValue: normalizedSkill)
            }
            
            // Create new user with complete profile data
            let newUser = User(
                userID: userDataModel.users.count + 1,
                basicInfo: BasicInfo(
                    name: name,
                    userName: userName,
                    email: email,
                    password: password
                ),
                profileData: ProfileData(
                    portfolio: portfolioLink != nil ? URL(string: portfolioLink!) : nil,
                    profileImage: profileImage,
                    followersIDs: [],
                    followingIDs: [],
                    skills: skills,
                    posts: [],
                    collections: [],
                    chats: [],
                    eventsRegistered: []
                ),
                userPreferences: UserPreferences(
                    interests: interests, // Now using the converted interests array
                    blockedUserIDs: [],
                    savedPostIDs: [],
                    notificationButton: true
                )
            )
        
        // Add user to UserDataModel and set as current user
        userDataModel.users.append(newUser)
        userDataModel.currentUser = newUser
        
        // Navigate to main app
        let rootView = Landing_Page()
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: rootView)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
        print("New user signed up with complete profile: \(newUser.basicInfo.name)")
    }
    
    private func validateInputs() -> Bool {
        guard !name.isEmpty, !userName.isEmpty, !email.isEmpty, !password.isEmpty else {
            showError = true
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard password == confirmPassword else {
            showError = true
            errorMessage = "Passwords do not match"
            return false
        }
        
        guard isValidEmail(email) else {
            showError = true
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        guard password.count >= 6 else {
            showError = true
            errorMessage = "Password must be at least 6 characters long"
            return false
        }
        
        showError = false
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
