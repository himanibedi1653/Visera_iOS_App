import UIKit

// MARK: User
//
//struct User {
//    var userID: Int
//    var basicInfo: BasicInfo
//    var profileData: ProfileData
//    var userPreferences: UserPreferences
//}

// MARK: BasicInfo

struct BasicInfo {
    var name: String
    var userName: String
    var email: String
    var password: String
}

// MARK: ProfileData

//struct ProfileData {
//    var portfolio: URL?
//    var profileImage: UIImage?
//    var followersIDs: [Int]
//    var followingIDs: [Int]
//    var skills: [String]
//    var posts: [Post]
//    var collections: [Collection]
//    var chats: [Chat]
//    var eventsRegistered: [Int]
//}

// MARK: UserPreferences

struct UserPreferences {
    var interests: [Interest]
    var blockedUserIDs: [Int]
    var savedPostIDs: [Int]
}

// MARK: Post

struct Post {
    var id: Int
    var userID: Int
    var tags: [String]
    var postImage: UIImage
    var description: String?
    var createdAt: String
    var crownCount: Int
    var commentIDs: [Int]
    var isSaved: Bool
    var isFollowed: Bool
    var collectionIDs: [Int]
    var isCrowned: Bool
}

// MARK: Collection

struct Collection {
    var id: Int
    var title: String
    var type: CollectionType
    var postIDs: [Int]
}

// MARK: Chat

struct Chat {
    var receiverID: Int
    var messages: [Message]
    var status: ChatStatus
    var isUnread: Bool
    var category: ChatCategory?
}

// MARK: Message

struct Message {
    var content: String
    var timestamp: String
    var isFromMe: Bool
}

// MARK: Event

struct Event {
    var id: Int
    var portraitImage: UIImage
    var landscapeImage: UIImage
    var title: String
    var description: String?
    var registrationLastDate: String?
    var eventDate: String?
    var numberOfRegistrations: Int
    var location: String?
    var additionalInformation: String?
    var dressTheme: String?
    var startingAge: Int?
    var endingAge: Int?
    var gender: [Gender]
    var type: [TypeOfEvent]
    var languages: [String]
    var registrationLink: URL?
}

// MARK: Comment

struct Comment {
    var id: Int
    var userID: Int
    var content: String
    var timestamp: String
}

// MARK: Enums

enum Gender : String {
    case male = "male"
        case female = "female"
        case other = "other"
}

enum Interest: String {
    case hand, promotional, child, plusSize, glamour, hairstylist, alternative
    case lifestyle, editorial, makeupArtist, freelancer, petite, commercial
    case tattooed, fitness, events, highFashion, runway, fashion, agency
    case catalog, beauty, photography
}

enum CollectionType {
    case `private`, `public`
}

enum ChatStatus {
    case request
    case accepted
    case rejected
}

enum ChatCategory {
    case general
    case business
}

enum ChatAction {
    case block
    case delete
    case cancel
}

enum TypeOfEvent: String {
    case hand, promotional, child, plusSize, glamour, hairstylist, alternative
    case lifestyle, editorial, makeupArtist, freelancer, petite, commercial
    case tattooed, fitness, events, highFashion, runway, fashion, agency
    case catalog, beauty, photography
}

// MARK: FUNCTIONS

class UserManager {
    static let shared = UserManager()
    
    private init() {}
    
    // MARK: Post Functions
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
//    // MARK: Function Events
//        
//    func getRegisteredEvents(forUser user: User, events: [Event]) -> [Event] {
//        return events.filter { user.profileData.eventsRegistered.contains($0.id) }
//    }
//    
    func getTrendingEvents(events: [Event]) -> [Event] {
        return events.sorted { $0.numberOfRegistrations > $1.numberOfRegistrations }.prefix(3).map { $0 }
    }
    
    func filterEvents(
        events: [Event],
        type: [TypeOfEvent]? = nil,
        minAge: Int? = nil,
        maxAge: Int? = nil,
        location: String? = nil,
        month: Int? = nil,
        gender: [Gender]? = nil
    ) -> [Event] {
        return events.filter { event in
            // Filter by event type
            let typeMatches = type?.contains(where: { event.type.contains($0) }) ?? true
            
            // Filter by age range
            let ageMatches: Bool
            if let minAge = minAge, let startingAge = event.startingAge {
                ageMatches = startingAge >= minAge
            } else if let maxAge = maxAge, let endingAge = event.endingAge {
                ageMatches = endingAge <= maxAge
            } else {
                ageMatches = true
            }

            // Filter by location
            let locationMatches = location == nil || event.location?.lowercased().contains(location!.lowercased()) == true
            
            // Filter by month (event date)
            let monthMatches = month == nil || {
                guard let eventDate = event.eventDate else { return false }
                let components = eventDate.split(separator: "-")
                guard components.count > 1, let eventMonth = Int(components[1]) else { return false }
                return eventMonth == month
            }()
            
            // Filter by gender preference
            let genderMatches = gender?.contains(where: { event.gender.contains($0) }) ?? event.gender.isEmpty
            
            // Return true if all conditions match
            return typeMatches && ageMatches && locationMatches && monthMatches && genderMatches
        }
    }

    
    func addNewEvent(event: Event, to events: inout [Event]) {
        events.append(event)
    }
    
    // MARK: Function Chats
    
    func deleteChat(chatID: Int, userChats: inout [Chat]) {
        userChats.removeAll { $0.receiverID == chatID }
    }
    
    func performChatAction(chatID: Int, action: ChatAction, userChats: inout [Chat], blockedUserIDs: inout [Int]) {
        switch action {
        case .block:
            if let chat = userChats.first(where: { $0.receiverID == chatID }) {
                blockedUserIDs.append(chat.receiverID)
                print("Chat \(chatID) user blocked.")
            }
        case .delete:
            userChats.removeAll { $0.receiverID == chatID }
            print("Chat \(chatID) deleted.")
        case .cancel:
            print("Chat request \(chatID) canceled.")
        }
    }
    
    func moveChatToCategory(chatID: Int, newCategory: ChatCategory, userChats: inout [Chat]) {
        if let index = userChats.firstIndex(where: { $0.receiverID == chatID }) {
            userChats[index].category = newCategory
        }
    }
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
}
