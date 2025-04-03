//
//  ProfileApp.swift
//  Profile
//
//  Created by Himani Bedi on 05/03/25.
//

import SwiftUI
import Combine

@main
struct ProfileApp: App {
//    @StateObject private var userDataModel = UserDataModel.shared
    
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(UserDataModel.shared)
        }
    }
}
