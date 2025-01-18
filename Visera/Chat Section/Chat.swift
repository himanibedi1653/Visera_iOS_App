//
//  Chat.swift
//  ChatApplication
//
//  Created by student-2 on 24/12/24.
//
import Foundation
import UIKit

enum ChatRequestCategory {
    case general
    case business
}

class ChatRequest {
    var id: UUID
    var image: UIImage?
    var name: String
    var message: String
    var time: String
    var category: ChatRequestCategory?

    init(image: UIImage?, name: String, message: String, time: String, category: ChatRequestCategory?) {
        self.id = UUID() // Assign a unique ID
        self.image = image
        self.name = name
        self.message = message
        self.time = time
        self.category = category
    }

    // MARK: Functions
    
    // Update message content
    func updateMessage(newMessage: String) {
        self.message = newMessage
    }
    
    // Update time of the request
    func updateTime(newTime: String) {
        self.time = newTime
    }
    
    // Update category of the request
    func updateCategory(newCategory: ChatRequestCategory) {
        self.category = newCategory
    }
    
    // Get brief description of the request
    func getBriefDescription() -> String {
        return "\(name): \(message)"
    }
    
    // Check if the request belongs to a specific category
    func isCategory(_ category: ChatRequestCategory) -> Bool {
        return self.category == category
    }
}
