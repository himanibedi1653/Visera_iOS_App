//
//  ChatRequestCategory 2.swift
//  chats
//
//  Created by Divya Arora on 21/03/25.
//
import Foundation
import SwiftUI

// Enum for ChatRequest category to define categories for the chat requests
enum ChatRequestCategory: String, CaseIterable, Codable {
    case general = "General"
    case business = "Business"
}

// ChatRequest class that represents each chat request
class ChatRequest: Identifiable, ObservableObject, Codable {
    let id: UUID
    @Published var image: Image  // Changed from Image? to Image
    @Published var name: String
    @Published var message: String
    @Published var time: String
    @Published var category: ChatRequestCategory?
    @Published var lastMessage: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id, name, message, time, category, lastMessage, image
    }
    
    init(image: Image = Image(systemName: "person.circle.fill"), name: String, message: String, time: String, category: ChatRequestCategory?) {
        self.id = UUID() // Assign a unique ID
        self.image = image
        self.name = name
        self.message = message
        self.time = time
        self.category = category
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        message = try container.decode(String.self, forKey: .message)
        time = try container.decode(String.self, forKey: .time)
        category = try container.decodeIfPresent(ChatRequestCategory.self, forKey: .category)
        lastMessage = try container.decodeIfPresent(String.self, forKey: .lastMessage) ?? ""
        
        // Provide a default image if not found during decoding
        image = Image(systemName: "person.circle.fill")
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(message, forKey: .message)
        try container.encode(time, forKey: .time)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encode(lastMessage, forKey: .lastMessage)
        // Note: Image encoding is not straightforward and may require a different approach
    }
    
    // Custom initializer to allow image to be ignored during initialization
    static func createWithoutImage(name: String, message: String, time: String, category: ChatRequestCategory?) -> ChatRequest {
        return ChatRequest(image: Image(systemName: "person.circle.fill"), name: name, message: message, time: time, category: category)
    }
}

// ChatRequestModel class that manages an array of ChatRequest objects
class ChatRequestModel: ObservableObject {
    static let shared = ChatRequestModel() // Singleton instance for shared access
    @Published var chatRequests: [ChatRequest] = []
    @Published var businessRequests: [ChatRequest] = []
    @Published var generalRequests: [ChatRequest] = []
    @Published var pendingRequests: [ChatRequest] = []
    
    static var loadingFirstTime = true
    private let defaults = UserDefaults.standard
    private let requestsKey = "savedChatRequests"

    // Initial dummy chat requests to populate data
    private init() {
        loadChatRequests()
        if chatRequests.isEmpty {
            populateInitialRequests()
        }
    }

    private func populateInitialRequests() {
        // Using SF Symbols for placeholder images
        let initialRequests = [
            ChatRequest(image: Image(systemName: "person.circle.fill"), name: "Agency 1", message: "Good afternoon, we would like to discuss our latest business proposal with you.", time: "12:30 PM", category: nil),
            ChatRequest(image: Image(systemName: "person.circle.fill"), name: "Agency 2", message: "I hope all is well. Let us know if you'd like to discuss the current market trends.", time: "1:00 PM", category: nil),
            ChatRequest(image: Image(systemName: "person.circle.fill"), name: "Agency 3", message: "We have some important updates regarding the partnership agreement we discussed.", time: "2:15 PM", category: nil),
            ChatRequest(image: Image(systemName: "person.circle.fill"), name: "Agency 4", message: "It was great speaking with you last time. Looking forward to hearing more from your side.", time: "12:30 PM", category: nil),
            ChatRequest(image: Image(systemName: "building.2.fill"), name: "Agency 5", message: "If there's anything we can assist with regarding the project, feel free to let us know.", time: "1:00 PM", category: nil),
            ChatRequest(image: Image(systemName: "building.2.fill"), name: "Agency 6", message: "We're ready to proceed with our discussions whenever you're available. Let's plan a meeting soon.", time: "2:15 PM", category: nil)
        ]
        
        chatRequests = initialRequests
        updateCategorizedLists()
        saveChatRequests()
    }

    // Add a new chat request
    func addChatRequest(chatRequest: ChatRequest) {
        chatRequests.append(chatRequest)
        updateCategorizedLists()
        saveChatRequests()
    }
    
    // Update the last message for a specific chat request
    func updateLastMessage(forRequestID id: UUID, message: String) {
        if let index = chatRequests.firstIndex(where: { $0.id == id }) {
            chatRequests[index].lastMessage = message
            saveChatRequests()
        }
    }
    
    // Save chat requests to UserDefaults
    func saveChatRequests() {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(chatRequests)
            defaults.set(encodedData, forKey: requestsKey)
            
            updateCategorizedLists()
        } catch {
            print("Error saving chat requests: \(error)")
        }
    }
    
    // Load chat requests from UserDefaults
    func loadChatRequests() {
        guard let savedData = defaults.data(forKey: requestsKey) else { return }
        
        do {
            let decoder = JSONDecoder()
            let savedRequests = try decoder.decode([ChatRequest].self, from: savedData)
            chatRequests = savedRequests
            updateCategorizedLists()
        } catch {
            print("Error loading chat requests: \(error)")
        }
    }
    
    // Get all chat requests
    func getAllChatRequests() -> [ChatRequest] {
        return chatRequests
    }
    
    // Get chat requests by category
    func getChatRequests(byCategory category: ChatRequestCategory) -> [ChatRequest] {
        return chatRequests.filter { $0.category == category }
    }
    
    // Remove a chat request by ID
    func removeChatRequest(byID id: UUID) {
        if let index = chatRequests.firstIndex(where: { $0.id == id }) {
            print("Removing request at index: \(index)")
            chatRequests.remove(at: index)
            updateCategorizedLists()
            saveChatRequests()
        }
    }
    
    // Update a chat request by ID
    func updateChatRequest(byID id: UUID, with newRequest: ChatRequest) {
        if let index = chatRequests.firstIndex(where: { $0.id == id }) {
            chatRequests[index] = newRequest
            updateCategorizedLists()
            saveChatRequests()
        }
    }
    
    // Categorize a chat request
    func categorizeRequest(_ request: ChatRequest, as category: ChatRequestCategory) {
        if let index = chatRequests.firstIndex(where: { $0.id == request.id }) {
            chatRequests[index].category = category
            updateCategorizedLists()
            print("Categorized request \(request.name) as \(category)")
            saveChatRequests()
        }
    }
    
    // Update the categorized lists
    private func updateCategorizedLists() {
        businessRequests = chatRequests.filter { $0.category == .business }
        generalRequests = chatRequests.filter { $0.category == .general }
        updatePendingRequests()
    }
    
    // Update pending requests
    private func updatePendingRequests() {
        pendingRequests = chatRequests.filter { $0.category == nil }
    }
}
