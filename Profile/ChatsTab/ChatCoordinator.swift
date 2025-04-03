//
//  ChatCoordinator.swift
//  chats
//
//  Created by Divya Arora on 21/03/25.
//


import SwiftUI

// Coordinator to manage communication between views
class ChatCoordinator: ObservableObject {
    static let shared = ChatCoordinator()
    
    @Published var needsRefresh: Bool = false
    
    func didCategorizeRequest(_ request: ChatRequest) {
        // Log the categorization
        print("Coordinator notified: Request \(request.name) categorized as \(request.category?.rawValue ?? "nil")")
        
        // Trigger a refresh
        needsRefresh = true
        
        // Reset the flag after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.needsRefresh = false
        }
    }
}
