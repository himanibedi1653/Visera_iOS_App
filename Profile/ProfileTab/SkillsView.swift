import SwiftUI

struct SkillsView: View {
    @ObservedObject var userDataModel: UserDataModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var skillToDelete: String? = nil
    @State private var showDeleteConfirmation = false
    @State private var skills: [String]
    @State private var showSkillPicker = false
    
    // Predefined list of skills
    let predefinedSkills = [
        "Hand", "Promotional", "Child", "PlusSize", "Glamour", "Hairstylist",
        "Alternative", "Lifestyle", "Editorial", "MakeupArtist", "Freelancer",
        "Petite", "Commercial", "Tattooed", "Fitness", "Events", "HighFashion",
        "Runway", "Fashion", "Agency", "Catalog", "Beauty", "Photography"
    ]
    
    init(userDataModel: UserDataModel) {
        self.userDataModel = userDataModel
        _skills = State(initialValue: userDataModel.getUserSkills(forUser: userDataModel.currentUser))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Select skill section
            VStack(alignment: .leading, spacing: 12) {
                Text("Select a Skill")
                    .font(.headline)
                    .padding(.horizontal)
                
                Button(action: {
                    showSkillPicker = true
                }) {
                    HStack {
                        Text("Choose from available skills")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(Color(hex: "B69D53"))
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            
            Divider()
            
            // Current skills display
            VStack(alignment: .leading, spacing: 12) {
                Text("Your Skills")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                if skills.isEmpty {
                    Text("No skills selected yet")
                        .foregroundColor(.gray)
                        .italic()
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 12) {
                            ForEach(skills, id: \.self) { skill in
                                SkillBubbleView(skill: skill) {
                                    skillToDelete = skill
                                    showDeleteConfirmation = true
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .padding(.top)
            
            Spacer()
        }
        .navigationTitle("Skills")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: saveChanges) {
                    Text("Save")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(hex: "B69D53"))
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .actionSheet(isPresented: $showDeleteConfirmation) {
            ActionSheet(
                title: Text("Delete Skill"),
                message: Text("Are you sure you want to remove '\(skillToDelete ?? "")'?"),
                buttons: [
                    .destructive(Text("Remove")) {
                        if let skill = skillToDelete {
                            removeSkill(skill)
                        }
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showSkillPicker) {
            SkillPickerView(
                predefinedSkills: predefinedSkills,
                selectedSkills: skills,
                onSelect: { selectedSkill in
                    addSkill(selectedSkill)
                    showSkillPicker = false
                },
                onDismiss: {
                    showSkillPicker = false
                }
            )
        }
        .onAppear {
            // Refresh skills from the model when view appears
            skills = userDataModel.getUserSkills(forUser: userDataModel.currentUser)
        }
    }
    
    private func addSkill(_ skill: String) {
        if skills.contains(where: { $0.lowercased() == skill.lowercased() }) {
            alertMessage = "This skill is already in your list."
            showAlert = true
            return
        }
        
        skills.append(skill)
    }
    
    private func removeSkill(_ skill: String) {
        if let index = skills.firstIndex(of: skill) {
            skills.remove(at: index)
        }
    }
    
    private func saveChanges() {
        // Update the user model and ensure it triggers UI refresh
        userDataModel.updateSkills(forUserID: userDataModel.currentUser.userID, skills: skills)
        
        // Trigger immediate UI update for the current view
        skills = userDataModel.getUserSkills(forUser: userDataModel.currentUser)
        
        alertMessage = "Skills updated successfully!"
        showAlert = true
        
        // Navigate back after saving
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct SkillBubbleView: View {
    let skill: String
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Text(skill)
                .lineLimit(1)
                .padding(.leading, 12)
                .padding(.trailing, 4)
                .padding(.vertical, 8)
            
            Button(action: onDelete) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red.opacity(0.7))
                    .padding(.trailing, 8)
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }
}

// New view for selecting from predefined skills
struct SkillPickerView: View {
    let predefinedSkills: [String]
    let selectedSkills: [String]
    let onSelect: (String) -> Void
    let onDismiss: () -> Void
    
    var availableSkills: [String] {
        predefinedSkills.filter { skill in
            !selectedSkills.contains { $0.lowercased() == skill.lowercased() }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                if availableSkills.isEmpty {
                    Text("You've selected all available skills")
                        .foregroundColor(.gray)
                        .italic()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(availableSkills, id: \.self) { skill in
                        Button(action: {
                            onSelect(skill)
                        }) {
                            Text(skill.capitalized)
                                .padding(.vertical, 8)
                        }
                    }
                }
            }
            .navigationTitle("Available Skills")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Cancel") {
                    onDismiss()
                }
                .foregroundColor(Color(hex: "B69D53"))
            )
        }
    }
}
