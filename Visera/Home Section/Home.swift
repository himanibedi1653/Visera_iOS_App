//
//  Home.swift
//  Visera
//
//  Created by student-2 on 19/12/24.
//

//import Foundation
//
//import UIKit
//struct HomeEvent{
//    let homeEventImages:UIImage?
//    let homeEventTitle:String
//    let homeEventDateTime:String
//    let homeEventLocation:String
//    let homeEventTimer:String
//    
//}
//struct HomeFeed{
//    var homeFeedProfileImages: UIImage?
//    let homeFeedProfileName:String
//    let homeFeedPostImages:UIImage?
//
//}
//class HomeNotification {
//    var homeNotificationName: String
//    
//    init(homeNotificationName: String) {
//        self.homeNotificationName = homeNotificationName
//    }
//}
import Foundation
import UIKit

struct HomeEvent {
    let image: UIImage?
    let title: String
    let dateTime: String
    let location: String
    let timer: String
}
struct HomeFeed {
    var profileImage: UIImage?
    var profileName: String
    var postImages: [UIImage] // Array to hold multiple post images
    var postFollowers: Int
    var postFollowing: Int
    var noOfPostsCount: Int
    var isCrowned: Bool
    var isFollowed: Bool
    var isSaved: Bool
    var likesCount: Int
    var commentsCount: Int
    var postDetails: String
}

class HomeNotification {
    var homeNotificationName: String

    init(homeNotificationName: String) {
        self.homeNotificationName = homeNotificationName
    }}




struct HomeSearch {
    var homeSearch: String
}
class HomeSearchHandModel {
    var homeSeachImage: UIImage?
    
    init(homeSeachImage: UIImage?) {
        self.homeSeachImage = homeSeachImage
    }
}

struct HomeProfileData {
    var postImages: [UIImage]  // Post images for the "Post" section
    var collectionImages: [UIImage]  // Images for the "Collection" section
    
    init(postImages: [UIImage] = [], collectionImages: [UIImage] = []) {
        self.postImages = postImages
        self.collectionImages = collectionImages
    }
}
struct HomeSearchModel{
    var homeModelImage: UIImage?
    var homeModelName: String
}
