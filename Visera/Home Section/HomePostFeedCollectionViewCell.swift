//
//  HomePostFeedCollectionViewCell.swift
//  Visera
//
//  Created by student-2 on 19/12/24.
//

import UIKit
protocol HomePostFeedCollectionViewCellDelegate: AnyObject {
    func crownButtonTappedForNotification(message: String)
    func followButtonTappedForFeed(at indexPath: IndexPath)  // New delegate method for follow
}
class HomePostFeedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var homeFeedProfileImage: UIImageView!
    @IBOutlet weak var homeFeedProfileLabel: UILabel!
    @IBOutlet weak var homeFeedPostImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var crownImageView: UIButton!

    var isFollowing = false {
        didSet {
            updateFollowButtonState() // Update follow button when the state changes
        }
    }
    var isCrownFilled = false {
        didSet {
            updateCrownButtonImage() // Update crown button when the state changes
        }
    }

    var indexPath: IndexPath?
    weak var delegate: HomePostFeedCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        updateFollowButtonState()
        updateCrownButtonImage()
    }

    @IBAction func followButtonTapped(_ sender: Any) {
        isFollowing.toggle()
        if let indexPath = indexPath {
            delegate?.followButtonTappedForFeed(at: indexPath)
        }
    }

    @IBAction func crownButtonTapped(_ sender: Any) {
        isCrownFilled.toggle()
        if let indexPath = indexPath {
            delegate?.crownButtonTappedForNotification(message: "A user liked your pic")
        }
    }

    private func updateFollowButtonState() {
        if isFollowing {
            followButton.setTitle("Following", for: .normal)
        } else {
            followButton.setTitle("Follow", for: .normal)
        }
    }

    private func updateCrownButtonImage() {
        if isCrownFilled {
            crownImageView.setImage(UIImage(systemName: "crown.fill"), for: .normal)
        } else {
            crownImageView.setImage(UIImage(systemName: "crown"), for: .normal)
        }
    }
}
