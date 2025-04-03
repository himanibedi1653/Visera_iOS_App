//
//  FollowersFollowingView.swift
//  Profile
//
//  Created by Himani Bedi on 24/03/25.
//

import SwiftUI

struct FollowersFollowingView: View {
    @StateObject private var userDataModel = UserDataModel.shared
    @State private var selectedTab: String
    private let user: User
    
    // Initialize with the tab that should be selected initially
    init(user: User, initialTab: String = "Followers") {
        self.user = user
        self._selectedTab = State(initialValue: initialTab)
    }
    
    var body: some View {
        VStack {
            // Segmented control for switching between Followers and Following
            Picker("", selection: $selectedTab) {
                Text("Followers").tag("Followers")
                Text("Following").tag("Following")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .padding(.top)
            
            // Content based on selected tab
            if selectedTab == "Followers" {
                FollowersList(user: user)
            } else {
                FollowingList(user: user)
            }
        }
        .navigationTitle("Connections")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FollowersList: View {
    @StateObject private var userDataModel = UserDataModel.shared
    let user: User
    
    var body: some View {
        if userDataModel.getNumberOfFollowers(forUser: user) == 0 {
            VStack {
                Spacer()
                Text("No followers yet")
                    .font(.title2)
                    .foregroundColor(.gray)
                Spacer()
            }
        } else {
            List {
                ForEach(user.profileData.followersIDs, id: \.self) { followerID in
                    if let follower = userDataModel.getUser(byID: followerID) {
                        NavigationLink(destination: OtherUserProfileView(user: follower)) {
                            UserRow(user: follower)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct FollowingList: View {
    @StateObject private var userDataModel = UserDataModel.shared
    let user: User
    @State private var showingUnfollowAlert = false
    @State private var selectedUserID: Int?
    
    var body: some View {
        if userDataModel.getNumberOfFollowing(forUser: user) == 0 {
            VStack {
                Spacer()
                Text("Not following anyone yet")
                    .font(.title2)
                    .foregroundColor(.gray)
                Spacer()
            }
        } else {
            List {
                ForEach(user.profileData.followingIDs, id: \.self) { followingID in
                    if let following = userDataModel.getUser(byID: followingID) {
                        HStack {
                            NavigationLink(destination: OtherUserProfileView(user: following)) {
                                UserRow(user: following)
                            }
                            
                            Spacer()
                            
                            // Only show unfollow button if viewing current user's following list
                            if user.userID == userDataModel.currentUser.userID {
                                Button(action: {
                                    selectedUserID = followingID
                                    showingUnfollowAlert = true
                                }) {
                                    Text("Unfollow")
                                        .foregroundColor(.red)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(
                                            RoundedRectangle(cornerRadius: 5)
                                                .strokeBorder(Color.red, lineWidth: 1)
                                        )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
            .alert(isPresented: $showingUnfollowAlert) {
                Alert(
                    title: Text("Unfollow"),
                    message: Text("Are you sure you want to unfollow this user?"),
                    primaryButton: .destructive(Text("Unfollow")) {
                        if let id = selectedUserID {
                            userDataModel.toggleFollow(currentUserID: userDataModel.currentUser.userID, targetUserID: id)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}

struct UserRow: View {
    let user: User
    @StateObject private var userDataModel = UserDataModel.shared
    
    var body: some View {
        HStack(spacing: 12) {
            // Profile Image
            if let profileImage = userDataModel.getUserImage(forUser: user) {
                Image(uiImage: profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color("B69D53"), lineWidth: 1)
                    )
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color.gray)
            }
            
            // User Information
            VStack(alignment: .leading, spacing: 4) {
                Text(userDataModel.getUserName(forUser: user))
                    .font(.headline)
                
                Text("@\(userDataModel.getUserHandle(forUser: user))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

// This view is for viewing other user profiles
struct OtherUserProfileView: View {
    let user: User
    @StateObject private var userDataModel = UserDataModel.shared
    @State private var isFollowing: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                // Profile header
                VStack {
                    if let profileImage = userDataModel.getUserImage(forUser: user) {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color("B69D53"), lineWidth: 2)
                            )
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.gray)
                    }
                    
                    Text(userDataModel.getUserName(forUser: user))
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("@\(userDataModel.getUserHandle(forUser: user))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(userDataModel.getUserSkills(forUser: user).joined(separator: " | "))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 2)
                    
                    // Follow/Unfollow button
                    Button(action: {
                        userDataModel.toggleFollow(currentUserID: userDataModel.currentUser.userID, targetUserID: user.userID)
                        isFollowing.toggle()
                    }) {
                        Text(isFollowing ? "Unfollow" : "Follow")
                            .font(.headline)
                            .foregroundColor(isFollowing ? .white : Color("B69D53"))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 8)
                        if isFollowing {
                            Text("Unfollow")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                                .background(Color(hex: "B69D53"))
                                .cornerRadius(20)
                        } else {
                            Text("Follow")
                                .font(.headline)
                                .foregroundColor(Color("B69D53"))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color("B69D53"), lineWidth: 2)
                                )
                        }
                    }
                    .padding(.top, 8)
                    
                    HStack(spacing: 40) {
                        NavigationLink(destination: FollowersFollowingView(user: user, initialTab: "Followers")) {
                            VStack {
                                Text("\(userDataModel.getNumberOfFollowers(forUser: user))")
                                    .font(.title3)
                                    .bold()
                                Text("Followers")
                                    .font(.caption)
                            }
                        }
                        
                        NavigationLink(destination: FollowersFollowingView(user: user, initialTab: "Following")) {
                            VStack {
                                Text("\(userDataModel.getNumberOfFollowing(forUser: user))")
                                    .font(.title3)
                                    .bold()
                                Text("Following")
                                    .font(.caption)
                            }
                        }
                        
                        VStack {
                            Text("\(userDataModel.getNumberOfPosts(forUser: user))")
                                .font(.title3)
                                .bold()
                            Text("Posts")
                                .font(.caption)
                        }
                    }
                    .padding(.top, 12)
                }
                .padding()
                
                // Posts
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 5) {
                    ForEach(userDataModel.getAllPosts(forUser: user), id: \.id) { post in
                        Image(uiImage: post.postImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipped()
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Check if the current user is following this user
            isFollowing = userDataModel.currentUser.profileData.followingIDs.contains(user.userID)
        }
    }
}
