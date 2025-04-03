
//
//  SearchView.swift
//  Visera
//
//  Created by student2 on 19/03/25.
//
import SwiftUI
import Foundation

struct SearchView: View {
    @ObservedObject private var userDataModel = UserDataModel.shared
    @State private var searchText: String
    @State private var matchingUsers: [User] = []
    @State private var searchedImages: [Post] = []
    @State private var showNoMatchMessage: Bool = false
    @State private var selectedPost: Post?
    @State private var selectedUser: User?
    @State private var isLoading: Bool = false  // Added loading state

    let loggedInUserID: Int
    let suggestedTags = ["Lifestyle", "Runway", "Fitness", "Hairstyling", "Makeup", "Hand"]

    init(loggedInUserID: Int, searchQuery: String = "") {
        self.loggedInUserID = loggedInUserID
        _searchText = State(initialValue: searchQuery)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search models or tags", text: $searchText, onCommit: performSearch)
                    .foregroundColor(.black)

                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                        matchingUsers = []
                        searchedImages = []
                        showNoMatchMessage = false
                        isLoading = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)

            Text("Trending Tags")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.top, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(suggestedTags, id: \.self) { tag in
                        Button(action: {
                            searchText = tag
                            performSearch()
                        }) {
                            Text(tag)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.black)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(.systemGray4))
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.horizontal)
            }

            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
            } else {
                if showNoMatchMessage {
                    Text("No match found")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                if !matchingUsers.isEmpty {
                    Text("Matching Users")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 5)

                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(matchingUsers, id: \.userID) { user in
                                NavigationLink(destination: HomeProfileView(user: user, currentUserID: loggedInUserID)) {
                                    HStack {
                                        if let profileImage = user.profileData.profileImage {
                                            Image(uiImage: profileImage)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        }
                                        Text(user.basicInfo.name)
                                            .font(.body)
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 250)
                }

                if !searchedImages.isEmpty {
                    Text("Matching Posts")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 5)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                            ForEach(searchedImages, id: \.id) { post in
                                Button(action: {
                                    selectedPost = post
                                }) {
                                    Image(uiImage: post.postImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 150)
                                        .clipped()
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }

            Spacer()
        }
        .navigationTitle("Search")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedPost) { post in
            HomePostDetailView(post: post)
        }
        .onAppear {
            performSearch()
        }
    }

    private func performSearch() {
        guard !searchText.isEmpty else {
            matchingUsers = []
            searchedImages = []
            showNoMatchMessage = false
            return
        }

        isLoading = true  // Start loading
        
        DispatchQueue.global(qos: .userInitiated).async {
            let users = userDataModel.searchUsers(byName: searchText)
                .filter { $0.userID != loggedInUserID }
            let posts = userDataModel.searchPostsByTag(tag: searchText)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Simulated delay
                matchingUsers = users
                searchedImages = posts
                showNoMatchMessage = matchingUsers.isEmpty && searchedImages.isEmpty
                isLoading = false  // Stop loading
            }
        }
    }
}
