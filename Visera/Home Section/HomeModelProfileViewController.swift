//
//  HomeModelProfileViewController.swift
//  Visera
//
//  Created by student-2 on 16/01/25.
//
import UIKit

protocol HomeModelProfileDelegate: AnyObject {
    func didUpdateFollowStatus(isFollowed: Bool, followersCount: Int)
}

class HomeModelProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    weak var delegate: HomeModelProfileDelegate?
    var profileData = ProfileData()
    var feedData: HomeFeed?

    @IBOutlet weak var portfolioButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var modelProfileImage: UIImageView!
    @IBOutlet weak var modelProfileName: UILabel!
    @IBOutlet weak var modelProfilePostCount: UILabel!
    @IBOutlet weak var modelProfileFollowersCount: UILabel!
    @IBOutlet weak var modelProfileFollowingCount: UILabel!
    @IBOutlet weak var homeModelFollowButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Update profile data if available
        if let data = feedData {
            modelProfileName.text = data.profileName
            modelProfileImage.image = data.profileImage
            modelProfilePostCount.text = "\(data.noOfPostsCount)"
            modelProfileFollowersCount.text = "\(data.postFollowers)"
            modelProfileFollowingCount.text = "\(data.postFollowing)"

            let followTitle = data.isFollowed ? "Following" : "Follow"
            homeModelFollowButton.setTitle(followTitle, for: .normal)
        }

        // Set up collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        loadData()
        setCollectionViewLayout()
        updatePostCount()
    }

    // MARK: - Data Loading
    func loadData() {
        loadPostImages()
        loadCollectionImages()
    }

    private func loadPostImages() {
        if profileData.postImages.isEmpty {
            if let modelImage = UIImage(named: "Model2") {
                profileData.postImages = Array(repeating: modelImage, count: 6)
            } else {
                print("Error: Could not load image named 'Model2' for Post section.")
            }
        }
    }

    private func loadCollectionImages() {
        if profileData.collectionImages.isEmpty {
            if let agencyImage = UIImage(named: "download-1") {
                profileData.collectionImages = Array(repeating: agencyImage, count: 4)
            } else {
                print("Error: Could not load image named 'download-1' for Collection section.")
            }
        }
    }

    // MARK: - Collection View Layout
    func setCollectionViewLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }

            if self.segmentedControl.selectedSegmentIndex == 0 {
                return self.createGridLayout()
            } else if self.segmentedControl.selectedSegmentIndex == 1 {
                return self.createListLayout()
            }
            return nil
        }
    }

    private func createGridLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.95))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.7))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        return section
    }

    private func createListLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2
        return section
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        setCollectionViewLayout()
        collectionView.reloadData()
        updatePostCount()
    }

    func updatePostCount() {
        if segmentedControl.selectedSegmentIndex == 0 {
            modelProfilePostCount.text = "\(profileData.postImages.count)"
        }
    }

    // MARK: - Collection View DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return profileData.postImages.count
        } else if segmentedControl.selectedSegmentIndex == 1 {
            return profileData.collectionImages.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if segmentedControl.selectedSegmentIndex == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homePostCollectionCell", for: indexPath) as! HomePostCollectionViewCell
            let image = profileData.postImages[indexPath.row]
            cell.imageView.image = image
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.clipsToBounds = true
            return cell
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homePost2CollectionCell", for: indexPath) as! HomePost2CollectionViewCell
            let image = profileData.collectionImages[indexPath.row]
            cell.imageView2.image = image
            cell.imageView2.contentMode = .scaleAspectFill
            cell.imageView2.clipsToBounds = true
            return cell
        }
        return UICollectionViewCell()
    }

   

    // MARK: - Follow Button Action
    @IBAction func homeModelFollowButtonTapped(_ sender: UIButton) {
        guard var data = feedData else { return }

        data.isFollowed.toggle()
        sender.setTitle(data.isFollowed ? "Following" : "Follow", for: .normal)
        data.postFollowers += data.isFollowed ? 1 : -1
        modelProfileFollowersCount.text = "\(data.postFollowers)"
        delegate?.didUpdateFollowStatus(isFollowed: data.isFollowed, followersCount: data.postFollowers)
        feedData = data
    }

    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowPostDetail",
//           let destinationVC = segue.destination as? HomePostModelDetailCollectionViewController {
//            destinationVC.feedData = feedData
//        }
//    }
}
