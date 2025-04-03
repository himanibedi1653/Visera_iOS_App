////
////  Chats.swift
////  Visera-HomeScreen
////
////  Created by Himani Bedi on 21/01/25.
////
//
//import Foundation
//import UIKit
//// MARK: Chat
//
struct Chat {
    var receiverID: Int
    var messages: [Message]
    var status: ChatStatus
    var isUnread: Bool
    var category: ChatCategory?
}
//
//// MARK: Message
//
//struct Message {
//    var content: String
//    var timestamp: String
//    var isFromMe: Bool
//}
//
enum ChatStatus {
    case request
    case accepted
    case rejected
}

enum ChatCategory {
    case general
    case business
}
//
//enum ChatAction {
//    case block
//    case delete
//    case cancel
//}
//
//// MARK: FUNCTIONS
//
//class UserManager {
//    static let shared = UserManager()
//    
//    private init() {}
//    
//    // MARK: Post Functions
//    
//    func getPostsAlignedWithUserInterests(forUser user: User, allPosts: [Post]) -> [Post] {
//        let userInterests = Set(user.userPreferences.interests.map { $0.rawValue })
//        return allPosts.filter { !Set($0.tags).isDisjoint(with: userInterests) }
//    }
//    
//    func toggleFollowPost(postID: Int, userPosts: inout [Post]) {
//        if let index = userPosts.firstIndex(where: { $0.id == postID }) {
//            userPosts[index].isFollowed.toggle()
//        }
//    }
//    
//    func searchPostsByTagsOrUserID(forUser user: User, keyword: String) -> [Post] {
//        return user.profileData.posts.filter {
//            $0.tags.contains(keyword) || "\($0.userID)".contains(keyword)
//        }
//    }
//    
//    func getSavedPosts(forUser user: User) -> [Post] {
//        return user.profileData.posts.filter { $0.isSaved }
//    }
//    
//    func addToSavedPosts(postID: Int, userPreferences: inout UserPreferences) {
//        if !userPreferences.savedPostIDs.contains(postID) {
//            userPreferences.savedPostIDs.append(postID)
//        }
//    }
//    
//    func removeFromSavedPosts(postID: Int, userPreferences: inout UserPreferences) {
//        userPreferences.savedPostIDs.removeAll { $0 == postID }
//    }
//    
//    
//    
//    // MARK: Function Chats
//    
//    func deleteChat(chatID: Int, userChats: inout [Chat]) {
//        userChats.removeAll { $0.receiverID == chatID }
//    }
//    
//    func performChatAction(chatID: Int, action: ChatAction, userChats: inout [Chat], blockedUserIDs: inout [Int]) {
//        switch action {
//        case .block:
//            if let chat = userChats.first(where: { $0.receiverID == chatID }) {
//                blockedUserIDs.append(chat.receiverID)
//                print("Chat \(chatID) user blocked.")
//            }
//        case .delete:
//            userChats.removeAll { $0.receiverID == chatID }
//            print("Chat \(chatID) deleted.")
//        case .cancel:
//            print("Chat request \(chatID) canceled.")
//        }
//    }
//    
//    func moveChatToCategory(chatID: Int, newCategory: ChatCategory, userChats: inout [Chat]) {
//        if let index = userChats.firstIndex(where: { $0.receiverID == chatID }) {
//            userChats[index].category = newCategory
//        }
//    }
//    
//    func getBusinessChats(forUser user: User) -> [Chat] {
//        return user.profileData.chats.filter { $0.category == .business }
//    }
//
//    func getGeneralChats(forUser user: User) -> [Chat] {
//        return user.profileData.chats.filter { $0.category == .general }
//    }
//
//    func getRequestChats(forUser user: User) -> [Chat] {
//        return user.profileData.chats.filter { $0.status == .request }
//    }
//}
//
//
//
