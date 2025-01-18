import UIKit
class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    // Outlets for UI elements
    @IBOutlet weak var portfolioButton: UIButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var modelProfileImage: UIImageView!
    @IBOutlet weak var modelProfileName: UILabel!
//    @IBOutlet weak var modelProfilePostCount: UILabel!
    @IBOutlet weak var modelProfileFollowersCount: UILabel!
    @IBOutlet weak var modelProfileFollowingCount: UILabel!
    
    // Model to hold all data (images)
    var profileData = ProfileData()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the collection view delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self

        // Load data (images) for both sections
        loadData()

        // Set default segmented control to first segment
        segmentedControl.selectedSegmentIndex = 0

        // Set up collection view layout
        setCollectionViewLayout()

        // Set initial post count
        updatePostCount()
    }

    // Load sample data (images) into the ProfileData model
    func loadData() {
        if profileData.postImages.isEmpty {
            if let modelImage = UIImage(named: "download-1") {
                profileData.postImages = [modelImage, modelImage, modelImage, modelImage, modelImage, modelImage]
            } else {
                print("Error: Could not load image named 'download' for Post section.")
            }
        }

        if profileData.collectionImages.isEmpty {
            if let agencyImage = UIImage(named: "download-1") {
                profileData.collectionImages = [agencyImage, agencyImage, agencyImage, agencyImage]
            } else {
                print("Error: Could not load image named 'download-1' for Collection section.")
            }
        }
    }

    // Set the collection view layout using compositional layout
    func setCollectionViewLayout() {
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            guard let self = self else { return nil }

            if self.segmentedControl.selectedSegmentIndex == 0 {
                // "Post" Section - Grid layout with 3 items per row
                return self.createGridLayout()
            } else if self.segmentedControl.selectedSegmentIndex == 1 {
                // "Collection" Section - List layout
                return self.createListLayout()
            }

            return nil
        }
    }

    // Create a grid layout for the "Post" section
    private func createGridLayout() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(0.95))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing: 3) // Reduced spacing between items

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.7)) // Slightly increased height
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0 // Set spacing between rows to 0
        return section
    }

    // Create a list layout for the "Collection" section
    private func createListLayout() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(100)) // Reduced height
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4) // Spacing around items

        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(100)) // Match the item height
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 2 // Reduced spacing between rows
        return section
    }

    // Segment control changed, reload collection view with updated layout and update post count label
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        setCollectionViewLayout()
        collectionView.reloadData()
        
        // Update the post count label when "Post" section is selected
        updatePostCount()
    }

    // Method to update the post count label based on the number of images in the "Post" section
    func updatePostCount() {
        if segmentedControl.selectedSegmentIndex == 0 {
            // Update post count label with the count of images in the "Post" section
//            modelProfilePostCount.text = "\(profileData.postImages.count)"
        }
    }

    // MARK: - UICollectionView DataSource Methods

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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCollectionCell", for: indexPath) as! PostCollectionViewCell
            let image = profileData.postImages[indexPath.row]
            cell.imageView.image = image
            cell.imageView.contentMode = .scaleAspectFill
            cell.imageView.clipsToBounds = true
            return cell
        } else if segmentedControl.selectedSegmentIndex == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "post2CollectionCell", for: indexPath) as! Post2CollectionViewCell
            let image = profileData.collectionImages[indexPath.row]
            cell.imageView2.image = image
            cell.imageView2.contentMode = .scaleAspectFill
            cell.imageView2.clipsToBounds = true
            return cell
        }

        return UICollectionViewCell()
    }
}
