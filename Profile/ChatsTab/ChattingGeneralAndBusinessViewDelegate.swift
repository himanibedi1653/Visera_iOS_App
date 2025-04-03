//
//  ChattingGeneralAndBusinessViewDelegate.swift
//  chats
//
//  Created by Divya Arora on 21/03/25.
//


import SwiftUI

// Protocol to communicate with parent views
protocol ChattingGeneralAndBusinessViewDelegate: AnyObject {
    func updateLastMessage(newMessage: String)
    func updateChatTime(newTime: String)
}

struct ChattingGeneralAndBusinessView: View {
    // Weak reference to delegate to avoid retain cycles
    weak var delegate: (any ChattingGeneralAndBusinessViewDelegate)?
    
    // Properties
    let chatImage: Image?
    let chatName: String
    
    @State private var messages: [Message] = []
    @State private var currentUserInput: String = ""
    @State private var predefinedResponses = [
        "Hi there! How can I assist you today?",
        "Sure, I can help with that.",
        "Let me check that for you.",
        "Can you provide more details?",
        "Thank you for your patience!"
    ]
    @State private var responseIndex = 0
    @State private var chatTime: String
    @State private var isNewSession = true
    @State private var showClearAlert = false
    
    // Convenience initializer
    init(
        delegate: (any ChattingGeneralAndBusinessViewDelegate)? = nil,
        chatImage: Image? = nil,
        chatName: String,
        initialMessages: [Message] = [],
        chatTime: String = ""
    ) {
        self.delegate = delegate
        self.chatImage = chatImage
        self.chatName = chatName
        self._messages = State(initialValue: initialMessages)
        self._chatTime = State(initialValue: chatTime)
    }
    
    var body: some View {
        VStack {
            // Header
            headerView
            
            // Chat Messages
            messagesView
            
            // Message Input
            messageInputView
        }
        .onAppear(perform: onAppearActions)
        .alert("Clear All Chats", isPresented: $showClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                clearMessages()
            }
        } message: {
            Text("Are you sure you want to clear all messages?")
        }
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        HStack {
            chatImage?
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(chatName)
                    .font(.headline)
                
                if !chatTime.isEmpty {
                    Text("Last message at: \(chatTime)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button("Clear All Chats") {
                showClearAlert = true
            }
            .buttonStyle(.borderless)
        }
        .padding()
    }
    
    private var messagesView: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                LazyVStack {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal)
            }
            .onChange(of: messages) { oldValue, newValue in
                scrollToLastMessage(using: scrollView)
            }
        }
    }
    
    private var messageInputView: some View {
        HStack {
            TextField("Type a message...", text: $currentUserInput)
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .onSubmit(sendMessage)
            
            Button(action: sendMessage) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.blue)
                    .padding(10)
            }
        }
        .padding()
    }
    
    // MARK: - Helper Methods
    
    private func onAppearActions() {
        loadMessagesFromUserDefaults()
        isNewSession = false
        if messages.isEmpty {
            simulateFirstMessage()
        }
    }
    
    private func scrollToLastMessage(using scrollView: ScrollViewProxy) {
        if let lastMessage = messages.last {
            scrollView.scrollTo(lastMessage.id, anchor: .bottom)
        }
    }
    
    private func simulateFirstMessage() {
        guard responseIndex < predefinedResponses.count else { return }
        let firstMessage = predefinedResponses[responseIndex]
        responseIndex += 1
        let message = Message(content: firstMessage, isCurrentUser: false, timestamp: Date())
        messages.append(message)
        
        if !isNewSession {
            saveMessagesToUserDefaults()
        }
    }
    
    private func sendMessage() {
        guard !currentUserInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let currentTime = getCurrentTime()
        
        let userMessage = Message(content: currentUserInput, isCurrentUser: true, timestamp: Date())
        messages.append(userMessage)
        currentUserInput = ""
        
        delegate?.updateChatTime(newTime: currentTime)
        
        simulateOtherUserResponse(time: currentTime)
        
        if !isNewSession {
            saveMessagesToUserDefaults()
        }
        
        if responseIndex > 0 && responseIndex <= predefinedResponses.count {
            let lastPredefinedMessage = predefinedResponses[responseIndex - 1]
            delegate?.updateLastMessage(newMessage: lastPredefinedMessage)
        }
    }
    
    private func simulateOtherUserResponse(time: String) {
        guard responseIndex < predefinedResponses.count else { return }
        
        let response = predefinedResponses[responseIndex]
        responseIndex += 1
        
        // Simulate delayed response
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let responseMessage = Message(content: response, isCurrentUser: false, timestamp: Date())
            messages.append(responseMessage)
            
            delegate?.updateChatTime(newTime: time)
            
            if !isNewSession {
                saveMessagesToUserDefaults()
            }
        }
    }
    
    private func clearMessages() {
        messages.removeAll()
        let uniqueKey = "chatMessages_\(chatName)"
        UserDefaults.standard.removeObject(forKey: uniqueKey)
    }
    
    private func saveMessagesToUserDefaults() {
        let uniqueKey = "chatMessages_\(chatName)"
        let messageArray = messages.map { [
            "text": $0.content,
            "isCurrentUser": $0.isCurrentUser,
            "timestamp": $0.timestamp.timeIntervalSince1970
        ] }
        UserDefaults.standard.set(messageArray, forKey: uniqueKey)
    }
    
    private func loadMessagesFromUserDefaults() {
        let uniqueKey = "chatMessages_\(chatName)"
        
        if let savedMessages = UserDefaults.standard.array(forKey: uniqueKey) as? [[String: Any]] {
            messages = savedMessages.compactMap { messageDict -> Message? in
                guard
                    let content = messageDict["text"] as? String,
                    let isCurrentUser = messageDict["isCurrentUser"] as? Bool,
                    let timestamp = messageDict["timestamp"] as? TimeInterval
                else { return nil }
                
                return Message(
                    content: content,
                    isCurrentUser: isCurrentUser,
                    timestamp: Date(timeIntervalSince1970: timestamp)
                )
            }
        }
    }
    
    private func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: Date())
    }
}
