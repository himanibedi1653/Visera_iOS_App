//
//  Landing Paage.swift
//  Profile
//
//  Created by Himani Bedi on 25/03/25.
//

import SwiftUI
import SwiftUI
struct Landing_Page: View {
    @State private var selectedTab = 0
    @State private var navigateToEventsTab = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Home(navigateToEventsTab: $navigateToEventsTab) // ✅ Pass Binding
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            ContentView()
                .tabItem {
                    Label("Chats", systemImage: "message")
                }
                .tag(1)
            
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "trophy")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(3)
        }
        .onChange(of: navigateToEventsTab) { newValue in
            if newValue {
                selectedTab = 2 // Switch to Events tab
                navigateToEventsTab = false // Reset the flag
            }
        }
        .accentColor(Color(hex: "#B69D53"))
        .tabViewStyle(DefaultTabViewStyle())
    }
}
