//
//  EventsDataModel.swift
//  Visera-HomeScreen
//
//  Created by Himani Bedi on 21/01/25.
//

import Foundation
import UIKit

struct Event: Identifiable {
    var id: Int
    var portraitImage: UIImage
    var landscapeImage: UIImage
    var title: String
    var description: String?
    var registrationLastDate: String?
    var eventDate: String?
    var numberOfRegistrations: Int
    var location: String?
    var additionalInformation: String?
    var dressTheme: String?
    var startingAge: Int?
    var endingAge: Int?
    var gender: [Gender]
    var type: [TypeOfEvent]
    var languages: [String]
    var registrationLink: URL?
}

enum TypeOfEvent: String, CaseIterable {
    case hand = "Hand"
    case promotional = "Promotional"
    case child = "Child"
    case plusSize = "Plus Size"
    case glamour = "Glamour"
    case hairstylist = "Hairstylist"
    case alternative = "Alternative"
    case lifestyle = "Lifestyle"
    case editorial = "Editorial"
    case makeupArtist = "Makeup Artist"
    case freelancer = "Freelancer"
    case petite = "Petite"
    case commercial = "Commercial"
    case tattooed = "Tattooed"
    case fitness = "Fitness"
    case events = "Events"
    case highFashion = "High Fashion"
    case runway = "Runway"
    case fashion = "Fashion"
    case agency = "Agency"
    case catalog = "Catalog"
    case beauty = "Beauty"
    case photography = "Photography"
}

// MARK: Enums

enum Gender: String, CaseIterable {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}

let firstEvent = Event(
    id: 1,
    portraitImage: UIImage(named: "Event1")!,
    landscapeImage: UIImage(named: "Event2")!,
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
)

let secondEvent = Event(
    id: 2,
    portraitImage: UIImage(named: "Event3")!,
    landscapeImage: UIImage(named: "Event4")!,
    title: "Fitness Bootcamp",
    description: "A bootcamp focused on intense fitness training for all levels.",
    registrationLastDate: "2025-02-20",
    eventDate: "2025-05-15",
    numberOfRegistrations: 150,
    location: "Los Angeles",
    additionalInformation: "Bring your own yoga mat and water.",
    dressTheme: "Athletic Wear",
    startingAge: 16,
    endingAge: 50,
    gender: [.male, .female],
    type: [.fitness],
    languages: ["English"],
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
 )

let thirdEvent = Event(
   id: 3,
   portraitImage: UIImage(named: "Event5")!,
   landscapeImage: UIImage(named: "Event6")!,
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
)

let fourthEvent = Event(
    id: 4,
    portraitImage: UIImage(named: "Event7")!,
    landscapeImage: UIImage(named: "Event8")!,
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
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
 )

let fifthEvent = Event(
    id: 5,
    portraitImage: UIImage(named: "Event9")!,
    landscapeImage: UIImage(named: "Event10")!,
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
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
)

let sixthEvent = Event(
    id: 6,
    portraitImage: UIImage(named: "Event11")!,
    landscapeImage: UIImage(named: "Event12")!,
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
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
 )

let seventhEvent = Event(
    id: 7,
    portraitImage: UIImage(named: "Event13")!,
    landscapeImage: UIImage(named: "Event14")!,
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
 )

let eighthEvent = Event(
    id: 8,
    portraitImage: UIImage(named: "Event15")!,
    landscapeImage: UIImage(named: "Event16")!,
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
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
 )

let ninthEvent = Event(
    id: 9,
    portraitImage: UIImage(named: "Event17")!,
    landscapeImage: UIImage(named: "Event18")!,
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
 )

let tenthEvent = Event(
    id: 10,
    portraitImage: UIImage(named: "Event19")!,
    landscapeImage: UIImage(named: "Event20")!,
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
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
 )

let eleventhEvent = Event(
    id: 11,
    portraitImage: UIImage(named: "Event21")!,
    landscapeImage: UIImage(named: "Event22")!,
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
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
)

