//
//  BlockedUsersView.swift
//  Profile
//
//  Created by Himani Bedi on 21/03/25.
//

import SwiftUI

struct BlockedUsersView: View {
    @ObservedObject var userDataModel: UserDataModel
    var user: User
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            Spacer()
            if userDataModel.getBlockedUsers(forUser: user).isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "person.slash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color(hex: "B69D53"))
                    
                    Text("No Blocked Users")
                        .font(.headline)
                    
                    Text("When you block someone, they'll appear here")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 50)
                Spacer()
            } else {
                List {
                    ForEach(userDataModel.getBlockedUsers(forUser: user), id: \.userID) { blockedUser in
                        HStack(spacing: 15) {
                            // Profile Image
                            if let profileImage = userDataModel.getUserImage(forUser: blockedUser) {
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
                                    .foregroundColor(.gray)
                            }
                            
                            // User details
                            VStack(alignment: .leading, spacing: 4) {
                                Text(blockedUser.basicInfo.name)
                                    .font(.headline)
                                
                                Text("@\(blockedUser.basicInfo.userName)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // Only show unblock button in edit mode
                            if isEditing {
                                Button(action: {
                                    // We need to add this method to the UserDataModel
                                    unblockUser(blockedUser.userID)
                                }) {
                                    Text("Unblock")
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color(hex: "B69D53"))
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
        }
        .navigationTitle("Blocked Users")
        .navigationBarItems(trailing: Button(isEditing ? "Done" : "Edit") {
            isEditing.toggle()
        })
    }
    
    // Function to unblock a user
    private func unblockUser(_ userIDToUnblock: Int) {
        // First, update the current user's preferences
        if var updatedPreferences = userDataModel.getUser(byID: user.userID)?.userPreferences {
            updatedPreferences.blockedUserIDs.removeAll { $0 == userIDToUnblock }
            
            // Find the index of the user and update their preferences
            if let index = userDataModel.getAllUsers().firstIndex(where: { $0.userID == user.userID }) {
                // Need to extend UserDataModel to add this functionality
                userDataModel.updateBlockedUsers(userID: user.userID, blockedUserIDs: updatedPreferences.blockedUserIDs)
            }
        }
    }
}


