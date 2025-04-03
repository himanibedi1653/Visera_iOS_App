//
//  Home.swift
//  Visera
//
//  Created by student2 on 17/03/25.
//
import SwiftUI
import Foundation
import SwiftUI

struct Home: View {

    @ObservedObject var userDataModel = UserDataModel.shared
    @State private var isSearchActive = false
    @Binding var navigateToEventsTab: Bool
    var body: some View {
        NavigationStack { // ✅ Use NavigationStack instead of NavigationView
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    RegisteredEventsView(navigateToEventsTab: $navigateToEventsTab)
                    HomeFeedView(loggedInUserID: userDataModel.currentUser.userID)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 18) {
                        // Search Button (Pushes SearchView to the right)
                        NavigationLink(destination: SearchView(loggedInUserID: userDataModel.currentUser.userID)) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 18))
                                .foregroundColor(Color(hex: "B69D53"))
                        }

                        // Notifications Button with Red Dot
                        ZStack {
                            Button(action: {
                                // Notification action
                            }) {
                                Image(systemName: "bell")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(hex: "B69D53"))
                            }
                        }
                    }
                }
            }
        }
    }
}
