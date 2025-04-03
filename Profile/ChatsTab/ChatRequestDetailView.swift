//
//  ChatRequestDetailView.swift
//  chats
//
//  Created by Divya Arora on 21/03/25.
//

import SwiftUI

struct ChatRequestDetailView: View {
    // Static gold color definition
    static let highlightGold = Color(red: 187/255, green: 155/255, blue: 90/255)
    
    @ObservedObject var chatRequest: ChatRequest
    @ObservedObject var chatModel = ChatRequestModel.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var showingCategoryAlert = false
    @State private var showingRejectAlert = false
    @State private var showingClearChatsAlert = false
    @State private var showingBlockUserAlert = false
    @State private var animateProfile = false
    
    @EnvironmentObject var coordinator: ChatCoordinator
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ScrollView {
                    VStack(alignment: .center, spacing: 24) {
                        // Profile Section
                        VStack {
                            ZStack {
                                Circle()
                                    .fill(Self.highlightGold.opacity(0.1))
                                    .frame(width: 140, height: 140)
                                
                                chatRequest.image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 130, height: 130)
                                    .clipShape(Circle())
                                    .shadow(color: Self.highlightGold.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            
                            Text(chatRequest.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Self.highlightGold)
                                .padding(.top, 8)
                            
                            Text("New Chat Request")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(Self.highlightGold.opacity(0.1))
                                )
                        }
                        
                        // Message Container
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Message")
                                    .font(.headline)
                                    .foregroundColor(Self.highlightGold)
                                
                                Spacer()
                                
                                Text(Date(), style: .date)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Text(chatRequest.message)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .background(Self.highlightGold.opacity(0.05))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Self.highlightGold.opacity(0.2), lineWidth: 1)
                                )
                        }
                        
                        // Spacer to push buttons to bottom
                        Spacer()
                    }
                    .padding()
                }
                
                // Action Buttons at the Bottom
                VStack(spacing: 16) {
                    Button(action: { showingCategoryAlert = true }) {
                        Text("Accept Request")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Self.highlightGold)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    
                    Button(action: { showingRejectAlert = true }) {
                        Text("Decline Request")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Self.highlightGold.opacity(0.1))
                            .foregroundColor(Self.highlightGold)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Self.highlightGold.opacity(0.3), lineWidth: 1)
                            )
                    }
                }
                .padding()
                .background(Color(UIColor.systemBackground))
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .navigationTitle("Chat Request")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(role: .destructive, action: {
                        showingClearChatsAlert = true
                    }) {
                        Label("Clear Chats", systemImage: "trash")
                    }
                    
                    Button(role: .destructive, action: {
                        showingBlockUserAlert = true
                    }) {
                        Label("Block User", systemImage: "hand.raised.fill")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Self.highlightGold)
                }
            }
        }
        .alert("Clear Chats", isPresented: $showingClearChatsAlert) {
            Button("Clear", role: .destructive) {
                clearChats()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to clear all chats with this user?")
        }
        .alert("Block User", isPresented: $showingBlockUserAlert) {
            Button("Block", role: .destructive) {
                blockUser()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Blocking this user will prevent future messages and remove the chat request. Are you sure?")
        }
        .alert("Categorize Request", isPresented: $showingCategoryAlert) {
            Button("General") {
                categorizeRequest(as: .general)
            }
            Button("Business") {
                categorizeRequest(as: .business)
            }
        } message: {
            Text("Please choose a category")
        }
        .actionSheet(isPresented: $showingRejectAlert) {
            ActionSheet(
                title: Text("Decline Request"),
                message: Text("Are you sure you want to decline this chat request? This action cannot be undone."),
                buttons: [
                    .destructive(Text("Decline")) {
                        withAnimation {
                            chatModel.removeChatRequest(byID: chatRequest.id)
                            presentationMode.wrappedValue.dismiss()
                        }
                    },
                    .cancel()
                ]
            )
        }
    }
    
    // Existing methods remain the same
    private func categorizeRequest(as category: ChatRequestCategory) {
        print("Categorizing request \(chatRequest.name) as \(category.rawValue)")
        
        chatModel.categorizeRequest(chatRequest, as: category)
        coordinator.didCategorizeRequest(chatRequest)
        
        withAnimation {
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func clearChats() {
        print("Clearing chats for \(chatRequest.name)")
    }
    
    private func blockUser() {
        withAnimation {
            chatModel.removeChatRequest(byID: chatRequest.id)
            print("Blocking user \(chatRequest.name)")
            presentationMode.wrappedValue.dismiss()
        }
    }
}
