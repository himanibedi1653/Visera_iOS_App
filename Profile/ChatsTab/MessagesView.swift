//
//  MessagesView.swift
//  chats
//
//  Created by Divya Arora on 21/03/25.
//

import SwiftUI

struct MessagesView: View {
    @State private var messages: [ChatRequest]
    @State private var showingBlockAlert = false
    @State private var showingClearAlert = false
    @State private var showingClearChatsAlert = false
    @State private var showingBlockUserAlert = false
    @State private var selectedMessage: ChatRequest?
    
    init(messages: [ChatRequest]) {
        self._messages = State(initialValue: messages)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(messages) { message in
                    NavigationLink(destination: ChatView(chatRequest: message)) {
                        messageRowView(for: message)
                    }
                    .contextMenu {
                        contextMenuActions(for: message)
                    }
                }
                .onDelete(perform: deleteMessage)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(role: .destructive) {
                            showingClearChatsAlert = true
                        } label: {
                            Label("Clear Chats", systemImage: "trash")
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
            .alert("Clear Chats", isPresented: $showingClearChatsAlert) {
                Button("Clear", role: .destructive) {
                    clearAllChats()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to clear all chats?")
            }
            .alert("Block User", isPresented: $showingBlockUserAlert) {
                Button("Block", role: .destructive) {
                    blockAllUsers()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Blocking all users will remove all chat requests. Are you sure?")
            }
        }
    }
    
    // Helper view for message row
    private func messageRowView(for message: ChatRequest) -> some View {
        HStack(spacing: 12) {
            // Profile Image
            profileImageView(for: message)
            
            // Message Details
            VStack(alignment: .leading, spacing: 4) {
                Text(message.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(message.lastMessage.isEmpty ? message.message : message.lastMessage)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Timestamp
            Text(message.time)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    // Helper view for profile image
    private func profileImageView(for message: ChatRequest) -> some View {
        message.image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            .overlay(
                Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    
    }
    
    // Context menu actions
    private func contextMenuActions(for message: ChatRequest) -> some View {
        Group {
            Button(role: .destructive) {
                selectedMessage = message
                showingBlockAlert = true
            } label: {
                Label("Block User", systemImage: "hand.raised.fill")
            }
            
            Button(role: .destructive) {
                selectedMessage = message
                showingClearAlert = true
            } label: {
                Label("Clear Chats", systemImage: "trash")
            }
        }
    }
    
    // Action methods
    private func blockUser() {
        guard let message = selectedMessage else { return }
        messages.removeAll { $0.id == message.id }
        print("Blocking user: \(message.name)")
    }
    
    private func clearChats() {
        guard let message = selectedMessage else { return }
        messages.removeAll { $0.name == message.name }
        print("Clearing chats for user: \(message.name)")
    }
    
    private func clearAllChats() {
        messages.removeAll()
        print("Clearing all chats")
    }
    
    private func blockAllUsers() {
        messages.removeAll()
        print("Blocking all users")
    }
    
    private func deleteMessage(at offsets: IndexSet) {
        messages.remove(atOffsets: offsets)
    }
}

// Preview struct
struct MessagesView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMessages = [
            ChatRequest(
                image: Image(systemName: "person.circle.fill"),
                name: "John Doe",
                message: "Hey, how are you doing?",
                time: "10:30 AM",
                category: .general
            ),
            ChatRequest(
                image: Image(systemName: "person.circle.fill"),
                name: "Jane Smith",
                message: "Can we discuss the project tomorrow?",
                time: "11:45 AM",
                category: .business
            )
        ]
        
        MessagesView(messages: sampleMessages)
    }
}
