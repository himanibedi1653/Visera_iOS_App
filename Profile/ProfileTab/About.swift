import SwiftUI

struct About: View {
    @ObservedObject var userDataModel: UserDataModel
    
    let tableData: [(icon: String, fieldName: String)] = [
        ("person.fill", "Personal Information"),
        ("sparkles", "Skills"),
        ("bookmark.fill", "Saved"),
        ("circle.slash", "Blocked"),
        ("bell.fill", "Notifications"),
        ("rectangle.portrait.and.arrow.right", "Log out")
    ]
    
    @State private var notificationsEnabled: Bool = true
    
    var body: some View {
        // Remove the NavigationView that was here
        List {
            // Section 1: Profile Photo, Name, and Add Portfolio Button
            Section {
                ProfileHeaderView(userDataModel: userDataModel)
            }
            
            // Section 2: Portfolio Options
            Section(header: Text("About").font(.headline)) {
                ForEach(tableData, id: \.fieldName) { item in
                    NavigationLink(destination: destinationView(for: item.fieldName)) {
                        AboutRowView(icon: item.icon, fieldName: item.fieldName, notificationsEnabled: $notificationsEnabled)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Helper Function for NavigationLink Destinations
    @ViewBuilder
    private func destinationView(for fieldName: String) -> some View {
        switch fieldName {
        case "Personal Information":
            PersonalInformationView(userDataModel: userDataModel)
        case "Skills":
            SkillsView(userDataModel: userDataModel)
        case "Saved":
            SavedPostsView(userDataModel: userDataModel, user: userDataModel.currentUser)
        case "Blocked":
            BlockedUsersView(userDataModel: userDataModel, user: userDataModel.currentUser)
        case "Log out":
            Color.clear.onAppear {
                userDataModel.logout()
            }
        default:
            EmptyView()
        }
    }
}
    
#Preview {
    NavigationView {
        About(userDataModel: UserDataModel.shared)
    }
}

