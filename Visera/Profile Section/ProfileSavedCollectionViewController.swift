//
//  ProfileSavedCollectionViewController.swift
//  Visera
//
//  Created by Divya Arora on 16/01/25.
//

import UIKit

private let profileSavedCellIdentifier = "ProfileSavedCell"

class ProfileSavedCollectionViewController: UICollectionViewController {
    private var profileSavedData: [ProfileSavedModel] = [
        ProfileSavedModel(image: UIImage(named: "HomePost1")),
        ProfileSavedModel(image: UIImage(named: "Model1")),
        ProfileSavedModel(image: UIImage(named: "HomePost1")),
        ProfileSavedModel(image: UIImage(named: "Model1")),
        ProfileSavedModel(image: UIImage(named: "HomePost1")),
        ProfileSavedModel(image: UIImage(named: "Model1"))
    ]
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createCompositionalLayout()
        // Register the cell
//        collectionView.register(UINib(nibName: "ProfileSavedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: profileSavedCellIdentifier)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileSavedData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileSavedCellIdentifier, for: indexPath) as! ProfileSavedCollectionViewCell
        let model = profileSavedData[indexPath.row]
        
        // Configure the cell
        cell.profileSavedImageView.image = model.image
        return cell
    }
}
