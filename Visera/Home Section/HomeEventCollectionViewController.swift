//
//  HomeEventCollectionViewController.swift
//  Visera
//
//  Created by Divya Arora on 17/12/24.
//

import UIKit

private let homeEventIdentifier = "HomeEventCell"
private let homeFeedIdentifier = "HomeFeedCell"
private let headerReuseIdentifier = "Header"
private let placeholderCellIdentifier = "PlaceholderCell"

class HomeEventCollectionViewController: UICollectionViewController,HomeModelProfileDelegate {

    // Define the border color for the button based on settings
    let buttonBorderColor = UIColor(red: 162/255, green: 121/255, blue: 13/255, alpha: 1)
    // Define the border thickness
    let borderThickness: CGFloat = 2.0

    // MARK: - Data Source
    let homeEvents: [HomeEvent] = [
        // Example events (can be populated with real data)
         HomeEvent(image: UIImage(named: "event1"), title: "Runway Casting Call", dateTime: "Sunday, 8:00 AM", location: "Film City, Goregaon", timer: "Starts in 1d 20h 12m")
    ]
    
    var homeFeedData: [HomeFeed] = [
        HomeFeed(profileImage: UIImage(named: "Model5"),
                 profileName: "ABC Model",
                 postImages: [UIImage(named: "Model5")].compactMap { $0 },
                 postFollowers: 100,
                 postFollowing: 300,
                 noOfPostsCount: 120,
                 isCrowned: false,
                 isFollowed: false,
                 isSaved: false,
                 likesCount: 500,
                 commentsCount: 45,
                 postDetails: "This is a stunning shot from my latest portfolio!"),

        HomeFeed(profileImage: UIImage(named: "Model2"),
                 profileName: "Gigi Hadid",
                 postImages: [UIImage(named: "Model2")].compactMap { $0 },
                 postFollowers: 800,
                 postFollowing: 400,
                 noOfPostsCount: 95,
                 isCrowned: true,
                 isFollowed: false,
                 isSaved: false,
                 likesCount: 1200,
                 commentsCount: 80,
                 postDetails: "Runway memories from Paris Fashion Week."),

        HomeFeed(profileImage: UIImage(named: "Model3"),
                 profileName: "Kendall Jenner",
                 postImages: [UIImage(named: "Model3")].compactMap { $0 },
                 postFollowers: 120,
                 postFollowing: 500,
                 noOfPostsCount: 110,
                 isCrowned: false,
                 isFollowed: false,
                 isSaved: false,
                 likesCount: 1500,
                 commentsCount: 200,
                 postDetails: "Excited to share my new collaboration with Vogue!"),

        HomeFeed(profileImage: UIImage(named: "Model4"),
                 profileName: "Bella Hadid",
                 postImages: [UIImage(named: "Model4")].compactMap { $0 },
                 postFollowers: 950,
                 postFollowing: 320,
                 noOfPostsCount: 90,
                 isCrowned: false,
                 isFollowed: false,
                 isSaved: false,
                 likesCount: 980,
                 commentsCount: 100,
                 postDetails: "A sneak peek into my latest photo shoot.")
    ]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell and supplementary views
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: placeholderCellIdentifier)
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerReuseIdentifier)
        
        collectionView.setCollectionViewLayout(createCompositionalLayout(), animated: false)
    }
    
    // MARK: - Layout Configuration
    func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var section: NSCollectionLayoutSection
            
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(0.8))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .fractionalHeight(0.29))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                          elementKind: UICollectionView.elementKindSectionHeader,
                                                                          alignment: .top)
                section.boundarySupplementaryItems = [header]
            } else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                      heightDimension: .fractionalHeight(1))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                        heightDimension: .fractionalHeight(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                          elementKind: UICollectionView.elementKindSectionHeader,
                                                                          alignment: .top)
                section.boundarySupplementaryItems = [header]
            }
            
            return section
        }
    }
    
    // MARK: - Data Source Methods
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2  // One section for HomeEvent and one for HomeFeed
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? (homeEvents.isEmpty ? 1 : homeEvents.count) : homeFeedData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if homeEvents.isEmpty {
                // Display placeholder cell
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: placeholderCellIdentifier, for: indexPath)
                cell.contentView.subviews.forEach { $0.removeFromSuperview() }
                
                let label = UILabel(frame: cell.contentView.bounds)
                label.text = "Your Event Journey Starts Here! \n Register Now and Make it Memorable!"
                label.textAlignment = .center
                label.textColor = .gray
                label.numberOfLines = 2
                label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
                cell.contentView.addSubview(label)
                
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
                cell.contentView.layer.cornerRadius = 25
                cell.contentView.layer.masksToBounds = true
                cell.contentView.layer.borderColor = buttonBorderColor.cgColor
                cell.contentView.layer.borderWidth = borderThickness
                
                return cell
            } else {
                // Handle HomeEventCell
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeEventIdentifier, for: indexPath) as? HomeEventCollectionViewCell else {
                    fatalError("Unable to dequeue HomeEventCollectionViewCell")
                }
                
                let event = homeEvents[indexPath.item]
                cell.homeEventImage.image = event.image
                cell.homeEventTitleLabel.text = event.title
                cell.homeEventDateTimeLabel.text = event.dateTime
                cell.homeEventLocationLabel.text = event.location
                cell.homeEventTimerLabel.text = event.timer
                
                cell.contentView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
                cell.contentView.layer.cornerRadius = 25
                cell.contentView.layer.masksToBounds = true
                cell.contentView.layer.borderColor = buttonBorderColor.cgColor
                cell.contentView.layer.borderWidth = borderThickness
                
                return cell
            }
        } else {
            // Handle HomeFeedCell
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeFeedIdentifier, for: indexPath) as? HomePostFeedCollectionViewCell else {
                fatalError("Unable to dequeue HomePostFeedCollectionViewCell")
            }
            
            let feed = homeFeedData[indexPath.item]
                        cell.homeFeedProfileImage.image = feed.profileImage
                        cell.homeFeedProfileLabel.text = feed.profileName
            cell.homeFeedPostImage.image=feed.postImages[0]
                        cell.indexPath = indexPath
                        cell.delegate = self
                    
                    // Set initial button states based on the `HomeFeed` model
                    cell.isFollowing = feed.isFollowed
                    cell.isCrownFilled = feed.isCrowned
            let profileNameTapGesture = UITapGestureRecognizer(target: self, action: #selector(profileNameTapped(_:)))
            let postImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(postImageTapped(_:)))

            // Add gestures to profileName and postImage UI elements
       

            // Add gestures to profile name and post image UI elements
            cell.homeFeedProfileLabel.addGestureRecognizer(profileNameTapGesture)  // Use `homeFeedProfileLabel`
            //cell.homeFeedProfileLabel.isUserInteractionEnabled = false

            cell.homeFeedPostImage.addGestureRecognizer(postImageTapGesture)  // Use `homeFeedPostImage`
           // cell.homeFeedPostImage.isUserInteractionEnabled = false
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 { // Home Feed section
            let selectedItem = homeFeedData[indexPath.item]
            
            // Check the condition based on the properties of the HomeFeed object
            if selectedItem.profileName != nil {  // Assuming profileName should not be nil for a feed
                // It's a Feed
                performSegue(withIdentifier: "showFeedData", sender: self)
            } else if selectedItem.postImages.count > -1 {  // Assuming postImages should not be empty for a post
                // It's a Post
                performSegue(withIdentifier: "ShowPostDetail", sender: self)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier, for: indexPath)
        
        header.subviews.forEach { $0.removeFromSuperview() }
        
        let label = UILabel(frame: header.bounds)
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.textColor = .black
        label.textAlignment = .left
        
        label.text = indexPath.section == 0 ? "  Registered Events" : "  Home Feed"
        
        header.addSubview(label)
        return header
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFeedData" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first, indexPath.section == 1 {
                let selectedFeed = homeFeedData[indexPath.item]
                
                if let destinationVC = segue.destination as? HomeModelProfileViewController {
                    destinationVC.feedData = selectedFeed  // Pass the selected feed data
                    destinationVC.delegate = self  // Set the delegate to self (HomeEventCollectionViewController)
                }
            }
        } else if segue.identifier == "ShowPostDetail" {
            if let indexPath = collectionView.indexPathsForSelectedItems?.first, indexPath.section == 1 {
                let selectedFeed = homeFeedData[indexPath.item]
                
                if let destinationVC = segue.destination as? HomeFeedDetailViewController {
                    print("**********************\(homeFeedData)******************************")
                    destinationVC.homeFeedData = selectedFeed  // Pass the selected feed data to the detail view controller
                }
            }
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowPostDetail" {
//            if let indexPath = collectionView.indexPathsForSelectedItems?.first, indexPath.section == 1 {
//                let selectedFeed = homeFeedData[indexPath.item]
//
//                if let destinationVC = segue.destination as? HomePostModelDetailCollectionViewController {
//                    destinationVC.feedData = selectedFeed  // Pass the selected feed data to the detail view controller
//                }
//            }
//        }
//    }

    // Assuming these are set up in your cell setup or view lifecycle
   
    @objc func profileNameTapped(_ gesture: UITapGestureRecognizer) {
        // Get the indexPath of the cell where the profile name was tapped
        if let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) {
            if indexPath.section == 1 { // Home Feed section
                performSegue(withIdentifier: "showFeedData", sender: self)
            }
        }
    }

    @objc func postImageTapped(_ gesture: UITapGestureRecognizer) {
        // Get the indexPath of the cell where the post image was tapped
        if let indexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) {
            if indexPath.section == 1 { // Home Feed section
                performSegue(withIdentifier: "ShowPostDetail", sender: self)
            }
        }
    }


    func didUpdateFollowStatus(isFollowed: Bool, followersCount: Int) {
           // Update the model data in HomeEventCollectionViewController
           if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
               var feed = homeFeedData[selectedIndexPath.item]
               feed.isFollowed = isFollowed
               feed.postFollowers = followersCount

               // Update the data model
               homeFeedData[selectedIndexPath.item] = feed

               // Reload the updated item
               collectionView.reloadItems(at: [selectedIndexPath])
           }
       }
   

}
extension HomeEventCollectionViewController: HomePostFeedCollectionViewCellDelegate {

    // This method will handle the "Follow" button taps and update the `HomeFeed` model
    func followButtonTappedForFeed(at indexPath: IndexPath) {
        // Get the selected feed model
        var feed = homeFeedData[indexPath.item]

        // Toggle the follow state
        feed.isFollowed.toggle()
        
        // Update the followers count
        if feed.isFollowed {
            feed.postFollowers += 1
        } else {
            feed.postFollowers -= 1
        }

        // Update the feed in the data model
        homeFeedData[indexPath.item] = feed
        
        // Optionally, update the UI (e.g., reload cell or update labels)
        collectionView.reloadItems(at: [indexPath])
    }

    // This method will handle the "Crown" button taps and update the `HomeFeed` model
    func crownButtonTappedForNotification(message: String) {
        // You can display a notification message or perform other actions
        print(message)  // Just printing for now
    }
}
