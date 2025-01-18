
//  HomeSearchCollectionViewController.swift
//  Visera
//
//  Created by Divya Arora on 17/12/24.
//
//
//import UIKit
//private let homeSeachModelIdentifier = "HomeSearchModelCell"
//private let homeSearchIdentifier = "HomeSearchCell"
//private let headerReusableIdentifier = "Header"
//class HomeSearchCollectionViewController: UICollectionViewController, UISearchBarDelegate {
//    
//    // Existing home search data
//    private var homeSearchData: [HomeSearch] = [
//        HomeSearch(homeSearch: "Hand Model"),
//        HomeSearch(homeSearch: "Fashion Model"),
//        HomeSearch(homeSearch: "Runway Model"),
//        HomeSearch(homeSearch: "Plus-Size Model"),
//        HomeSearch(homeSearch: "Fitness Model"),
//    ]
//    
//    // New HomeSearchModel section data
//    private var homeSearchModels: [HomeSearchModel] = [
//        HomeSearchModel(homeModelImage: UIImage(named: "Model2"), homeModelName: "John Doe"),
//        HomeSearchModel(homeModelImage: UIImage(named: "Model2"), homeModelName: "John Doe"),
//        HomeSearchModel(homeModelImage: UIImage(named: "Model2"), homeModelName: "John Doe"),
//    ]
//    
//    private var filteredSearchData: [HomeSearch] = [] // Holds filtered results for home search
//    private let searchBar = UISearchBar() // Search bar instance
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Initialize filtered data
//        filteredSearchData = homeSearchData
//        
//        // Setup search bar
//        setupSearchBar()
//        
//        // Adjust collection view layout
//        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) // Make space for search bar
//        //collectionView.register(HomeSearchModelCollectionViewCell.self, forCellWithReuseIdentifier: homeSeachModelIdentifier)
//                
//                // Register HomeSearch cell class or nib
//        //        collectionView.register(HomeSearchCollectionViewCell.self, forCellWithReuseIdentifier: homeSearchIdentifier)
//        // Register header
////        collectionView.register(HeaderReusableView.self,
////                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
////                                withReuseIdentifier: headerReusableIdentifier)
//        collectionView.collectionViewLayout = createCompositionalLayout()
//    }
//    
//    private func setupSearchBar() {
//        searchBar.delegate = self
//        searchBar.placeholder = "Search Models"
//        searchBar.sizeToFit()
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchBar) // Add search bar to the view
//        
//        // Constraints for search bar
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            searchBar.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//    
//    // MARK: UISearchBarDelegate Methods
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredSearchData = homeSearchData
//        } else {
//            filteredSearchData = homeSearchData.filter { $0.homeSearch.lowercased().contains(searchText.lowercased()) }
//        }
//        collectionView.reloadData() // Reload collection view with filtered results
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder() // Dismiss keyboard on search button click
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        filteredSearchData = homeSearchData
//        collectionView.reloadData() 
//        searchBar.resignFirstResponder()
//    }
//    
//    func createCompositionalLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            var section: NSCollectionLayoutSection
//            
//            // First Section - HomeSearch Models (Horizontal Scrolling)
//            if sectionIndex == 0 {
//                let itemSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(0.5),
//                    heightDimension: .fractionalHeight(0.3))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//                
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(0.7),
//                    heightDimension: .fractionalHeight(0.5))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                
//                section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .groupPaging
//            }
//            // Second Section - HomeSearchModel (Vertical List)
//            else if sectionIndex == 1 {
//                let itemSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .absolute(80))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//                
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .estimated(100))
//                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//                
//                section = NSCollectionLayoutSection(group: group)
//            } else {
//                return nil
//            }
//            
//            // Adding Header
//            let headerSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .absolute(50))
//            let header = NSCollectionLayoutBoundarySupplementaryItem(
//                layoutSize: headerSize,
//                elementKind: UICollectionView.elementKindSectionHeader,
//                alignment: .top)
//            section.boundarySupplementaryItems = [header]
//            
//            return section
//        }
//    }
//    
//    // MARK: UICollectionViewDataSource
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 2 // Two sections
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return filteredSearchData.count
//        } else {
//            return homeSearchModels.count
//        }
//    }
//  
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.section == 0 {
//            // HomeSearch Cell
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeSearchIdentifier, for: indexPath) as? HomeSearchCollectionViewCell {
//                // Configure the cell
//                let model = filteredSearchData[indexPath.row]
//                cell.homeSearchLabel.text = model.homeSearch
//                return cell
//            } else {
//                fatalError("Unable to dequeue HomeSearchCollectionViewCell")
//            }
//        } else {
//            // HomeSearchModel Cell (List Style)
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeSeachModelIdentifier, for: indexPath) as? HomeSearchModelCollectionViewCell {
//                // Configure the cell
//                let model = homeSearchModels[indexPath.row]
//                
//                // Safely unwrap the homeSearchModelLabel and update the label text
//                if let label = cell.homeSearchModelLabel {
//                    label.text = model.homeModelName
//                } else {
//                    print("Error: homeSearchModelLabel is nil!")
//                }
//                
//                // Update the image
//                cell.homeSearchModelImage.image = model.homeModelImage
//                return cell
//            } else {
//                fatalError("Unable to dequeue HomeSearchModelCollectionViewCell")
//            }
//        }
//    }
//
//  
//    class HeaderReusableView: UICollectionReusableView {
//        
//        private let label: UILabel = {
//            let label = UILabel()
//            label.font = UIFont.boldSystemFont(ofSize: 18)
//            label.textColor = .label
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
//        
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            addSubview(label)
//            NSLayoutConstraint.activate([
//                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//                label.centerYAnchor.constraint(equalTo: centerYAnchor)
//            ])
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        func configure(with text: String) {
//            label.text = text
//        }
//    }
//    //    class HeaderReusableView: UICollectionReusableView {
//    //
//    //        private let label: UILabel = {
//    //            let label = UILabel()
//    //            label.font = UIFont.boldSystemFont(ofSize: 18)
//    //            label.textColor = .label
//    //            label.translatesAutoresizingMaskIntoConstraints = false
//    //            return label
//    //        }()
//    //
//    //        override init(frame: CGRect) {
//    //            super.init(frame: frame)
//    //            addSubview(label)
//    //            NSLayoutConstraint.activate([
//    //                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//    //                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//    //                label.centerYAnchor.constraint(equalTo: centerYAnchor)
//    //            ])
//    //        }
//    //
//    //        required init?(coder: NSCoder) {
//    //            fatalError("init(coder:) has not been implemented")
//    //        }
//    //
//    //        func configure(with text: String) {
//    //            label.text = text
//    //        }
//    //    }
//    //}
//}
//import UIKit
//
//private let homeSeachModelIdentifier = "HomeSearchModelCell"
//private let homeSearchIdentifier = "HomeSearchCell"
//private let headerReusableIdentifier = "Header"
//
//class HomeSearchCollectionViewController: UICollectionViewController, UISearchBarDelegate {
//    
//    // Existing home search data
//    private var homeSearchData: [HomeSearch] = [
//        HomeSearch(homeSearch: "Hand Model"),
//        HomeSearch(homeSearch: "Fashion Model"),
//        HomeSearch(homeSearch: "Runway Model"),
//        HomeSearch(homeSearch: "Plus-Size Model"),
//        HomeSearch(homeSearch: "Fitness Model"),
//    ]
//    
//    // New HomeSearchModel section data
//    private var homeSearchModels: [HomeSearchModel] = [
//        HomeSearchModel(homeModelImage: UIImage(named: "Model2"), homeModelName: "John Doe"),
//        HomeSearchModel(homeModelImage: UIImage(named: "Model2"), homeModelName: "Jane Smith"),
//        HomeSearchModel(homeModelImage: UIImage(named: "Model2"), homeModelName: "Mike Johnson"),
//    ]
//    
//    private var filteredSearchData: [HomeSearch] = [] // Holds filtered results for home search
//    private var filteredModels: [HomeSearchModel] = [] // Holds filtered results for models
//    private let searchBar = UISearchBar() // Search bar instance
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Initialize filtered data
//        filteredSearchData = homeSearchData
//        filteredModels = homeSearchModels
//        
//        // Setup search bar
//        setupSearchBar()
//        
//        // Adjust collection view layout
//        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) // Make space for search bar
//        
//        // Register HomeSearch cell class or nib
////        collectionView.register(HomeSearchCollectionViewCell.self, forCellWithReuseIdentifier: homeSearchIdentifier)
////        collectionView.register(HomeSearchModelCollectionViewCell.self, forCellWithReuseIdentifier: homeSeachModelIdentifier)
////                
//        // Register header
//        collectionView.register(HeaderReusableView.self,
//                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
//                                withReuseIdentifier: headerReusableIdentifier)
//        collectionView.collectionViewLayout = createCompositionalLayout()
//    }
//    
//    private func setupSearchBar() {
//        searchBar.delegate = self
//        searchBar.placeholder = "Search Models"
//        searchBar.sizeToFit()
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(searchBar) // Add search bar to the view
//        
//        // Constraints for search bar
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            searchBar.heightAnchor.constraint(equalToConstant: 50)
//        ])
//    }
//    
//    // MARK: UISearchBarDelegate Methods
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText.isEmpty {
//            filteredSearchData = homeSearchData
//            filteredModels = homeSearchModels
//        } else {
//            // Filter homeSearchData
//            filteredSearchData = homeSearchData.filter { $0.homeSearch.lowercased().contains(searchText.lowercased()) }
//            
//            // Filter homeSearchModels based on the search text
//            filteredModels = homeSearchModels.filter { $0.homeModelName.lowercased().contains(searchText.lowercased()) }
//        }
//        
//        collectionView.reloadData() // Reload collection view with filtered results
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder() // Dismiss keyboard on search button click
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        filteredSearchData = homeSearchData
//        filteredModels = homeSearchModels
//        collectionView.reloadData()
//        searchBar.resignFirstResponder()
//    }
//    
//    func createCompositionalLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            var section: NSCollectionLayoutSection
//            
//            // First Section - HomeSearch Models (Horizontal Scrolling)
//            if sectionIndex == 0 {
//                let itemSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(0.5),
//                    heightDimension: .fractionalHeight(0.3))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//                
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(0.7),
//                    heightDimension: .fractionalHeight(0.5))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//                
//                section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .groupPaging
//            }
//            // Second Section - HomeSearchModel (Vertical List)
//            else if sectionIndex == 1 {
//                let itemSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .absolute(80))
//                let item = NSCollectionLayoutItem(layoutSize: itemSize)
//                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
//                
//                let groupSize = NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .estimated(100))
//                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//                
//                section = NSCollectionLayoutSection(group: group)
//            } else {
//                return nil
//            }
//            
//            // Adding Header
//            let headerSize = NSCollectionLayoutSize(
//                widthDimension: .fractionalWidth(1.0),
//                heightDimension: .absolute(50))
//            let header = NSCollectionLayoutBoundarySupplementaryItem(
//                layoutSize: headerSize,
//                elementKind: UICollectionView.elementKindSectionHeader,
//                alignment: .top)
//            section.boundarySupplementaryItems = [header]
//            
//            return section
//        }
//    }
//    
//    // MARK: UICollectionViewDataSource
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // Show Section 1 only when there are matching models
//        if filteredModels.isEmpty {
//            return 1 // Only show Section 0 when no search results for models
//        } else {
//            return 2 // Show both sections when there are search results
//        }
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0 {
//            return filteredSearchData.count // Number of items in filtered search
//        } else {
//            return filteredModels.count // Number of items in filtered models
//        }
//    }
//  
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.section == 0 {
//            // HomeSearch Cell
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeSearchIdentifier, for: indexPath) as? HomeSearchCollectionViewCell {
//                // Configure the cell
//                let model = filteredSearchData[indexPath.row]
//                cell.homeSearchLabel.text = model.homeSearch
//                return cell
//            } else {
//                fatalError("Unable to dequeue HomeSearchCollectionViewCell")
//            }
//        } else {
//            // HomeSearchModel Cell (List Style)
//            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeSeachModelIdentifier, for: indexPath) as? HomeSearchModelCollectionViewCell {
//                // Configure the cell
//                let model = filteredModels[indexPath.row]
//                
//                // Safely unwrap the homeSearchModelLabel and update the label text
//                if let label = cell.homeSearchModelLabel {
//                    label.text = model.homeModelName
//                } else {
//                    print("Error: homeSearchModelLabel is nil!")
//                }
//                
//                // Update the image
//                cell.homeSearchModelImage.image = model.homeModelImage
//                return cell
//            } else {
//                fatalError("Unable to dequeue HomeSearchModelCollectionViewCell")
//            }
//        }
//    }
//
//    class HeaderReusableView: UICollectionReusableView {
//        
//        private let label: UILabel = {
//            let label = UILabel()
//            label.font = UIFont.boldSystemFont(ofSize: 18)
//            label.textColor = .label
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
//        
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            addSubview(label)
//            NSLayoutConstraint.activate([
//                label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
//                label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//                label.centerYAnchor.constraint(equalTo: centerYAnchor)
//            ])
//        }
//        
//        required init?(coder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }
//        
//        func configure(with text: String) {
//            label.text = text
//        }
//    }
//}
import UIKit

private let homeSeachModelIdentifier = "HomeSearchModelCell"
private let homeSearchIdentifier = "HomeSearchCell"
private let headerReusableIdentifier = "Header"

class HomeSearchCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    // Existing home search data
    private var homeSearchData: [HomeSearch] = [
        HomeSearch(homeSearch: "Hand Model"),
        HomeSearch(homeSearch: "Fashion Model"),
        HomeSearch(homeSearch: "Runway Model"),
        HomeSearch(homeSearch: "Plus-Size Model"),
        HomeSearch(homeSearch: "Fitness Model"),
    ]
    
    // New HomeSearchModel section data
    private var homeSearchModels: [HomeSearchModel] = [
        HomeSearchModel(homeModelImage: UIImage(named: "Model2"), homeModelName: "John Doe"),
        HomeSearchModel(homeModelImage: UIImage(named: "Model2"), homeModelName: "Jane Smith"),
        HomeSearchModel(homeModelImage: UIImage(named: "Model2"), homeModelName: "Mike Johnson"),
    ]
    
    private var filteredSearchData: [HomeSearch] = [] // Holds filtered results for home search
    private var filteredModels: [HomeSearchModel] = [] // Holds filtered results for models
    private let searchBar = UISearchBar() // Search bar instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize filtered data
        filteredSearchData = homeSearchData
        filteredModels = homeSearchModels
        
        // Setup search bar
        setupSearchBar()
        
        // Adjust collection view layout
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0) // Make space for search bar
        
        // Register header
        collectionView.register(HeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerReusableIdentifier)
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Models"
        searchBar.sizeToFit()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar) // Add search bar to the view
        
        // Constraints for search bar
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // MARK: UISearchBarDelegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredSearchData = homeSearchData
            filteredModels = homeSearchModels
        } else {
            // Filter homeSearchData
            filteredSearchData = homeSearchData.filter { $0.homeSearch.lowercased().contains(searchText.lowercased()) }
            
            // Filter homeSearchModels based on the search text
            filteredModels = homeSearchModels.filter { $0.homeModelName.lowercased().contains(searchText.lowercased()) }
        }
        
        collectionView.reloadData() // Reload collection view with filtered results
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss keyboard on search button click
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredSearchData = homeSearchData
        filteredModels = homeSearchModels
        collectionView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func createCompositionalLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            var section: NSCollectionLayoutSection
            
            // First Section - HomeSearch Models (Horizontal Scrolling)
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.5),
                    heightDimension: .fractionalHeight(0.3))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.7),
                    heightDimension: .fractionalHeight(0.5))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
            }
            // Second Section - HomeSearchModel (Vertical List)
            else if sectionIndex == 1 {
                // If no models are found, return nil to hide the section
                if self.filteredModels.isEmpty {
                    return nil
                }
                
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(80))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
            } else {
                return nil
            }
            
            // Adding Header
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Show Section 1 only if there are filtered models
        if filteredModels.isEmpty {
            return 1 // Only show Section 0 when no matching models are found
        } else {
            return 2 // Show both sections when there are matching models
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return filteredSearchData.count // Number of items in filtered home search
        } else {
            return filteredModels.count // Number of items in filtered models
        }
    }
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            // HomeSearch Cell
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeSearchIdentifier, for: indexPath) as? HomeSearchCollectionViewCell {
                // Configure the cell
                let model = filteredSearchData[indexPath.row]
                cell.homeSearchLabel.text = model.homeSearch
                return cell
            } else {
                fatalError("Unable to dequeue HomeSearchCollectionViewCell")
            }
        } else {
            // HomeSearchModel Cell (List Style)
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeSeachModelIdentifier, for: indexPath) as? HomeSearchModelCollectionViewCell {
                // Configure the cell
                let model = filteredModels[indexPath.row]
                
                // Safely unwrap the homeSearchModelLabel and update the label text
                if let label = cell.homeSearchModelLabel {
                    label.text = model.homeModelName
                } else {
                    print("Error: homeSearchModelLabel is nil!")
                }
                
                // Update the image
                cell.homeSearchModelImage.image = model.homeModelImage
                return cell
            } else {
                fatalError("Unable to dequeue HomeSearchModelCollectionViewCell")
            }
        }
    }

    // Provide custom headers for sections
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReusableIdentifier, for: indexPath) as? HeaderReusableView else {
                fatalError("Unable to dequeue HeaderReusableView")
            }
            
            // Customize header text based on section index
            if indexPath.section == 0 {
                headerView.configure(with: "Suggestions")
            } else if indexPath.section == 1 {
                headerView.configure(with: "Find Models")
            }
            
            return headerView
        }
        return UICollectionReusableView()
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
}
