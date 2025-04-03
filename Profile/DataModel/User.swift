//
//  User.swift
//  Profile
//
//  Created by Himani Bedi on 05/03/25.
//

import Foundation
import UIKit
import SwiftUI

// MARK: User Data
class User: Identifiable, ObservableObject {
    var id: Int { userID }
    
    let userID: Int
    var basicInfo: BasicInfo
    @Published var profileData: ProfileData
    var userPreferences: UserPreferences

    init(userID: Int, basicInfo: BasicInfo, profileData: ProfileData, userPreferences: UserPreferences) {
        self.userID = userID
        self.basicInfo = basicInfo
        self.profileData = profileData
        self.userPreferences = userPreferences
    }
}

struct BasicInfo {
    var name: String
    var userName: String
    var email: String
    var password: String
}

struct UserPreferences {
    var interests: [Interest]
    var blockedUserIDs: [Int]
    var savedPostIDs: [Int]
    var notificationButton : Bool
}

enum Interest: String {
    case hand, promotional, child, plusSize, glamour, hairstylist, alternative
    case lifestyle, editorial, makeupArtist, freelancer, petite, commercial
    case tattooed, fitness, events, highFashion, runway, fashion, agency
    case catalog, beauty, photography
}


// MARK: Profile Data

struct ProfileData {
    var portfolio: URL?
    var profileImage: UIImage?
    var followersIDs: [Int]
    var followingIDs: [Int]
    var skills: [String]
    var posts: [Post]
    var collections: [Collection]
    var chats: [Chat]
    var eventsRegistered: [Int]
}

struct Post:Identifiable {
    var id: Int
    var userID: Int
    var tags: [String]
    var postImage: UIImage
    var description: String?

    var createdAt: String
    var crownCount: Int
    var comments: [Comment]
    var isSaved: Bool
    var isFollowed: Bool
    var collectionIDs: [Int]
    var isCrowned: Bool
}

// MARK: Comment

struct Comment{
    var userID: Int
    var content: String
    var timestamp: String
}

struct Collection {
    var id: Int
    var title: String
    var type: CollectionType
    var postIDs: [Int]
    var createdAt: String
}

enum CollectionType {
    case `private`, `public`
}




