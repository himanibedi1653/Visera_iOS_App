//
//  ChatListView 2.swift
//  chats
//
//  Created by Divya Arora on 21/03/25.
//

import SwiftUI

struct ChatListView: View {
    @StateObject var chatModel = ChatRequestModel.shared
    @State private var selectedSegment = 0 // For General/Business segmented control
    @State private var searchText = "" // For search functionality
    static let highlightGold = Color(red: 187/255, green: 155/255, blue: 90/255)
    var body: some View {
        NavigationView {
            VStack {
                // Search bar with icon inside
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.systemGray6))
                        .frame(height: 36)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                        
                        TextField("Search chats", text: $searchText)
                            .font(.system(size: 15))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Segmented control for General and Business
                Picker("Category", selection: $selectedSegment) {
                    Text("General").tag(0)
                    Text("Business").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Tab content based on segmented control
                if selectedSegment == 0 {
                    CategoryChatList(
                        requests: chatModel.generalRequests.filter {
                            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) ||
                            $0.message.localizedCaseInsensitiveContains(searchText)
                        },
                        category: .general
                    )
                } else {
                    CategoryChatList(
                        requests: chatModel.businessRequests.filter {
                            searchText.isEmpty || $0.name.localizedCaseInsensitiveContains(searchText) ||
                            $0.message.localizedCaseInsensitiveContains(searchText)
                        },
                        category: .business
                    )
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.large) // Large title style
            .navigationBarItems(trailing:
                NavigationLink(destination: ChatRequestsView()) {
                    Text("Requests")
                    .foregroundColor(Self.highlightGold)
                }
            )
            .onAppear {
                // Print debug information
                print("------------------------------Count before loading the screen \(chatModel.pendingRequests.count)")
                
                if ChatRequestModel.loadingFirstTime {
                    print("Loaded requests from ChatRequestModel")
                    ChatRequestModel.loadingFirstTime = false
                }
                
                print("------------------------------Count after loading the screen \(chatModel.pendingRequests.count)")
            }
        }
    }
}

struct ChatRequestsView: View {
    @ObservedObject var chatModel = ChatRequestModel.shared
    
    var body: some View {
        List {
            ForEach(chatModel.pendingRequests) { request in
                NavigationLink(destination: ChatRequestDetailView(chatRequest: request)) {
                    ChatRequestRow(request: request)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Chat Request")
    }
}


struct CategoryChatList: View {
    var requests: [ChatRequest]
    var category: ChatRequestCategory
    
    var body: some View {
        List {
            ForEach(requests) { request in
                NavigationLink(destination: ChatView(chatRequest: request)) {
                    BusinessOrGeneralChatRow(request: request)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}



struct ChatRequestRow: View {
    @ObservedObject var request: ChatRequest
    
    var body: some View {
        HStack(spacing: 12) {
            request.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(request.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(request.message)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(request.time)
                .font(.caption)
                .foregroundColor(.gray)
                .alignmentGuide(.top) { _ in 0 }
        }
        .padding(.vertical, 6)
    }
}
struct BusinessOrGeneralChatRow: View {
    @ObservedObject var request: ChatRequest
    
    var body: some View {
        HStack(spacing: 12) {
            request.image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.blue.opacity(0.3), lineWidth: 2)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(request.name)
                    .font(.headline)
                    .lineLimit(1)
                
                Text(request.lastMessage.isEmpty ? request.message : request.lastMessage)
                    .font(.subheadline)
                    .lineLimit(2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(request.time)
                .font(.caption)
                .foregroundColor(.gray)
                .alignmentGuide(.top) { _ in 0 }
        }
        .padding(.vertical, 8)
    }
}
// Preview for SwiftUI Canvas
struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        ChatListView()
    }
}
