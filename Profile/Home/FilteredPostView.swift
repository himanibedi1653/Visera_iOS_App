//
//  FilteredPostView.swift
//  Visera
//
//  Created by student2 on 19/03/25.
//

import Foundation
import SwiftUI
struct FilteredPostsView: View {
    @Environment(\.presentationMode) var presentationMode
    let category: String
    let filteredPosts: [Post]
    
    var body: some View {
        VStack {
            // Back Button
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .foregroundColor(.blue)
                }
                .padding()

                Spacer()
            }
            
            // Title
            Text("Results for \(category)")
                .font(.title)
                .bold()
                .padding(.bottom, 10)
            
            // Grid View for Images
            if filteredPosts.isEmpty {
                Text("No posts available for this category.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(filteredPosts, id: \.id) { post in
                            Image(uiImage: post.postImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 200)
                                .clipped()
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}
