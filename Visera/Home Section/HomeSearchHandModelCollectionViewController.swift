//
//  HomeSearchHandModelCollectionViewController.swift
//  Visera
//
//  Created by Divya Arora on 17/12/24.
//

import UIKit

private let homeSearchHandModelIdentifier = "HomeSearchHandModelCell"
private let headerReusableIdentifier = "Header"
class HomeSearchHandModelCollectionViewController: UICollectionViewController {
    private var homeSearchData: [HomeSearchHandModel] = [
        HomeSearchHandModel(homeSeachImage: UIImage(named: "Home_HandModel1")),
        HomeSearchHandModel(homeSeachImage: UIImage(named: "Home_HandModel2")),
        HomeSearchHandModel(homeSeachImage: UIImage(named: "Home_HandModel3")),
        HomeSearchHandModel(homeSeachImage: UIImage(named: "Home_HandModel4")),
        HomeSearchHandModel(homeSeachImage: UIImage(named: "Home_HandModel5")),
        HomeSearchHandModel(homeSeachImage: UIImage(named: "Home_HandModel6")),
    ]
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var section: NSCollectionLayoutSection
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
            default:
                return nil
            }
            return section
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.register(HeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerReusableIdentifier)
        // Register the collection view cell
   
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeSearchData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeSearchHandModelIdentifier, for: indexPath) as! HomeSearchHandModelCollectionViewCell
        let model = homeSearchData[indexPath.row]
        
        // Configure the cell with image
        cell.seachHomeHandImage.image = model.homeSeachImage
        return cell
    }
    class HeaderReusableView: UICollectionReusableView {
            
            private let label: UILabel = {
                let label = UILabel()
                label.font = UIFont.boldSystemFont(ofSize: 18)
                label.textColor = .label
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            override init(frame: CGRect) {
                super.init(frame: frame)
                addSubview(label)
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
                    label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
                    label.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])
            }
            
            required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
            }
            
            func configure(with text: String) {
                label.text = text
            }
        }
    // MARK: UICollectionViewDelegate

    // Add any delegate methods as needed (e.g., selection, highlight, etc.)
}