let twelvethEvent = Event(
    id: 12,
    portraitImage: UIImage(named: "Event23")!,
    landscapeImage: UIImage(named: "Event24")!,
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
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
 )

let thirteenthEvent = Event(
    id: 13,
    portraitImage: UIImage(named: "Event25")!,
    landscapeImage: UIImage(named: "Event26")!,
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
 )

let fourteenthEvent = Event(
    id: 14,
    portraitImage: UIImage(named: "Event27")!,
    landscapeImage: UIImage(named: "Event28")!,
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
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
 )

let fifteenthEvent = Event(
    id: 15,
    portraitImage: UIImage(named: "Event29")!,
    landscapeImage: UIImage(named: "Event30")!,
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
 )

let sixteenthEvent = Event(
    id: 16,
    portraitImage: UIImage(named: "Event31")!,
    landscapeImage: UIImage(named: "Event32")!,
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
    registrationLink: URL(string: "https://forms.gle/6avH7Q4Q9jYAPvVC7")
 )

class EventsDetailModel: ObservableObject {
    private var events: [Event] = []
    static let shared = EventsDetailModel()
    
    private init(){
        events.append(firstEvent)
        events.append(secondEvent)
        events.append(thirdEvent)
        events.append(fourthEvent)
        events.append(fifthEvent)
        events.append(sixthEvent)
        events.append(seventhEvent)
        events.append(eighthEvent)
        events.append(ninthEvent)
        events.append(tenthEvent)
        events.append(eleventhEvent)
        events.append(twelvethEvent)
        events.append(thirteenthEvent)
        events.append(fourteenthEvent)
        events.append(fifteenthEvent)
        events.append(sixteenthEvent)
    }
    
    // MARK: Function Events
    
    func getAllEvents() -> [Event]{
        return self.events
    }
    
    func getEvent(byID eventID: Int, from events: [Event]) -> Event? {
        return events.first { $0.id == eventID }
    }
    func getRegisteredEvents(forUser user: User) -> [Event] {
        return events.filter { user.profileData.eventsRegistered.contains($0.id) }
    }

    func getTrendingEvents(events: [Event]) -> [Event] {
        return events.sorted { $0.numberOfRegistrations > $1.numberOfRegistrations }.prefix(3).map { $0 }
    }
    
    func filterEvents(
        events: [Event],
        type: [TypeOfEvent]? = nil,
        minAge: Int? = nil,
        maxAge: Int? = nil,
        location: String? = nil,
        month: String? = nil,
        gender: [Gender]? = nil
    ) -> [Event] {
        return events.filter { event in
            // Filter by event type
            let typeMatches = type?.contains(where: { event.type.contains($0) }) ?? true
            
            // Filter by age range
            let ageMatches: Bool
            if let minAge = minAge, let startingAge = event.startingAge {
                ageMatches = startingAge <= minAge
            } else if let maxAge = maxAge, let endingAge = event.endingAge {
                ageMatches = endingAge  >= maxAge
            } else {
                ageMatches = true
            }
            
            // Filter by location
            let locationMatches = location == nil || event.location?.lowercased().contains(location!.lowercased()) == true
            
            // Filter by month (event date as a string)
            let monthMatches = month == nil || {
                guard let eventDate = event.eventDate else { return false }
                let eventMonth = eventDate.split(separator: "-").dropFirst().first?.lowercased() // Extracts the month
                return eventMonth == month?.lowercased()
            }()
            
            // Filter by gender preference
            let genderMatches = gender == nil || gender?.contains(where: { event.gender.contains($0) }) ?? event.gender.isEmpty
            
            // Return true if all conditions match
            return typeMatches && ageMatches && locationMatches && monthMatches && genderMatches
        }
    }
    
    func addNewEvent(event: Event) {
        events.append(event)
        print("Event added: \(event.title)")
    }
    
    func getAllTypeOfEvents() -> [String] {
        return TypeOfEvent.allCases.map { $0.rawValue }
    }
    
    func addNewEventAtTop(event: Event) {
        events.insert(event, at: 0) // Insert at the top of the list
        print("Event added at top: \(event.title)")
    }

}



