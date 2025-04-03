//
//  ContentView.swift
//  chats
//
//  Created by Divya Arora on 21/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = ChatCoordinator.shared
    
    var body: some View {
        ChatListView()
            .environmentObject(coordinator)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
