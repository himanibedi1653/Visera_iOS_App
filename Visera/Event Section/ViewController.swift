//
//  ViewController.swift
//  Visera-HomeScreen
//
//  Created by student-2 on 15/01/25.
//

import UIKit

private let reuseIdentifier = "EventCell"
private let headerReuseIdentifier = "header"


private var eventsData: [[Event]] = [
    [Event(
        id: 1,
        portraitImage: UIImage(named: "Event1 1")!,
        landscapeImage: UIImage(named: "Event1 1")!,
        title: "Fashion Show 2025",
        description: "A high-end fashion show featuring upcoming designers.",
        registrationLastDate: "2025-05-01",
        eventDate: "2025-06-10",
        numberOfRegistrations: 300,
        location: "New York",
        additionalInformation: "VIP tickets available.",
        dressTheme: "Evening Wear",
        startingAge: 18,
        endingAge: 40,
        gender: [.female, .male],
        type: [.fashion, .runway],
        languages: ["English", "Spanish"],
        registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
    ),
     
     Event(
        id: 2,
        portraitImage: UIImage(named: "Event2")!,
        landscapeImage: UIImage(named: "Event2")!,
        title: "Fitness Bootcamp",
        description: "A bootcamp focused on intense fitness training for all levels.",
        registrationLastDate: "2025-02-20",
        eventDate: "2025-03-15",
        numberOfRegistrations: 150,
        location: "Los Angeles",
        additionalInformation: "Bring your own yoga mat and water.",
        dressTheme: "Athletic Wear",
        startingAge: 16,
        endingAge: 50,
        gender: [.male, .female],
        type: [.fitness],
        languages: ["English"],
        registrationLink: nil
     ),
     
     Event(
        id: 3,
        portraitImage: UIImage(named: "Event3")!,
        landscapeImage: UIImage(named: "Event3")!,
        title: "Tattoo Convention",
        description: "A convention showcasing renowned tattoo artists.",
        registrationLastDate: "2025-07-01",
        eventDate: "2025-08-05",
        numberOfRegistrations: 120,
        location: "Tokyo",
        additionalInformation: "Entry fee is 20 USD.",
        dressTheme: "Casual",
        startingAge: 18,
        endingAge: nil,
        gender: [.male, .female, .other],
        type: [.tattooed],
        languages: ["Japanese", "English"],
        registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
     ),
     
     Event(
        id: 4,
        portraitImage: UIImage(named: "Event4")!,
        landscapeImage: UIImage(named: "Event4")!,
        title: "Child Photography Workshop",
        description: "A workshop to help you master the art of capturing children’s moments.",
        registrationLastDate: "2025-04-10",
        eventDate: "2025-05-01",
        numberOfRegistrations: 50,
        location: "London",
        additionalInformation: nil,
        dressTheme: "Comfortable",
        startingAge: 10,
        endingAge: 16,
        gender: [.male, .female],
        type: [.photography],
        languages: ["English"],
        registrationLink: nil
     )]
    ,
    
    [Event(
        id: 5,
        portraitImage: UIImage(named: "Event1 1")!,
        landscapeImage: UIImage(named: "Event1 1")!,
        title: "Child Photography Workshop",
        description: "A workshop to help you master the art of capturing children’s moments.",
        registrationLastDate: "2025-04-10",
        eventDate: "2025-05-01",
        numberOfRegistrations: 50,
        location: "London",
        additionalInformation: nil,
        dressTheme: "Comfortable",
        startingAge: 10,
        endingAge: 16,
        gender: [.male, .female],
        type: [.photography],
        languages: ["English"],
        registrationLink: nil
    ),
     
     Event(
        id: 6,
        portraitImage: UIImage(named: "Event2")!,
        landscapeImage: UIImage(named: "Event2")!,
        title: "Child Photography Workshop",
        description: "A workshop to help you master the art of capturing children’s moments.",
        registrationLastDate: "2025-04-10",
        eventDate: "2025-05-01",
        numberOfRegistrations: 50,
        location: "London",
        additionalInformation: nil,
        dressTheme: "Comfortable",
        startingAge: 10,
        endingAge: 16,
        gender: [.male, .female],
        type: [.photography],
        languages: ["English"],
        registrationLink: nil
     ),
     Event(
        id: 7,
        portraitImage: UIImage(named: "Event3")!,
        landscapeImage: UIImage(named: "Event3")!,
        title: "Tattoo Convention",
        description: "A convention showcasing renowned tattoo artists.",
        registrationLastDate: "2025-07-01",
        eventDate: "2025-08-05",
        numberOfRegistrations: 120,
        location: "Tokyo",
        additionalInformation: "Entry fee is 20 USD.",
        dressTheme: "Casual",
        startingAge: 18,
        endingAge: nil,
        gender: [.male, .female, .other],
        type: [.tattooed],
        languages: ["Japanese", "English"],
        registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
     ),
     
     Event(
        id: 8,
        portraitImage: UIImage(named: "Event4")!,
        landscapeImage: UIImage(named: "Event4")!,
        title: "Child Photography Workshop",
        description: "A workshop to help you master the art of capturing children’s moments.",
        registrationLastDate: "2025-04-10",
        eventDate: "2025-05-01",
        numberOfRegistrations: 50,
        location: "London",
        additionalInformation: nil,
        dressTheme: "Comfortable",
        startingAge: 10,
        endingAge: 16,
        gender: [.male, .female],
        type: [.photography],
        languages: ["English"],
        registrationLink: nil
     ),
     Event(
        id: 9,
        portraitImage: UIImage(named: "Event3")!,
        landscapeImage: UIImage(named: "Event3")!,
        title: "Tattoo Convention",
        description: "A convention showcasing renowned tattoo artists.",
        registrationLastDate: "2025-07-01",
        eventDate: "2025-08-05",
        numberOfRegistrations: 120,
        location: "Tokyo",
        additionalInformation: "Entry fee is 20 USD.",
        dressTheme: "Casual",
        startingAge: 18,
        endingAge: nil,
        gender: [.male, .female, .other],
        type: [.tattooed],
        languages: ["Japanese", "English"],
        registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
     ),
     
     Event(
        id: 10,
        portraitImage: UIImage(named: "Event4")!,
        landscapeImage: UIImage(named: "Event4")!,
        title: "Child Photography Workshop",
        description: "A workshop to help you master the art of capturing children’s moments.",
        registrationLastDate: "2025-04-10",
        eventDate: "2025-05-01",
        numberOfRegistrations: 50,
        location: "London",
        additionalInformation: nil,
        dressTheme: "Comfortable",
        startingAge: 10,
        endingAge: 16,
        gender: [.male, .female],
        type: [.photography],
        languages: ["English"],
        registrationLink: nil
     )],
    
    [Event(
        id: 11,
        portraitImage: UIImage(named: "Event1 1")!,
        landscapeImage: UIImage(named: "Event1 1")!,
        title: "Child Photography Workshop",
        description: "A workshop to help you master the art of capturing children’s moments.",
        registrationLastDate: "2025-04-10",
        eventDate: "2025-05-01",
        numberOfRegistrations: 50,
        location: "London",
        additionalInformation: nil,
        dressTheme: "Comfortable",
        startingAge: 10,
        endingAge: 16,
        gender: [.male, .female],
        type: [.photography],
        languages: ["English"],
        registrationLink: nil
    ),
     
     Event(
        id: 12,
        portraitImage: UIImage(named: "Event2")!,
        landscapeImage: UIImage(named: "Event2")!,
        title: "Child Photography Workshop",
        description: "A workshop to help you master the art of capturing children’s moments.",
        registrationLastDate: "2025-04-10",
        eventDate: "2025-05-01",
        numberOfRegistrations: 50,
        location: "London",
        additionalInformation: nil,
        dressTheme: "Comfortable",
        startingAge: 10,
        endingAge: 16,
        gender: [.male, .female],
        type: [.photography],
        languages: ["English"],
        registrationLink: nil
     ),
     Event(
        id: 13,
        portraitImage: UIImage(named: "Event3")!,
        landscapeImage: UIImage(named: "Event3")!,
        title: "Tattoo Convention",
        description: "A convention showcasing renowned tattoo artists.",
        registrationLastDate: "2025-07-01",
        eventDate: "2025-08-05",
        numberOfRegistrations: 120,
        location: "Tokyo",
        additionalInformation: "Entry fee is 20 USD.",
        dressTheme: "Casual",
        startingAge: 18,
        endingAge: nil,
        gender: [.male, .female, .other],
        type: [.tattooed],
        languages: ["Japanese", "English"],
        registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
     ),
     
     Event(
        id: 14,
        portraitImage: UIImage(named: "Event4")!,
        landscapeImage: UIImage(named: "Event4")!,
        title: "Child Photography Workshop",
        description: "A workshop to help you master the art of capturing children’s moments.",
        registrationLastDate: "2025-04-10",
        eventDate: "2025-05-01",
        numberOfRegistrations: 50,
        location: "London",
        additionalInformation: nil,
        dressTheme: "Comfortable",
        startingAge: 10,
        endingAge: 16,
        gender: [.male, .female],
        type: [.photography],
        languages: ["English"],
        registrationLink: nil
     ),
     Event(
        id: 15,
        portraitImage: UIImage(named: "Event3")!,
        landscapeImage: UIImage(named: "Event3")!,
        title: "Tattoo Convention",
        description: "A convention showcasing renowned tattoo artists.",
        registrationLastDate: "2025-07-01",
        eventDate: "2025-08-05",
        numberOfRegistrations: 120,
        location: "Tokyo",
        additionalInformation: "Entry fee is 20 USD.",
        dressTheme: "Casual",
        startingAge: 18,
        endingAge: nil,
        gender: [.male, .female, .other],
        type: [.tattooed],
        languages: ["Japanese", "English"],
        registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
     ),
     
     Event(
        id: 16,
        portraitImage: UIImage(named: "Event4")!,
        landscapeImage: UIImage(named: "Event4")!,
        title: "Child Photography Workshop",
        description: "A workshop to help you master the art of capturing children’s moments.",
        registrationLastDate: "2025-04-10",
        eventDate: "2025-05-01",
        numberOfRegistrations: 50,
        location: "London",
        additionalInformation: nil,
        dressTheme: "Comfortable",
        startingAge: 10,
        endingAge: 16,
        gender: [.male, .female],
        type: [.photography],
        languages: ["English"],
        registrationLink: nil
     )]
]

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var ageDropdownButton: UIButton!
    @IBOutlet weak var genreDropdownButton: UIButton!
    @IBOutlet weak var locationDropdownButton: UIButton!
    @IBOutlet weak var dateDropdownButton: UIButton!
    @IBOutlet weak var genderDropdownButton: UIButton!
    
    var agePickerView: UIPickerView!
    var genrePickerView: UIPickerView!
    var locationPickerView: UIPickerView!
    var genderPickerView: UIPickerView!
    
    var ageData = Array(1...100)
    var genreData: [TypeOfEvent] = [.hand, .promotional, .child, .plusSize, .hairstylist, .alternative, .lifestyle, .editorial, .makeupArtist, .freelancer, .petite, .commercial, .tattooed, .fitness, .events, .highFashion, .runway, .fashion, .agency, .catalog, .beauty, .photography]
    var locationData = [
            "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh",
            "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jharkhand", "Karnataka",
            "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram",
            "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana",
            "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"
        ]
    var genderData: [Gender] = [.male, .female, .other]
    
    var selectedAge: Int?
    var selectedGenre: TypeOfEvent?
    var selectedLocation: String?
    var selectedDate: Date?
    var selectedGender: Gender?
    
    var originalEventsData: [[Event]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        originalEventsData = eventsData
        
        ageDropdownButton.addTarget(self, action: #selector(showAgePicker), for: .touchUpInside)
        genderDropdownButton.addTarget(self, action: #selector(showGenderPicker), for: .touchUpInside)
        genreDropdownButton.addTarget(self, action: #selector(showGenrePicker), for: .touchUpInside)
        locationDropdownButton.addTarget(self, action: #selector(showLocationPicker), for: .touchUpInside)
    }
    
    @objc func showGenderPicker() {
        let alert = UIAlertController(title: "Select Gender", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        genderPickerView = UIPickerView()
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        alert.view.addSubview(genderPickerView)
        
        genderPickerView.translatesAutoresizingMaskIntoConstraints = false
        genderPickerView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        genderPickerView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50).isActive = true
        genderPickerView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        genderPickerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.selectedGender = self.genderData[self.genderPickerView.selectedRow(inComponent: 0)]
            self.genderDropdownButton.setTitle(self.selectedGender?.rawValue, for: .normal)
            self.filterEvents(by: self.selectedAge, selectedGender: self.selectedGender)
        }
        alert.addAction(doneAction)
        
        let clearAction = UIAlertAction(title: "Clear Filter", style: .destructive) { _ in
            self.selectedGender = nil
            self.genderDropdownButton.setTitle("Gender", for: .normal)
            self.resetFilter() // Show all events again
        }
        alert.addAction(clearAction)
        
        present(alert, animated: true, completion: nil)
    }


    @objc func showAgePicker() {
        let alert = UIAlertController(title: "Select Age", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        // Create a UIPickerView to display the age options
        agePickerView = UIPickerView()
        agePickerView.dataSource = self
        agePickerView.delegate = self
        alert.view.addSubview(agePickerView)
        
        // Set the constraints for the picker view within the alert
        agePickerView.translatesAutoresizingMaskIntoConstraints = false
        agePickerView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        agePickerView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50).isActive = true
        agePickerView.widthAnchor.constraint(equalToConstant: 220).isActive = true // Smaller width
        agePickerView.heightAnchor.constraint(equalToConstant: 120).isActive = true // Smaller height
        
        // Add "Done" button to the alert
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.selectedAge = self.ageData[self.agePickerView.selectedRow(inComponent: 0)]
            self.ageDropdownButton.setTitle("\(self.selectedAge ?? 0)", for: .normal)
            self.filterEvents(by: self.selectedAge)
        }
        alert.addAction(doneAction)
        
        // Add "Clear Filter" button to reset the filter
        let clearAction = UIAlertAction(title: "Clear Filter", style: .destructive) { _ in
            self.selectedAge = nil
            self.ageDropdownButton.setTitle("Age", for: .normal)
            self.resetFilter() // Show all events again
        }
        alert.addAction(clearAction)
        
        // Show the alert with the picker view
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func showLocationPicker() {
        let alert = UIAlertController(title: "Select Location", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        locationPickerView = UIPickerView()
        locationPickerView.dataSource = self
        locationPickerView.delegate = self
        alert.view.addSubview(locationPickerView)
        
        locationPickerView.translatesAutoresizingMaskIntoConstraints = false
        locationPickerView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        locationPickerView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50).isActive = true
        locationPickerView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        locationPickerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.selectedLocation = self.locationData[self.locationPickerView.selectedRow(inComponent: 0)]
            self.locationDropdownButton.setTitle(self.selectedLocation, for: .normal)
            self.filterEvents(by: self.selectedAge, selectedGender: self.selectedGender, selectedLocation: self.selectedLocation, selectedGenre: self.selectedGenre)
        }
        alert.addAction(doneAction)
        
        let clearAction = UIAlertAction(title: "Clear Filter", style: .destructive) { _ in
            self.selectedLocation = nil
            self.locationDropdownButton.setTitle("Location", for: .normal)
            self.resetFilter()
        }
        alert.addAction(clearAction)
        
        present(alert, animated: true, completion: nil)
    }

    @objc func showGenrePicker() {
        let alert = UIAlertController(title: "Select Genre", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        genrePickerView = UIPickerView()
        genrePickerView.dataSource = self
        genrePickerView.delegate = self
        alert.view.addSubview(genrePickerView)
        
        genrePickerView.translatesAutoresizingMaskIntoConstraints = false
        genrePickerView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor).isActive = true
        genrePickerView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50).isActive = true
        genrePickerView.widthAnchor.constraint(equalToConstant: 220).isActive = true
        genrePickerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.selectedGenre = self.genreData[self.genrePickerView.selectedRow(inComponent: 0)]
            self.genreDropdownButton.setTitle(self.selectedGenre?.rawValue, for: .normal)
            self.filterEvents(by: self.selectedAge, selectedGender: self.selectedGender, selectedLocation: self.selectedLocation, selectedGenre: self.selectedGenre)
        }
        alert.addAction(doneAction)
        
        let clearAction = UIAlertAction(title: "Clear Filter", style: .destructive) { _ in
            self.selectedGenre = nil
            self.genreDropdownButton.setTitle("Genre", for: .normal)
            self.resetFilter()
        }
        alert.addAction(clearAction)
        
        present(alert, animated: true, completion: nil)
    }

    func filterEvents(by selectedAge: Int? = nil, selectedGender: Gender? = nil, selectedLocation: String? = nil, selectedGenre: TypeOfEvent? = nil) {
        var filteredEvents: [[Event]] = []
        
        for section in eventsData {
            let filteredSection = section.filter { event in
                let matchesAge = selectedAge == nil || (event.startingAge ?? 0 <= selectedAge!) && (event.endingAge ?? Int.max) >= selectedAge!
                let matchesGender = selectedGender == nil || event.gender.contains(selectedGender!)
                let matchesLocation = selectedLocation == nil || event.location == selectedLocation
                let matchesGenre = selectedGenre == nil || event.type.contains(selectedGenre!)
                
                return matchesAge && matchesGender && matchesLocation && matchesGenre
            }
            filteredEvents.append(filteredSection)
        }
        
        eventsData = filteredEvents
        collectionView.reloadData()
    }
    func resetFilter() {
        // Reset the eventsData to the original unfiltered data
        eventsData = originalEventsData
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEventDetails", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEventDetails" {
            if let destinationVC = segue.destination as? EventsDetailViewController,
               let indexPath = sender as? IndexPath {
                destinationVC.event = eventsData[indexPath.section][indexPath.item]
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return eventsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventsData[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as! EventsCollectionViewCell
        let event = eventsData[indexPath.section][indexPath.item]
        switch indexPath.section {
        case 0:
            cell.eventImage.image = event.portraitImage
        default:
            cell.eventImage.image = event.landscapeImage
        }
        return cell
    }
    
    func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let section: NSCollectionLayoutSection
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.3333),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
            case 1:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.9999),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
            case 2:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(200))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                section = NSCollectionLayoutSection(group: group)
            default:
                return nil
            }
            
            // Header for the section
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [header]
            
            return section
        }
    }
    
    // This method is required to supply headers for each section
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
//            headerView.backgroundColor = .lightGray
            
            let label = UILabel(frame: headerView.bounds)
            label.textAlignment = .left
            headerView.subviews.forEach{$0.removeFromSuperview()}
            label.font = UIFont.boldSystemFont(ofSize: 22)
            
            switch(indexPath.section) {
            case 0 :
                label.text = " Registered Events"
            case 1 :
                label.text = " Trending Events"
            case 2 :
                label.text = " All Events"
            default:
                label.text = "N section"
            }
            headerView.addSubview(label)
            
            return headerView
        }
        return UICollectionReusableView()
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            if pickerView == agePickerView {
                return ageData.count
            } else if pickerView == genderPickerView {
                return genderData.count
            } else if pickerView == genrePickerView {
                return genreData.count
            } else {
                return locationData.count
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if pickerView == agePickerView {
                return "\(ageData[row])"
            } else if pickerView == genderPickerView {
                return genderData[row].rawValue
            } else if pickerView == genrePickerView {
                return genreData[row].rawValue
            } else {
                return locationData[row]
            }
        }
}
