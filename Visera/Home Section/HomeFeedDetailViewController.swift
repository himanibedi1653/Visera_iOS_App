//
//  HomeFeedDetailViewController.swift
//  Visera
//
//  Created by student-2 on 17/01/25.
//

import UIKit
class HomeFeedDetailViewController: UIViewController {
    
    // Define the property to hold the feed data
    var homeFeedData: HomeFeed?

    @IBOutlet weak var homeFeedDetailProfileImage: UIImageView!
    @IBOutlet weak var homeFeedDetailProfileName: UILabel!
    @IBOutlet weak var homeFeedDetailProfilePost: UIImageView!
    @IBOutlet weak var homeFeedDetailProfileLikeCount: UILabel!
    @IBOutlet weak var homeFeedDetailProfileCommentCount: UILabel!
    @IBOutlet weak var homeFeedDetailProfileDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Use the data passed to populate the UI
        if let feedData = homeFeedData {
            homeFeedDetailProfileImage.image = feedData.profileImage
            homeFeedDetailProfileName.text = feedData.profileName
            homeFeedDetailProfilePost.image = feedData.postImages.first
            homeFeedDetailProfileLikeCount.text = "\(feedData.likesCount) likes"
            homeFeedDetailProfileCommentCount.text = "\(feedData.commentsCount) comments"
            homeFeedDetailProfileDescription.text = feedData.postDetails
        }
    }
}
