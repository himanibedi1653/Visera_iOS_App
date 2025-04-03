//
//  Message.swift
//  chats
//
//  Created by Divya Arora on 21/03/25.
//


import SwiftUI

struct Message: Identifiable, Equatable, Codable {
    let id: UUID
    let content: String
    let isCurrentUser: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), content: String, isCurrentUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isCurrentUser = isCurrentUser
        self.timestamp = timestamp
    }
    
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = TimeZone(identifier: "Asia/Kolkata") ?? TimeZone.current
        return formatter.string(from: timestamp)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case isCurrentUser
        case timestamp
    }
}

struct ChatView: View {
    @ObservedObject var chatRequest: ChatRequest
    @StateObject private var chatModel = ChatRequestModel.shared
    @State private var messageText = ""
    @State private var messages: [Message] = []
    @State private var showingClearChatAlert = false
    @State private var showingBlockUserAlert = false
    @FocusState private var isInputFocused: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat header
            HStack {
                chatRequest.image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(chatRequest.name)
                        .font(.headline)
                    
                    Text(chatRequest.category?.rawValue ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            
            // Messages list
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        if let lastMessage = messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input field
            Divider()
            HStack(spacing: 10) {
                TextField("Type a message...", text: $messageText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .focused($isInputFocused)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(messageText.isEmpty ? .gray : .blue)
                        .padding(10)
                }
                .disabled(messageText.isEmpty)
            }
            .padding()
        }
        .navigationBarTitle(chatRequest.name, displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive) {
                        showingClearChatAlert = true
                    } label: {
                        Label("Clear Chat", systemImage: "trash")
                    }
                    
                    Button(role: .destructive) {
                        showingBlockUserAlert = true
                    } label: {
                        Label("Block User", systemImage: "hand.raised.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.blue)
                }
            }
        }
        .alert("Clear Chat", isPresented: $showingClearChatAlert) {
            Button("Clear", role: .destructive) {
                clearChat()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to clear this chat?")
        }
        .alert("Block User", isPresented: $showingBlockUserAlert) {
            Button("Block", role: .destructive) {
                blockUser()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Blocking this user will prevent future messages and remove the chat. Are you sure?")
        }
        .onAppear {
            loadInitialMessages()
        }
    }
    
    private func clearChat() {
        // Clear messages for this specific chat
        messages.removeAll()
        
        // Remove saved messages for this chat
        let key = "savedMessages_\(chatRequest.id.uuidString)"
        UserDefaults.standard.removeObject(forKey: key)
        
        // Update last message in chat request
        chatRequest.lastMessage = ""
        chatModel.updateLastMessage(forRequestID: chatRequest.id, message: "")
    }
    
    private func blockUser() {
        // Remove messages
        messages.removeAll()
        
        // Remove saved messages
        let key = "savedMessages_\(chatRequest.id.uuidString)"
        UserDefaults.standard.removeObject(forKey: key)
        
        // Remove the chat request
        chatModel.removeChatRequest(byID: chatRequest.id)
        
        // Dismiss the view
        presentationMode.wrappedValue.dismiss()
    }
    private func loadInitialMessages() {
        // Add the initial message from the chat request
        messages.append(Message(
            content: chatRequest.message,
            isCurrentUser: false,
            timestamp: Date().addingTimeInterval(-3600) // 1 hour ago
        ))
        
        // Restore conversation if saved
        loadSavedMessages()
    }
    
    private func loadSavedMessages() {
        let key = "savedMessages_\(chatRequest.id.uuidString)"
        guard let savedData = UserDefaults.standard.data(forKey: key) else { return }
        
        do {
            let decoder = JSONDecoder()
            messages = try decoder.decode([Message].self, from: savedData)
        } catch {
            print("Error loading saved messages: \(error)")
        }
    }
    
    private func saveMessages() {
        let key = "savedMessages_\(chatRequest.id.uuidString)"
        
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(messages)
            UserDefaults.standard.set(encodedData, forKey: key)
        } catch {
            print("Error saving messages: \(error)")
        }
    }
    
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // Add user message
        let userMessage = Message(content: messageText, isCurrentUser: true)
        messages.append(userMessage)
        
        // Update last message in ChatRequest
        chatRequest.lastMessage = messageText
        chatModel.updateLastMessage(forRequestID: chatRequest.id, message: messageText)
        
        // Clear input field
        messageText = ""
        isInputFocused = false
        
        // Save current conversation
        saveMessages()
        
        // Simulate response after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let responseOptions = [
                "Thank you for your message. We'll get back to you soon.",
                "I appreciate your input. Let me check with the team and get back to you.",
                "Thanks for reaching out. We're working on it.",
                "Got it! Is there anything else you need help with?",
                "We'll look into this matter and respond shortly."
            ]
            
            let responseMessage = Message(
                content: responseOptions.randomElement() ?? "Thank you for your message.",
                isCurrentUser: false
            )
            
            messages.append(responseMessage)
            
            // Update last message again with bot's response
            chatRequest.lastMessage = responseMessage.content
            chatModel.updateLastMessage(forRequestID: chatRequest.id, message: responseMessage.content)
            
            // Save updated conversation
            saveMessages()
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isCurrentUser { Spacer() }
            
            VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(message.isCurrentUser ? Color.blue : Color.gray.opacity(0.3))
                    .foregroundColor(message.isCurrentUser ? .white : .black)
                    .cornerRadius(16)
                
                Text(message.formattedTime)
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 4)
            }
            
            if !message.isCurrentUser { Spacer() }
        }
        .padding(.vertical, 4)
    }
}