let user1 = User(
    userID: 1,
    basicInfo: BasicInfo(
        name: "Alice Johnson",
        userName: "alice_j",
        email: "alice.johnson@example.com",
        password: "password123"
        // https://www.demilanigan.com
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://www.avamariecolonna.com"),
        profileImage: UIImage(named: "model1"),
        followersIDs: [2, 3, 4],
        followingIDs: [5, 6, 7],
        skills: ["Modeling", "Photography" ,"Fashion"],
        posts: [
            Post(
                id: 101,
                userID: 1,
                tags: ["fashion", "lifestyle", "beauty", "makeup", "event", "runway"],
                postImage: UIImage(named: "post1")!,
                description: "I got to work with one of the best fashion designers in the world! Check out this incredible collection! Where I slay the runway!",
                createdAt: "2025-01-01",
                crownCount: 15,
                comments: [
                    Comment(userID: 2, content: "Amazing outfit!", timestamp: "2025-01-02"),
                    Comment(userID: 3, content: "You look stunning!💖", timestamp: "2025-01-02"),
                    Comment(userID: 4, content: "This shot is breathtaking! The composition in your posture, and the way the outfit complements the background🔥", timestamp: "2025-01-02"),
                    Comment(userID: 5, content: "You make modeling look effortless! 💯", timestamp: "2025-01-02"),
                    Comment(userID: 6, content: "Wow! This photo radiates strength, grace, and a fierce attitude. It’s clear that you don’t just pose for the camera—you tell a story with every shot. Truly inspiring! 💖", timestamp: "2025-01-02"),
                    Comment(userID: 7, content: "Truly a masterpiece! Keep inspiring! ", timestamp: "2025-01-02"),
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [],
                isCrowned: false
            ),
            Post(
                id: 102,
                userID: 1,
                tags: ["fashion", "lifestyle"],
                postImage: UIImage(named: "post2")!,
                description: "Elegance is an attitude. ✨ #EditorialMagic",
                createdAt: "2025-01-01",
                crownCount: 13,
                comments: [
                    Comment(userID: 2, content: "This look is everything! 💖", timestamp: "2025-01-02"),
                    Comment(userID: 4, content: "Killing it as always!", timestamp: "2025-01-03")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [1],
                isCrowned: false
            ),
            Post(
                id: 103,
                userID: 1,
                tags: ["Modeling", "lifestyle"],
                postImage: UIImage(named: "post3")!,
                description: "Chasing dreams, one photoshoot at a time. 📸✨",
                createdAt: "2025-01-01",
                crownCount: 12,
                comments: [
                    Comment(userID: 5, content: "The confidence in this shot is unmatched! 😍", timestamp: "2025-01-02"),
                    Comment(userID: 6, content: "Serving elegance and grace. ✨!", timestamp: "2025-01-03")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [],
                isCrowned: false
            ),
            Post(
                id: 104,
                userID: 1,
                tags: ["Runway", "Event"],
                postImage: UIImage(named: "post4")!,
                description: "Confidence is the best outfit. Own it! 💃",
                createdAt: "2025-01-01",
                crownCount: 25,
                comments: [
                    Comment(userID: 7, content: "Your poses are always on point! 📸", timestamp: "2025-01-02"),
                    Comment(userID: 8, content: "Wow, the lighting in this photo is perfect! ☀️", timestamp: "2025-01-03")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [1],
                isCrowned: false
            ),
            Post(
                id: 105,
                userID: 1,
                tags: ["Event", "Makeup"],
                postImage: UIImage(named: "post5")!,
                description: "Bringing art to life with every frame. 🎨",
                createdAt: "2025-01-01",
                crownCount: 29,
                comments: [
                    Comment(userID: 9, content: "Love how this outfit complements you! 🔥", timestamp: "2025-01-02"),
                    Comment(userID: 10, content: "Such a powerful expression! 💪", timestamp: "2025-01-03")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [],
                isCrowned: false
            ),
            Post(
                id: 106,
                userID: 1,
                tags: ["Hairstyling", "Makeup"],
                postImage: UIImage(named: "post24")!,
                description: "A little bit of attitude, a whole lot of style! 😏",
                createdAt: "2025-01-01",
                crownCount: 15,
                comments: [
                    Comment(userID: 2, content: "Every post of yours is pure art! 🎨", timestamp: "2025-01-02"),
                    Comment(userID: 6, content: "I can totally see this in a high-end magazine! 📰", timestamp: "2025-01-03")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [1],
                isCrowned: false
        ),
        ],
        collections: [
            Collection(
                id: 1,
                title: "Fashion Shows",
                type: .private,
                postIDs: [101 , 104 , 106],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 2,
                title: "Events",
                type: .public,
                postIDs: [102 , 103 , 105],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [1, 2]
    ),
    userPreferences: UserPreferences(
        interests: [.fashion, .photography],
        blockedUserIDs: [3],
        savedPostIDs: [101 , 108 , 109],
        notificationButton: true
    )
)


let user2 = User(
    userID: 2,
    basicInfo: BasicInfo(
        name: "Bob Smith",
        userName: "bobsmith",
        email: "bob.smith@example.com",
        password: "SecurePass456!"
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://bobsmith.portfolio.com"),
        profileImage: UIImage(named: "model2"),
        followersIDs: [1, 3],
        followingIDs: [4, 5],
        skills: ["Fitness", "Fashion"],
        posts: [
            Post(
                id: 107,
                userID: 2,
                tags: ["fitness", "health"],
                postImage: UIImage(named: "post6")!,
                description: "Morning workout session.",
                createdAt: "2025-01-02",
                crownCount: 20,
                comments: [
                    Comment(userID: 1, content: "Great motivation!", timestamp: "2025-01-02"),
                    Comment(userID: 3, content: "Love your energy!", timestamp: "2025-01-03")
                ],
                isSaved: false,
                isFollowed: true,
                collectionIDs: [2],
                isCrowned: false
            ),
            Post(
                id: 201,
                userID: 3,
                tags: ["beauty", "makeup"],
                postImage: UIImage(named: "post7")!,
                description: "Behind the scenes of a makeup tutorial.",
                createdAt: "2025-01-04",
                crownCount: 12,
                comments: [
                    Comment(userID: 2, content: "Love the tutorial!", timestamp: "2025-01-04"),
                    Comment(userID: 4, content: "Great makeup skills!", timestamp: "2025-01-05")
                ],
                isSaved: false,
                isFollowed: true,
                collectionIDs: [3],
                isCrowned: false
            )
        ],
        collections: [
            Collection(
                id: 2,
                title: "Workout Goals",
                type: .private,
                postIDs: [107],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 21,
                title: "Fitness Journey",
                type: .public,
                postIDs: [201],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [1, 3, 2]
    ),
    userPreferences: UserPreferences(
        interests: [.fitness, .events],
        blockedUserIDs: [1],
        savedPostIDs: [],
        notificationButton: false
    )
)


let user3 = User(
    userID: 3,
    basicInfo: BasicInfo(
        name: "Catherine Lee",
        userName: "cathlee",
        email: "catherine.lee@example.com",
        password: "MyPass789!"
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://cathlee.portfolio.com"),
        profileImage: UIImage(named: "model3"),
        followersIDs: [1, 2, 4],
        followingIDs: [5, 6],
        skills: ["Makeup Artist", "Modeling"],
        posts: [
            Post(
                id: 108,
                userID: 3,
                tags: ["Photography", "beauty"],
                postImage: UIImage(named: "post8")!,
                description: "Trying out a new makeup look.",
                createdAt: "2025-01-03",
                crownCount: 10,
                comments: [
                    Comment(userID: 2, content: "You make modeling look effortless! 💯", timestamp: "2025-01-03"),
                    Comment(userID: 4, content: "The composition of this photo is top-notch! 📷", timestamp: "2025-01-04")
                ],
                isSaved: false,
                isFollowed: true,
                collectionIDs: [3],
                isCrowned: false
            ),
            Post(
                id: 200,
                userID: 2,
                tags: ["fitness", "workout"],
                postImage: UIImage(named: "post9")!,
                description: "Strength training session at the gym.",
                createdAt: "2025-01-03",
                crownCount: 15,
                comments: [
                    Comment(userID: 1, content: "Impressive workout!", timestamp: "2025-01-03"),
                    Comment(userID: 3, content: "Keep pushing!", timestamp: "2025-01-04")
                ],
                isSaved: false,
                isFollowed: true,
                collectionIDs: [2],
                isCrowned: false
            )
        ],
        collections: [
            Collection(
                id: 3,
                title: "Makeup Trends",
                type: .public,
                postIDs: [108],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 22,
                title: "Beauty Techniques",
                type: .private,
                postIDs: [200],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [2, 3]
    ),
    userPreferences: UserPreferences(
        interests: [.beauty, .glamour],
        blockedUserIDs: [],
        savedPostIDs: [103],
        notificationButton: true
    )
)


let user4 = User(
    userID: 4,
    basicInfo: BasicInfo(
        name: "David Brown",
        userName: "davidb",
        email: "david.brown@example.com",
        password: "Password654!"
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://davidb.portfolio.com"),
        profileImage: UIImage(named: "model4"),
        followersIDs: [1, 2, 3],
        followingIDs: [5, 6, 7],
        skills: ["Runway", "High Fashion"],
        posts: [
            Post(
                id: 109,
                userID: 4,
                tags: ["runway", "fashion"],
                postImage: UIImage(named: "post10")!,
                description: "Walking the ramp at the NYC show.",
                createdAt: "2025-01-04",
                crownCount: 30,
                comments: [
                    Comment(userID: 2, content: "You absolutely owned the stage! 🔥", timestamp: "2025-01-04"),
                    Comment(userID: 3, content: "Incredible walk! Loved it.", timestamp: "2025-01-05")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [4],
                isCrowned: false
            ),
            Post(
                id: 202,
                userID: 4,
                tags: ["hand", "photoshoot"],
                postImage: UIImage(named: "post11")!,
                description: "Backstage at the latest fashion show.",
                createdAt: "2025-01-05",
                crownCount: 18,
                comments: [
                    Comment(userID: 2, content: "You look amazing!", timestamp: "2025-01-05"),
                    Comment(userID: 3, content: "Great backstage shot!", timestamp: "2025-01-06")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [4],
                isCrowned: false
            )
        ],
        collections: [
            Collection(
                id: 4,
                title: "Runway Moments",
                type: .public,
                postIDs: [109],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 20,
                title: "Fahion Shows ",
                type: .private,
                postIDs: [109],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 23,
                title: "Fashion Behind the Scenes",
                type: .public,
                postIDs: [202],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [2, 4]
    ),
    userPreferences: UserPreferences(
        interests: [.runway, .fashion],
        blockedUserIDs: [3],
        savedPostIDs: [],
        notificationButton: false
    )
)


let user5 = User(
    userID: 5,
    basicInfo: BasicInfo(
        name: "Emma Wilson",
        userName: "emmaw",
        email: "emma.wilson@example.com",
        password: "SecurePass321!"
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://emmaw.portfolio.com"),
        profileImage: UIImage(named: "model5"),
        followersIDs: [2, 3, 4],
        followingIDs: [6, 7, 8],
        skills: ["Commercial Modeling", "Catalog"],
        posts: [
            Post(
                id: 110,
                userID: 5,
                tags: ["commercial", "catalog"],
                postImage: UIImage(named: "post12")!,
                description: "New catalog shoot for a fashion brand.",
                createdAt: "2025-01-05",
                crownCount: 25,
                comments: [
                    Comment(userID: 3, content: "Absolutely stunning! 💖", timestamp: "2025-01-05"),
                    Comment(userID: 4, content: "Your expressions are on point!", timestamp: "2025-01-06")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [5],
                isCrowned: false
            ),
            Post(
                id: 203,
                userID: 5,
                tags: ["commercial", "lifestyle"],
                postImage: UIImage(named: "post13")!,
                description: "Behind the scenes of a commercial shoot.",
                createdAt: "2025-01-06",
                crownCount: 22,
                comments: [
                    Comment(userID: 3, content: "Great professional shot!", timestamp: "2025-01-06"),
                    Comment(userID: 4, content: "Loving the professional vibe!", timestamp: "2025-01-07")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [5],
                isCrowned: false
            )
        ],
        collections: [
            Collection(
                id: 5,
                title: "Brand Shoots",
                type: .public,
                postIDs: [110],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 24,
                title: "Commercial Portfolio",
                type: .private,
                postIDs: [203],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [3, 5]
    ),
    userPreferences: UserPreferences(
        interests: [.commercial, .catalog],
        blockedUserIDs: [],
        savedPostIDs: [105],
        notificationButton: false
    )
)


let user6 = User(
    userID: 6,
    basicInfo: BasicInfo(
        name: "Fiona Garcia",
        userName: "fionag",
        email: "fiona.garcia@example.com",
        password: "Fiona@123"
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://fionag.portfolio.com"),
        profileImage: UIImage(named: "model6"),
        followersIDs: [3, 4, 5],
        followingIDs: [7, 8, 9],
        skills: ["Fitness", "Photography"],
        posts: [
            Post(
                id: 111,
                userID: 6,
                tags: ["fitness", "lifestyle"],
                postImage: UIImage(named: "post14")!,
                description: "Morning yoga session.",
                createdAt: "2025-01-06",
                crownCount: 18,
                comments: [
                    Comment(userID: 4, content: "Such a peaceful vibe! 🧘‍♀️", timestamp: "2025-01-06"),
                    Comment(userID: 5, content: "Love your dedication! 🌿", timestamp: "2025-01-07")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [6],
                isCrowned: false
            ),
            Post(
                id: 204,
                userID: 6,
                tags: ["fitness", "wellness"],
                postImage: UIImage(named: "post15")!,
                description: "Pilates session for mental and physical balance.",
                createdAt: "2025-01-07",
                crownCount: 16,
                comments: [
                    Comment(userID: 4, content: "Inspiring wellness journey!", timestamp: "2025-01-07"),
                    Comment(userID: 5, content: "Excellent form!", timestamp: "2025-01-08")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [6],
                isCrowned: false
            )
        ],
        collections: [
            Collection(
                id: 6,
                title: "Wellness Journey",
                type: .private,
                postIDs: [111],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 25,
                title: "Fitness and Mindfulness",
                type: .public,
                postIDs: [204],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [1, 4, 6]
    ),
    userPreferences: UserPreferences(
        interests: [.fitness, .lifestyle],
        blockedUserIDs: [4],
        savedPostIDs: [],
        notificationButton: true
    )
)


let user7 = User(
    userID: 7,
    basicInfo: BasicInfo(
        name: "George Miller",
        userName: "georgem",
        email: "george.miller@example.com",
        password: "George789!"
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://georgem.portfolio.com"),
        profileImage: UIImage(named: "model6"),
        followersIDs: [4, 5, 6],
        followingIDs: [8, 9, 10],
        skills: ["Alternative Fashion", "Hand"],
        posts: [
            Post(
                id: 112,
                userID: 7,
                tags: ["tattoo", "alternative"],
                postImage: UIImage(named: "post25")!,
                description: "Showcasing my latest ink.",
                createdAt: "2025-01-07",
                crownCount: 22,
                comments: [
                    Comment(userID: 6, content: "Awesome tattoos!", timestamp: "2025-01-07"),
                    Comment(userID: 8, content: "Love this style!", timestamp: "2025-01-07")
                ],
                isSaved: false,
                isFollowed: true,
                collectionIDs: [7],
                isCrowned: false
            ),
            Post(
                id: 205,
                userID: 7,
                tags: ["alternative", "fashion"],
                postImage: UIImage(named: "post17")!,
                description: "Exploring unique fashion styles.",
                createdAt: "2025-01-08",
                crownCount: 20,
                comments: [
                    Comment(userID: 6, content: "Unique style!", timestamp: "2025-01-08"),
                    Comment(userID: 8, content: "Love the creativity!", timestamp: "2025-01-09")
                ],
                isSaved: false,
                isFollowed: true,
                collectionIDs: [7],
                isCrowned: false
            )
        ],
        collections: [
            Collection(
                id: 7,
                title: "Ink Chronicles",
                type: .public,
                postIDs: [112],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 26,
                title: "Alternative Fashion Styles",
                type: .private,
                postIDs: [205],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [3, 7]
    ),
    userPreferences: UserPreferences(
        interests: [.alternative, .tattooed],
        blockedUserIDs: [],
        savedPostIDs: [],
        notificationButton: false
    )
)

let user8 = User(
    userID: 8,
    basicInfo: BasicInfo(
        name: "Hannah Davis",
        userName: "hannahd",
        email: "hannah.davis@example.com",
        password: "Hannah567!"
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://hannahd.portfolio.com"),
        profileImage: UIImage(named: "model8"),
        followersIDs: [5, 6, 7],
        followingIDs: [9, 10],
        skills: ["Editorial", "Makeup Artistry"],
        posts: [
            Post(
                id: 113,
                userID: 8,
                tags: ["editorial", "makeup"],
                postImage: UIImage(named: "post18")!,
                description: "Editorial shoot for a magazine.",
                createdAt: "2025-01-08",
                crownCount: 35,
                comments: [
                    Comment(userID: 7, content: "Stunning work!", timestamp: "2025-01-08"),
                    Comment(userID: 9, content: "Absolutely beautiful!", timestamp: "2025-01-08")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [8],
                isCrowned: false
            ),
            Post(
                id: 206,
                userID: 8,
                tags: ["editorial", "beauty"],
                postImage: UIImage(named: "post19")!,
                description: "Exploring avant-garde makeup looks.",
                createdAt: "2025-01-09",
                crownCount: 28,
                comments: [
                    Comment(userID: 7, content: "Stunning artistry!", timestamp: "2025-01-09"),
                    Comment(userID: 9, content: "Incredible makeup skills!", timestamp: "2025-01-10")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [8],
                isCrowned: false
            )
        ],
        collections: [
            Collection(
                id: 8,
                title: "Magazine Features",
                type: .private,
                postIDs: [113],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 27,
                title: "Makeup Artistry",
                type: .public,
                postIDs: [206],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [1, 6]
    ),
    userPreferences: UserPreferences(
        interests: [.editorial, .beauty],
        blockedUserIDs: [6],
        savedPostIDs: [108],
        notificationButton: true
    )
)

let user9 = User(
    userID: 9,
    basicInfo: BasicInfo(
        name: "Isaac Young",
        userName: "isaacy",
        email: "isaac.young@example.com",
        password: "Isaac345!"
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://isaacy.portfolio.com"),
        profileImage: UIImage(named: "model9"),
        followersIDs: [6, 7, 8],
        followingIDs: [10, 1],
        skills: ["Fashion", "Freelancing"],
        posts: [
            Post(
                id: 114,
                userID: 9,
                tags: ["hairstyle", "freelance"],
                postImage: UIImage(named: "post20")!,
                description: "Creating trendy hairstyles.",
                createdAt: "2025-01-09",
                crownCount: 19,
                comments: [
                    Comment(userID: 8, content: "Great work!", timestamp: "2025-01-09"),
                    Comment(userID: 10, content: "So creative!", timestamp: "2025-01-09")
                ],
                isSaved: false,
                isFollowed: true,
                collectionIDs: [9],
                isCrowned: false
            ),
            Post(
                id: 207,
                userID: 9,
                tags: ["hairstyle", "fashion"],
                postImage: UIImage(named: "post21")!,
                description: "Creative hairstyling for a fashion shoot.",
                createdAt: "2025-01-10",
                crownCount: 17,
                comments: [
                    Comment(userID: 8, content: "Amazing hair design!", timestamp: "2025-01-10"),
                    Comment(userID: 10, content: "So innovative!", timestamp: "2025-01-11")
                ],
                isSaved: false,
                isFollowed: true,
                collectionIDs: [9],
                isCrowned: false
            )
        ],
        collections: [
            Collection(
                id: 9,
                title: "Hairstyle Gallery",
                type: .public,
                postIDs: [207],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 28,
                title: "Hairstyle Innovations",
                type: .public,
                postIDs: [207],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [2, 8]
    ),
    userPreferences: UserPreferences(
        interests: [.hairstylist, .freelancer],
        blockedUserIDs: [],
        savedPostIDs: [],
        notificationButton: false
    )
)

let user10 = User(
    userID: 10,
    basicInfo: BasicInfo(
        name: "Jessica Carter",
        userName: "jesscarter",
        email: "jessica.carter@example.com",
        password: "Jess123!"
    ),
    profileData: ProfileData(
        portfolio: URL(string: "https://jesscarter.portfolio.com"),
        profileImage: UIImage(named: "model10"),
        followersIDs: [7, 8, 9],
        followingIDs: [1, 2],
        skills: ["Petite Modeling", "Catalog"],
        posts: [
            Post(
                id: 115,
                userID: 10,
                tags: ["petite", "catalog"],
                postImage: UIImage(named: "post22")!,
                description: "New shoot for the petite collection.",
                createdAt: "2025-01-10",
                crownCount: 27,
                comments: [
                    Comment(userID: 9, content: "Looks amazing!", timestamp: "2025-01-10"),
                    Comment(userID: 6, content: "Beautiful work!", timestamp: "2025-01-10")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [10],
                isCrowned: false
            ),
            Post(
                id: 208,
                userID: 10,
                tags: ["petite", "fashion"],
                postImage: UIImage(named: "post23")!,
                description: "Showcasing versatility in petite modeling.",
                createdAt: "2025-01-11",
                crownCount: 24,
                comments: [
                    Comment(userID: 9, content: "Stunning presentation!", timestamp: "2025-01-11"),
                    Comment(userID: 6, content: "Rocking that petite style!", timestamp: "2025-01-12")
                ],
                isSaved: false,
                isFollowed: false,
                collectionIDs: [10],
                isCrowned: false
            )
        ],
        collections: [
            Collection(
                id: 10,
                title: "Petite Shoots",
                type: .private,
                postIDs: [115],
                createdAt: "2025-02-01"
            ),
            Collection(
                id: 29,
                title: "Petite Model",
                type: .public,
                postIDs: [208],
                createdAt: "2025-02-01"
            )
        ],
        chats: [],
        eventsRegistered: [5, 9]
    ),
    userPreferences: UserPreferences(
        interests: [.petite, .catalog],
        blockedUserIDs: [7],
        savedPostIDs: [110],
        notificationButton: true
    )
)




class UserDataModel: ObservableObject {
    static let shared = UserDataModel()
      
      // Remove the recursive @ObservedObject declaration
      @Published var users: [User] = []
      @Published private(set) var posts: [Post] = [] // Store all posts
      @Published var currentUser: User
   
      private var savedPosts: Set<String> = []
      
      private init() {
          // Safely initialize currentUser
         
          currentUser = user1
          // Populate users
          users.append(contentsOf: [user1, user2, user3, user4, user5, user6, user7, user8, user9, user10])
          
          // Collect all posts from users
          posts = users.flatMap { $0.profileData.posts }
      }
    func getFeedPosts(for currentUser: User, allUsers: [User]) -> [Post] {
        var matchingSkillPosts: [Post] = []
        var nonMatchingPosts: [Post] = []
        
        let userSkills = Set(currentUser.profileData.skills.map { $0.lowercased() })
        let blockedUserIDs = Set(currentUser.userPreferences.blockedUserIDs)
        
        print("User Skills: \(userSkills)")
        print("Blocked User IDs: \(blockedUserIDs)")

        for user in allUsers where user.userID != currentUser.userID && !blockedUserIDs.contains(user.userID) {
            for post in user.profileData.posts {
                let postTags = Set(post.tags.map { $0.lowercased() })
                print("Post Tags: \(postTags) from User \(user.userID)")

                if !userSkills.isDisjoint(with: postTags) {
                    matchingSkillPosts.append(post)
                } else {
                    nonMatchingPosts.append(post)
                }
            }
        }

        // Sort both arrays by date
        let sortedMatchingPosts = matchingSkillPosts.sorted { $0.createdAt > $1.createdAt }
        let sortedNonMatchingPosts = nonMatchingPosts.sorted { $0.createdAt > $1.createdAt }

        // Combine the arrays with matching posts first
        let feedPosts = sortedMatchingPosts + sortedNonMatchingPosts

        print("✅ Total matching posts: \(sortedMatchingPosts.count)")
        print("✅ Total non-matching posts: \(sortedNonMatchingPosts.count)")
        return feedPosts
    }
    func toggleCrown(postID: Int, userID: Int) {
        for i in users.indices {
            if let postIndex = users[i].profileData.posts.firstIndex(where: { $0.id == postID }) {
                // ✅ Directly update the post reference
                users[i].profileData.posts[postIndex].isCrowned.toggle()
                users[i].profileData.posts[postIndex].crownCount += users[i].profileData.posts[postIndex].isCrowned ? 1 : -1
                
                // ✅ Also update in global posts array
                if let globalPostIndex = posts.firstIndex(where: { $0.id == postID }) {
                    posts[globalPostIndex] = users[i].profileData.posts[postIndex]
                }

                // ✅ Notify UI
                objectWillChange.send()

                print("Post \(postID) - Crown: \(users[i].profileData.posts[postIndex].isCrowned), Count: \(users[i].profileData.posts[postIndex].crownCount)")
                return
            }
        }
    }
    func updateCrownStatus(forUser user: User) {
        for post in user.profileData.posts {
            if let globalPostIndex = posts.firstIndex(where: { $0.id == post.id }) {
                posts[globalPostIndex].isCrowned = post.isCrowned
                posts[globalPostIndex].crownCount = post.crownCount
            }
        }
        
        // ✅ Notify SwiftUI
        objectWillChange.send()
    }


    func removePost(postID: Int) {
            if let index = posts.firstIndex(where: { $0.id == postID }) {
                posts.remove(at: index)
                objectWillChange.send()  // Notify SwiftUI of the change
            }
        }
    func blockUser(currentUserID: Int, userToBlockID: Int) {
        // Find the current user's index
        guard let currentUserIndex = users.firstIndex(where: { $0.userID == currentUserID }),
              let blockedUserIndex = users.firstIndex(where: { $0.userID == userToBlockID }) else {
            print("User not found")
            return
        }
        
        var currentUser = users[currentUserIndex] // ✅ Copy to modify

        // Check if the user is already blocked
        if !currentUser.userPreferences.blockedUserIDs.contains(userToBlockID) {
            // Add to blocked list
            currentUser.userPreferences.blockedUserIDs.append(userToBlockID)

            // ✅ Remove from followers list
            currentUser.profileData.followersIDs.removeAll { $0 == userToBlockID }
            users[blockedUserIndex].profileData.followingIDs.removeAll { $0 == currentUserID }

            // ✅ Remove from following list
            currentUser.profileData.followingIDs.removeAll { $0 == userToBlockID }
            users[blockedUserIndex].profileData.followersIDs.removeAll { $0 == currentUserID }

            // ✅ Update currentUser if needed
            if currentUserID == self.currentUser.userID {
                self.currentUser.userPreferences.blockedUserIDs.append(userToBlockID)
                self.currentUser.profileData.followersIDs.removeAll { $0 == userToBlockID }
                self.currentUser.profileData.followingIDs.removeAll { $0 == userToBlockID }
            }

            // ✅ Remove blocked user's posts from home feed
            posts.removeAll { post in
                users[blockedUserIndex].profileData.posts.contains(where: { $0.id == post.id })
            }

            // ✅ Update the user in the array
            users[currentUserIndex] = currentUser

            // ✅ Notify SwiftUI of changes
            objectWillChange.send()

            print("User \(userToBlockID) has been blocked and removed from followers/following.")
        }
    }

    // Modified getFeedPosts to exclude posts from blocked users
   
    func getFollowersList(forUserID userID: Int) -> [User] {
            let followerIDs = users.first { $0.userID == userID }?.profileData.followersIDs ?? []
            return followerIDs.compactMap { id in users.first { $0.userID == id } }
        }
        
        func getFollowingList(forUserID userID: Int) -> [User] {
            let followingIDs = users.first { $0.userID == userID }?.profileData.followingIDs ?? []
            return followingIDs.compactMap { id in users.first { $0.userID == id } }
        }
        
        func isFollowing(currentUserID: Int, targetUserID: Int) -> Bool {
            guard let currentUser = users.first(where: { $0.userID == currentUserID }) else { return false }
            return currentUser.profileData.followingIDs.contains(targetUserID)
        }
    
    func getPostByID(postID: Int) -> Post? {
        for user in users where !currentUser.userPreferences.blockedUserIDs.contains(user.userID) {
            if let post = user.profileData.posts.first(where: { $0.id == postID }) {
                return post
            }
        }
        return nil
    }
    func appendRegisteredEvents(event: Int) {
        self.currentUser.profileData.eventsRegistered.append(event)
        objectWillChange.send()
    }
    func getFollowerCount(forUserID userID: Int) -> Int {
         return users.first { $0.userID == userID }?.profileData.followersIDs.count ?? 0
     }
   
        
    func toggleFollow(currentUserID: Int, targetUserID: Int) {
        guard let currentUserIndex = users.firstIndex(where: { $0.userID == currentUserID }),
              let targetUserIndex = users.firstIndex(where: { $0.userID == targetUserID }) else { return }

        // Mutate directly to ensure SwiftUI updates
        if let index = users[currentUserIndex].profileData.followingIDs.firstIndex(of: targetUserID) {
            // Unfollow
            users[currentUserIndex].profileData.followingIDs.remove(at: index)
            if let followerIndex = users[targetUserIndex].profileData.followersIDs.firstIndex(of: currentUserID) {
                users[targetUserIndex].profileData.followersIDs.remove(at: followerIndex)
            }
        } else {
            // Follow
            users[currentUserIndex].profileData.followingIDs.append(targetUserID)
            users[targetUserIndex].profileData.followersIDs.append(currentUserID)
        }

        // Explicitly trigger updates
        objectWillChange.send()
    }


    func getRelatedPosts(for post: Post) -> [Post] {
        // Fetch posts with similar tags or from the same user
        return getAllPosts(forUser: currentUser).filter { $0.userID == post.userID && $0.id != post.id }
    }

    func toggleSave(postID: String) {
        // Convert postID to Int
        guard let postIDInt = Int(postID) else { return }

        // Find the post in global `posts` array
        if let index = posts.firstIndex(where: { $0.id == postIDInt }) {
            posts[index].isSaved.toggle()

            // Update savedPosts set
            if posts[index].isSaved {
                savedPosts.insert(postID)
            } else {
                savedPosts.remove(postID)
            }

            // 🔹 Ensure the current user’s saved posts are updated correctly
            if let userIndex = users.firstIndex(where: { $0.userID == currentUser.userID }) {
                // Find only the post that matches the postID inside user's posts
                if let postIndex = users[userIndex].profileData.posts.firstIndex(where: { $0.id == postIDInt }) {
                    users[userIndex].profileData.posts[postIndex].isSaved.toggle()
                } else {
                    // If the post is NOT inside `profileData.posts`, add it if saved
                    if posts[index].isSaved {
                        users[userIndex].profileData.posts.append(posts[index])
                    }
                }
            }

            objectWillChange.send() // Notify SwiftUI of UI updates
        }
    }


    // Check if a post is saved
    func isPostSaved(postID: String) -> Bool {
        return savedPosts.contains(postID)
    }
    func getSavedPosts(forUser user: User) -> [Post] {
        return posts.filter { $0.isSaved }
    }

    func getComments(for postID: Int) -> [Comment] {
          return posts.first(where: { $0.id == postID })?.comments ?? []
      }
    func addComment(toPostID postID: Int, byUserID userID: Int, content: String) {
        let newComment = Comment(userID: userID, content: content, timestamp: Date().description)
        
        // Update comment in user's profile
        if let userIndex = users.firstIndex(where: { $0.userID == userID }),
           let postIndex = users[userIndex].profileData.posts.firstIndex(where: { $0.id == postID }) {
            users[userIndex].profileData.posts[postIndex].comments.append(newComment)
        }
        
        // Update comment in central post list
        if let postIndex = posts.firstIndex(where: { $0.id == postID }) {
            posts[postIndex].comments.append(newComment)
        }
        
        objectWillChange.send()
    }


        func getAllUsers() -> [User] {
            return users
        }
    func getUserByID(userID: Int) -> User? {
        return users.first { $0.userID == userID }
    }
    
//    func getFeedPosts(for currentUser: User, allUsers: [User]) -> [Post] {
//            var matchingSkillPosts: [Post] = []
//            var nonMatchingPosts: [Post] = []
//            
//            let userSkills = Set(currentUser.profileData.skills.map { $0.lowercased() })
//            print("User Skills: \(userSkills)")
//
//            for user in allUsers where user.userID != currentUser.userID {
//                for post in user.profileData.posts {
//                    let postTags = Set(post.tags.map { $0.lowercased() })
//                    print("Post Tags: \(postTags) from User \(user.userID)")
//
//                    if !userSkills.isDisjoint(with: postTags) {
//                        matchingSkillPosts.append(post)
//                    } else {
//                        nonMatchingPosts.append(post)
//                    }
//                }
//            }
//
//            // Sort both arrays by date
//            let sortedMatchingPosts = matchingSkillPosts.sorted { $0.createdAt > $1.createdAt }
//            let sortedNonMatchingPosts = nonMatchingPosts.sorted { $0.createdAt > $1.createdAt }
//
//            // Combine the arrays with matching posts first
//            let feedPosts = sortedMatchingPosts + sortedNonMatchingPosts
//
//            print("✅ Total matching posts: \(sortedMatchingPosts.count)")
//            print("✅ Total non-matching posts: \(sortedNonMatchingPosts.count)")
//            return feedPosts
//        }


 

        func getAllPosts(forUser user: User) -> [Post] {
            return user.profileData.posts
        }
       func getCrownCount(forPostID postID: Int) -> Int {
           return getPostByID(postID: postID)?.crownCount ?? 0
       }
//        // 🔹 Get Comment Count for a Post
//        func getCommentCount(forPostID postID: Int) -> Int {
//            return getPostByID(postID: postID)?.commentIDs.count ?? 0
//        }
    // MARK: - Functions
    func searchUsers(byName name: String) -> [User] {
        let lowercasedName = name.lowercased()
        return users.filter { $0.basicInfo.name.lowercased().contains(lowercasedName) }
    }
    func getUser(byID userID: Int) -> User? {
            return users.first { $0.userID == userID }
        }
    func searchImagesByTagAcrossAllUsers(tag: String) -> [UIImage] {
        let lowercaseTag = tag.lowercased()
        var matchingImages: [UIImage] = []

        for user in users {
            let filteredPosts = user.profileData.posts.filter { post in
                post.tags.contains { $0.lowercased() == lowercaseTag }
            }
            let images = filteredPosts.compactMap { $0.postImage } // ✅ Ensuring only valid images are added
            matchingImages.append(contentsOf: images)
        }
        
        return matchingImages
    }
    func getUsername(forPostID postID: Int) -> String? {
        guard let post = getPostByID(postID: postID),
              let user = getUserByID(userID: post.userID) else { return nil }
        return user.basicInfo.userName
    }
func getProfileImages(forPost post: Post, users: [User]) -> [UIImage] {
    let postTags = Set(post.tags.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() })
    
    let categories: [String: Set<String>] = [
        "Hand Model": ["hand"],
        "Glamour Model": ["glamour", "beauty", "fashion"],
        "Runway Model": ["runway", "highfashion", "fashion"],
        "Fitness Model": ["fitness"]
    ]

    var matchingProfileImages: [UIImage] = []

    for (category, keywords) in categories {
        // If any of the post's tags match the category keywords
        if !postTags.isDisjoint(with: keywords) {
            matchingProfileImages.append(post.postImage) // ✅ Add post image
            break
        }
    }
    
    return matchingProfileImages
}
    func getRegisteredEventIDs(forUser user: User) -> [Int] {
        return user.profileData.eventsRegistered
    }

    
    func getUserImage(forUser user: User) -> UIImage? {
        return user.profileData.profileImage
    }
    
    func getNumberOfFollowers(forUser user: User) -> Int {
        return user.profileData.followersIDs.count
    }
    
    func getNumberOfFollowing(forUser user: User) -> Int {
        return user.profileData.followingIDs.count
    }
    
    func getNumberOfPosts(forUser user: User) -> Int {
        return user.profileData.posts.count
    }
    
    func getUserSkills(forUser user: User) -> [String] {
        return user.profileData.skills
    }
    
//    func getAllPosts(forUser user: User) -> [Post] {
//        return user.profileData.posts
//    }
//
    func getAllCollections(forUser user: User) -> [Collection] {
        return user.profileData.collections
    }
    
    func getUserName(forUser user: User) -> String {
        return user.basicInfo.name
    }
    
    func getUserHandle(forUser user: User) -> String {
        return user.basicInfo.userName
    }
    
    func getPortfolio(forUser user: User) -> URL? {
        return user.profileData.portfolio
    }
    
    func getNotificationStatus(forUser user: User) -> Bool {
        return user.userPreferences.notificationButton
    }
    
//    func getUser(byID userID: Int) -> User? {
//        return users.first { $0.userID == userID }
//    }
//
    func updatePersonalInformation(
        forUserID userID: Int,
        name: String,
        userName: String,
        email: String,
        password: String,
        profileImage: UIImage?
    ) {
        // Update user in the users array
        if let index = users.firstIndex(where: { $0.userID == userID }) {
            users[index].basicInfo.name = name
            users[index].basicInfo.userName = userName
            users[index].basicInfo.email = email
            users[index].basicInfo.password = password
            
            if let newImage = profileImage {
                users[index].profileData.profileImage = newImage
            }
            
            // If this is the current user, update the entire currentUser object
            if userID == currentUser.userID {
                currentUser = users[index]
            }
            
            // The @Published property will automatically notify observers
        }
    }
    
        // Function to update skills
//    func updateSkills(forUserID userID: Int, skills: [String]) {
//        // Find the user in the users array
//        if let index = users.firstIndex(where: { $0.userID == userID }) {
//            // Update the skills in the users array
//            users[index].profileData.skills = skills
//            
//            // If this is the current user, also update the currentUser property
//            if userID == currentUser.userID {
//                currentUser.profileData.skills = skills
//            }
//            
//            // Explicitly trigger a UI update
//            objectWillChange.send()
//            
//            // Print for debugging
//            print("Skills updated for user \(userID): \(skills)")
//        }
//    }
    
    func updateSkills(forUserID userID: Int, skills: [String]) {
        // Find the user's index
        if let index = self.users.firstIndex(where: { $0.userID == userID }) {
            // Create a mutable copy of the user
            var updatedUser = self.users[index]
            
            // Update the skills
            updatedUser.profileData.skills = skills
            
            // Update the user in the array
            self.users[index] = updatedUser
            
            // Update currentUser if needed
            if userID == currentUser.userID {
                currentUser.profileData.skills = skills
            }
            
            // Notify observers
            objectWillChange.send()
        }
    }

        // Function to get blocked users
    func getBlockedUsers(forUser user: User) -> [User] {
        return users.filter { user.userPreferences.blockedUserIDs.contains($0.userID) }
    }

        // Function to get saved posts
//    func getSavedPosts(forUser user: User) -> [Post] {
//        return user.profileData.posts.filter { $0.isSaved }
//    }
    
 
    
    func deleteComment(fromPostID postID: Int, commentIndex: Int, byUserID userID: Int) {
        guard let userIndex = users.firstIndex(where: { $0.userID == userID }),
              let postIndex = users[userIndex].profileData.posts.firstIndex(where: { $0.id == postID }) else {
            return
        }
        
        users[userIndex].profileData.posts[postIndex].comments.remove(at: commentIndex)
        
        // Notify observers that the data has changed
        objectWillChange.send()
    }
    
    func getComments(forPostID postID: Int, inUserID userID: Int) -> [Comment]? {
        guard let userIndex = users.firstIndex(where: { $0.userID == userID }),
              let postIndex = users[userIndex].profileData.posts.firstIndex(where: { $0.id == postID }) else {
            return nil
        }
        
        return users[userIndex].profileData.posts[postIndex].comments
    }
    
    func getComment(onPostID postID: Int, commentIndex: Int, inUserID userID: Int) -> Comment? {
        guard let userIndex = users.firstIndex(where: { $0.userID == userID }),
              let postIndex = users[userIndex].profileData.posts.firstIndex(where: { $0.id == postID }) else {
            return nil
        }
        
        return users[userIndex].profileData.posts[postIndex].comments[commentIndex]
    }
    
    func getNumberOfComments(onPostID postID: Int, inUserID userID: Int) -> Int {
        guard let userIndex = users.firstIndex(where: { $0.userID == userID }),
              let postIndex = users[userIndex].profileData.posts.firstIndex(where: { $0.id == postID }) else {
            return 0
        }
        
        return users[userIndex].profileData.posts[postIndex].comments.count
    }
    
    
    // Update portfolio for a user
    func updatePortfolio(forUserID userID: Int, portfolio: URL?) {
            if let index = users.firstIndex(where: { $0.userID == userID }) {
                users[index].profileData.portfolio = portfolio
                
                // Update current user if needed
                if currentUser.userID == userID {
                    currentUser.profileData.portfolio = portfolio
                }
                
                // Save to UserDefaults
                if let portfolioURL = portfolio {
                    UserDefaults.standard.set(portfolioURL, forKey: "portfolio_\(userID)")
                } else {
                    UserDefaults.standard.removeObject(forKey: "portfolio_\(userID)")
                }
                
                // Explicitly trigger UI update
                objectWillChange.send()
                
                // Debug logging
                print("Portfolio \(portfolio != nil ? "updated" : "removed") for user \(userID)")
            }
        }

    // Save portfolio to UserDefaults
    private func savePortfolio(forUserID userID: Int) {
        if let index = users.firstIndex(where: { $0.userID == userID }),
           let portfolioURL = users[index].profileData.portfolio {
            UserDefaults.standard.set(portfolioURL, forKey: "portfolio_\(userID)")
        } else {
            UserDefaults.standard.removeObject(forKey: "portfolio_\(userID)")
        }
    }

    // Load portfolio from UserDefaults
    private func loadPortfolio(forUserID userID: Int) -> URL? {
        return UserDefaults.standard.url(forKey: "portfolio_\(userID)")
    }

    // Initialize portfolio when the app launches
    func initializePortfolio(forUserID userID: Int) {
        if let index = users.firstIndex(where: { $0.userID == userID }) {
            users[index].profileData.portfolio = loadPortfolio(forUserID: userID)
        }
    }
    
    func updateBlockedUsers(userID: Int, blockedUserIDs: [Int]) {
        if let index = self.users.firstIndex(where: { $0.userID == userID }) {
            self.users[index].userPreferences.blockedUserIDs = blockedUserIDs
            
            // If this is the current user, update currentUser as well
            if userID == self.currentUser.userID {
                self.currentUser.userPreferences.blockedUserIDs = blockedUserIDs
            }
            
            // Notify observers that the data has changed
            self.objectWillChange.send()
        }
    }
    
    func toggleSaved(postID: Int) {
        // Find the post in all users' posts and toggle its saved status
        for i in 0..<users.count {
            for j in 0..<users[i].profileData.posts.count {
                if users[i].profileData.posts[j].id == postID {
                    users[i].profileData.posts[j].isSaved.toggle()
                    
                    // Update the post in the main posts array too
                    if let index = posts.firstIndex(where: { $0.id == postID }) {
                        posts[index].isSaved.toggle()
                    }
                    
                    // Notify UI of changes
                    objectWillChange.send()
                    return
                }
            }
        }
    }
    
    func addCollection(_ collection: Collection, forUser userID: Int) {
        // Find the user index
        guard let userIndex = users.firstIndex(where: { $0.userID == userID }) else {
            print("User not found")
            return
        }
        
        // Add the collection to the user's collections
        users[userIndex].profileData.collections.append(collection)
        
        // Update currentUser if needed
        if userID == currentUser.userID {
            currentUser.profileData.collections.append(collection)
        }
        
        // Notify observers
        objectWillChange.send()
        
        print("Collection '\(collection.title)' created for user \(userID)")
    }
    func searchPostsByTag(tag: String) -> [Post] {
            return posts.filter { $0.tags.contains(where: { $0.lowercased().contains(tag.lowercased()) }) }
        }
    func updateCollection(
        collectionID: Int,
        userID: Int,
        newTitle: String? = nil,
        newType: CollectionType? = nil,
        addPostIDs: [Int]? = nil,
        removePostIDs: [Int]? = nil
    ) {
        guard let userIndex = users.firstIndex(where: { $0.userID == userID }) else {
            print("User not found")
            return
        }
        
        guard let collectionIndex = users[userIndex].profileData.collections.firstIndex(where: { $0.id == collectionID }) else {
            print("Collection not found")
            return
        }
        
        if let title = newTitle {
            users[userIndex].profileData.collections[collectionIndex].title = title
        }
        
        if let type = newType {
            users[userIndex].profileData.collections[collectionIndex].type = type
        }
        
        if let postIDsToAdd = addPostIDs {
            users[userIndex].profileData.collections[collectionIndex].postIDs.append(contentsOf: postIDsToAdd)
        }
        
        if let postIDsToRemove = removePostIDs {
            users[userIndex].profileData.collections[collectionIndex].postIDs =
                users[userIndex].profileData.collections[collectionIndex].postIDs.filter {
                    !postIDsToRemove.contains($0)
                }
        }
        
        if userID == currentUser.userID {
            currentUser.profileData.collections[collectionIndex] = users[userIndex].profileData.collections[collectionIndex]
        }
        
        objectWillChange.send()
        print("Collection updated: \(users[userIndex].profileData.collections[collectionIndex].title)")
    }
    
    func deleteCollection(collectionID: Int, userID: Int) {
        guard let userIndex = users.firstIndex(where: { $0.userID == userID }) else {
            print("User not found")
            return
        }
        users[userIndex].profileData.collections.removeAll { $0.id == collectionID }
        if userID == currentUser.userID {
            currentUser.profileData.collections.removeAll { $0.id == collectionID }
        }
        objectWillChange.send()
        
        print("Collection deleted")
    }
        
    
    func deletePost(postID: Int, userID: Int) {
            guard let userIndex = users.firstIndex(where: { $0.userID == userID }) else {
                print("User not found")
                return
            }
            users[userIndex].profileData.posts.removeAll { $0.id == postID }
            posts.removeAll { $0.id == postID }
            
            if userID == currentUser.userID {
                currentUser.profileData.posts.removeAll { $0.id == postID }
            }
            objectWillChange.send()
            
            print("Post deleted")
        }
        
        func updatePostDescription(postID: Int, userID: Int, newDescription: String) {
            guard let userIndex = users.firstIndex(where: { $0.userID == userID }) else {
                print("User not found")
                return
            }
            
            if let postIndex = users[userIndex].profileData.posts.firstIndex(where: { $0.id == postID }) {
                users[userIndex].profileData.posts[postIndex].description = newDescription
            }
            
            if let postIndex = posts.firstIndex(where: { $0.id == postID }) {
                posts[postIndex].description = newDescription
            }
            
            if userID == currentUser.userID {
                if let postIndex = currentUser.profileData.posts.firstIndex(where: { $0.id == postID }) {
                    currentUser.profileData.posts[postIndex].description = newDescription
                }
            }
            objectWillChange.send()
            
            print("Post description updated")
        }
    
    
        func addTagsToPost(postID: Int, userID: Int, newTags: [String]) {
            guard let userIndex = users.firstIndex(where: { $0.userID == userID }) else {
                print("User not found")
                return
            }
            if let postIndex = users[userIndex].profileData.posts.firstIndex(where: { $0.id == postID }) {
                let updatedTags = Array(Set(users[userIndex].profileData.posts[postIndex].tags + newTags))
                users[userIndex].profileData.posts[postIndex].tags = updatedTags
            }
            if let postIndex = posts.firstIndex(where: { $0.id == postID }) {
                let updatedTags = Array(Set(posts[postIndex].tags + newTags))
                posts[postIndex].tags = updatedTags
            }
            if userID == currentUser.userID {
                if let postIndex = currentUser.profileData.posts.firstIndex(where: { $0.id == postID }) {
                    let updatedTags = Array(Set(currentUser.profileData.posts[postIndex].tags + newTags))
                    currentUser.profileData.posts[postIndex].tags = updatedTags
                }
            }
            objectWillChange.send()
            
            print("Tags added to post")
        }
    
    func isPostInCollection(postID: Int, collectionID: Int, userID: Int) -> Bool {
            guard let user = users.first(where: { $0.userID == userID }) else {
                return false
            }
            
            guard let collection = user.profileData.collections.first(where: { $0.id == collectionID }) else {
                return false
            }
            
            return collection.postIDs.contains(postID)
        }
        
        // Remove post from a specific collection
        func removePostFromCollection(postID: Int, collectionID: Int, userID: Int) {
            guard let userIndex = users.firstIndex(where: { $0.userID == userID }),
                  let collectionIndex = users[userIndex].profileData.collections.firstIndex(where: { $0.id == collectionID }) else {
                return
            }
            
            users[userIndex].profileData.collections[collectionIndex].postIDs.removeAll { $0 == postID }
            
            // Update currentUser if needed
            if userID == currentUser.userID {
                currentUser.profileData.collections[collectionIndex].postIDs.removeAll { $0 == postID }
            }
            
            objectWillChange.send()
        }

  
    func logout() {
            // Since currentUser can't be nil, we'll reset it to a default state
            // Assuming you have a default or initial user (like user1) that can be used
            currentUser = user1 // Replace with your initial default user
            
            // Clear any sensitive user-specific data
            currentUser.basicInfo.email = ""
            currentUser.basicInfo.password = ""
            
            // Directly set the root view to LoginView
            let loginView = LoginView()
            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: loginView)
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    func createPost(description: String, tags: [String], image: UIImage) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())

        let newPost = Post(
            id: currentUser.profileData.posts.count + 1,
            userID: currentUser.userID,
            tags: tags,
            postImage: image,
            description: description,
            createdAt: dateString,
            crownCount: 0,
            comments: [],
            isSaved: false,
            isFollowed: false,
            collectionIDs: [],
            isCrowned: false
        )

        // Add the new post to the current user
        currentUser.profileData.posts.insert(newPost, at: 0)

        // Update the global posts list
        posts.insert(newPost, at: 0)

        // Notify SwiftUI of changes
        objectWillChange.send()
    }
    
    func togglePostInCollection(collectionID: Int, postID: Int) {
        guard let collectionIndex = currentUser.profileData.collections.firstIndex(where: { $0.id == collectionID }) else {
            print("Collection not found")
            return
        }
        
        // Check if post is already in collection
        if currentUser.profileData.collections[collectionIndex].postIDs.contains(postID) {
            // Remove post from collection
            updateCollection(
                collectionID: collectionID,
                userID: currentUser.userID,
                removePostIDs: [postID]
            )
        } else {
            // Add post to collection
            updateCollection(
                collectionID: collectionID,
                userID: currentUser.userID,
                addPostIDs: [postID]
            )
        }
    }
    func createCollection(title: String, type: CollectionType, initialPostIDs: [Int] = []) {
            // Generate a new unique collection ID
            let newID = (getAllCollections(forUser: currentUser).map { $0.id }.max() ?? 0) + 1
            
            // Get current date as string
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            let createdAtString = dateFormatter.string(from: Date())
            
            let newCollection = Collection(
                id: newID,
                title: title,
                type: type,
                postIDs: initialPostIDs,
                createdAt: createdAtString
            )
            
            // Add the collection using existing method
            addCollection(newCollection, forUser: currentUser.userID)
        }

}
