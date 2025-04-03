import SwiftUI

struct EventsView: View {
    @StateObject private var eventsModel = EventsDetailModel.shared
    @ObservedObject private var userModel = UserDataModel.shared
    
    @State private var selectedTrendingIndex: Int = 0
    @State private var showAddEventView: Bool = false
    
    @State private var activeFilters: Set<String> = []
    @State private var selectedFilterToEdit: String? = nil
    
    @State private var selectedAge: Int = 25
    @State private var selectedLocation: String? = nil
    @State private var selectedDate: Date? = nil
    @State private var selectedGender: Gender? = nil
    @State private var selectedGenre: TypeOfEvent? = nil
    @State private var showFilterSheet: Bool = false
    
    // New state for tab navigation
    @State private var navigateToEventsTab: Bool = false
    
    let filterOptions = ["Age", "Location", "Date", "Gender", "Genre"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Filter Options Section with remove buttons
                    HStack(spacing: 10) {
                        ForEach(activeFilters.sorted(), id: \.self) { filter in
                            HStack {
                                Text(filter)
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .onTapGesture {
                                        removeFilter(filter)
                                    }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    
                    FilterOptionsSection(
                        activeFilters: $activeFilters,
                        filterOptions: filterOptions,
                        selectedFilterToEdit: $selectedFilterToEdit,
                        showFilterSheet: $showFilterSheet,
                        selectedAge: $selectedAge,
                        selectedLocation: $selectedLocation,
                        selectedDate: $selectedDate,
                        selectedGender: $selectedGender,
                        selectedGenre: $selectedGenre
                    )
                    
                    // Updated Registered Events Section with empty state
                    VStack(alignment: .leading) {
                        Text("Registered Events")
                            .font(.title2)
                            .bold()
                            .padding(.leading)
                        
                        if userModel.currentUser.profileData.eventsRegistered.isEmpty {
                            // Empty state view
                            EmptyEventStateView2(navigateToEventsTab: $navigateToEventsTab)
                                .padding(.horizontal)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(userModel.currentUser.profileData.eventsRegistered, id: \.self) { eventID in
                                        if let event = eventsModel.getEvent(byID: eventID, from: eventsModel.getAllEvents()) {
                                            NavigationLink(destination: EventDetailView(event: event, isFromRegisteredEvents: true)) {
                                                RegisteredEventCard(event: event)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    TrendingEventsSection(eventsModel: eventsModel, selectedTrendingIndex: $selectedTrendingIndex)
                    
                    AllEventsSection(
                        eventsModel: eventsModel,
                        activeFilters: activeFilters,
                        selectedAge: selectedAge,
                        selectedLocation: selectedLocation,
                        selectedDate: selectedDate,
                        selectedGender: selectedGender,
                        selectedGenre: selectedGenre
                    )
                }
            }
            .navigationTitle("Events")
            .navigationBarItems(trailing: Button(action: {
                showAddEventView = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(Color(red: 162/255, green: 121/255, blue: 13/255))
            })
            .sheet(isPresented: $showAddEventView, onDismiss: {
                eventsModel.objectWillChange.send()
            }) {
                AddAnEventView(eventsModel: eventsModel)
            }
            .sheet(isPresented: $showFilterSheet) {
                if let filterType = selectedFilterToEdit {
                    FilterDetailView(
                        filterType: filterType,
                        activeFilters: $activeFilters,
                        selectedAge: $selectedAge,
                        selectedLocation: $selectedLocation,
                        selectedDate: $selectedDate,
                        selectedGender: $selectedGender,
                        selectedGenre: $selectedGenre
                    )
                }
            }
        }
        .onChange(of: selectedFilterToEdit) { _ in
            if selectedFilterToEdit != nil {
                showFilterSheet = true
            }
        }
    }
    
    private func removeFilter(_ filter: String) {
        activeFilters.remove(filter)
        switch filter {
        case "Age": selectedAge = 25
        case "Location": selectedLocation = nil
        case "Date": selectedDate = nil
        case "Gender": selectedGender = nil
        case "Genre": selectedGenre = nil
        default: break
        }
    }
}

// Empty State View for the Registered Events section
struct EmptyEventStateView2: View {
    @Binding var navigateToEventsTab: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Image(systemName: "calendar.badge.plus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(Color(red: 182/255, green: 157/255, blue: 83/255).opacity(0.7))
            
            Text("No Upcoming Events")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Explore and register for exciting events to see them appear here.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()

// Filter Options Section - Updated to remove clear all button
struct FilterOptionsSection: View {
    @Binding var activeFilters: Set<String>
    var filterOptions: [String]
    @Binding var selectedFilterToEdit: String?
    @Binding var showFilterSheet: Bool
    @Binding var selectedAge: Int
    @Binding var selectedLocation: String?
    @Binding var selectedDate: Date?
    @Binding var selectedGender: Gender?
    @Binding var selectedGenre: TypeOfEvent?
    
    var body: some View {
        VStack(alignment: .leading) {
            // Removed the HStack that contained the "Clear All" button
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(filterOptions, id: \.self) { option in
                        FilterOptionButton(
                            option: option,
                            isSelected: activeFilters.contains(option),
                            action: {
                                selectedFilterToEdit = option
                                showFilterSheet = true
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 5)
    }
}

// Filter Option Button - Same as before
struct FilterOptionButton: View {
    var option: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(option)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
                .foregroundColor(isSelected ? .white : Color(red: 162/255, green: 121/255, blue: 13/255))
                .padding(.vertical, 6)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color(red: 162/255, green: 121/255, blue: 13/255) : Color.white)
                        .shadow(color: Color.gray.opacity(0.3), radius: 2, x: 0, y: 1)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 162/255, green: 121/255, blue: 13/255), lineWidth: 1)
                )
        }
        .padding(.vertical, 1)
    }
}

struct FilterDetailView: View {
    var filterType: String
    @Binding var activeFilters: Set<String>
    @Binding var selectedAge: Int
    @Binding var selectedLocation: String?
    @Binding var selectedDate: Date?
    @Binding var selectedGender: Gender?
    @Binding var selectedGenre: TypeOfEvent?
    
    @Environment(\.presentationMode) var presentationMode
    
    // For Age filter - now a single value instead of range
    @State private var ageValue: Double = 25
    
    // Sample data for dropdowns
    let locations = ["New York", "Los Angeles", "Chicago", "Miami", "San Francisco"]
    let genders: [Gender] = [.male, .female, .other]
    let genres: [TypeOfEvent] = [ .hand, .promotional, .child, .plusSize , .glamour, .hairstylist, .alternative, .lifestyle , .editorial, .makeupArtist, .freelancer, .petite, .commercial, .tattooed, .fitness, .events ,.highFashion, .runway, .fashion , .agency, .catalog, .beauty , .photography]
    
    var body: some View {
        NavigationView {
            Form {
                switch filterType {
                case "Age":
                    Section(header: Text("Select Age")) {
                        Text("Age: \(Int(ageValue))")
                            .padding(.vertical, 8)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Slider(value: $ageValue, in: 13...100, step: 1)
                        }
                    }
                    
                case "Location":
                    Section(header: Text("Select Location")) {
                        ForEach(locations, id: \.self) { location in
                            Button(action: {
                                selectedLocation = location
                            }) {
                                HStack {
                                    Text(location)
                                    Spacer()
                                    if selectedLocation == location {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color(red: 162/255, green: 121/255, blue: 13/255))
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                case "Date":
                    Section(header: Text("Select Date")) {
                        DatePicker(
                            "Event Date",
                            selection: Binding(
                                get: { selectedDate ?? Date() },
                                set: { selectedDate = $0 }
                            ),
                            displayedComponents: .date
                        )
                    }
                    
                case "Gender":
                    Section(header: Text("Select Gender")) {
                        ForEach(genders, id: \.self) { gender in
                            Button(action: {
                                selectedGender = gender
                            }) {
                                HStack {
                                    Text(gender.rawValue)
                                    Spacer()
                                    if selectedGender == gender {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color(red: 162/255, green: 121/255, blue: 13/255))
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                case "Genre":
                    Section(header: Text("Select Genre")) {
                        ForEach(genres, id: \.self) { genre in
                            Button(action: {
                                selectedGenre = genre
                            }) {
                                HStack {
                                    Text(genre.rawValue)
                                    Spacer()
                                    if selectedGenre == genre {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color(red: 162/255, green: 121/255, blue: 13/255))
                                    }
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                    
                default:
                    Text("Select a filter category first")
                }
            }
            .onAppear {
                // Initialize the slider value with current age
                if filterType == "Age" {
                    ageValue = Double(selectedAge)
                }
            }
            .navigationTitle("Filter by \(filterType)")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        // Update values based on filter type
                        if filterType == "Age" {
                            selectedAge = Int(ageValue)
                        }
                        
                        // Add the filter to active filters
                        activeFilters.insert(filterType)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                // Add a Remove button if filter is already active
                if activeFilters.contains(filterType) {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Remove") {
                            // Remove the filter
                            activeFilters.remove(filterType)
                            
                            // Reset the filter value based on type
                            switch filterType {
                            case "Age":
                                selectedAge = 25
                            case "Location":
                                selectedLocation = nil
                            case "Date":
                                selectedDate = nil
                            case "Gender":
                                selectedGender = nil
                            case "Genre":
                                selectedGenre = nil
                            default:
                                break
                            }
                            
                            presentationMode.wrappedValue.dismiss()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

// Trending Events Section - Unchanged
struct TrendingEventsSection: View {
    var eventsModel: EventsDetailModel
    @Binding var selectedTrendingIndex: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Trending Events")
                .font(.title2)
                .bold()
                .padding(.leading)
            
            GeometryReader { geometry in
                TabView(selection: $selectedTrendingIndex) {
                    ForEach(Array(eventsModel.getTrendingEvents(events: eventsModel.getAllEvents()).indices), id: \.self) { index in
                        let event = eventsModel.getTrendingEvents(events: eventsModel.getAllEvents())[index]
                        NavigationLink(destination: EventDetailView(event: event, isFromRegisteredEvents: false)) {
                            EventCard(event: event)
                                .frame(width: geometry.size.width - 40, height: 200)
                                .tag(index)
                        }
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 270)
            }
            .frame(height: 270)
            
            // Page Indicators (Circles)
            HStack(spacing: 10) {
                ForEach(Array(eventsModel.getTrendingEvents(events: eventsModel.getAllEvents()).indices), id: \.self) { index in
                    Circle()
                        .frame(width: index == selectedTrendingIndex ? 12 : 8, height: index == selectedTrendingIndex ? 12 : 8)
                        .foregroundColor(index == selectedTrendingIndex ? Color(red: 162/255, green: 121/255, blue: 13/255) : .gray)
                        .animation(.easeInOut, value: selectedTrendingIndex)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 10)
        }
    }
}

// All Events Section - Modified to filter by single age value
struct AllEventsSection: View {
    @ObservedObject var eventsModel: EventsDetailModel
    var activeFilters: Set<String>
    var selectedAge: Int
    var selectedLocation: String?
    var selectedDate: Date?
    var selectedGender: Gender?
    var selectedGenre: TypeOfEvent?
    
    var filteredEvents: [Event] {
        var events = eventsModel.getAllEvents()
        
        // If no filters are active, return all events
        if activeFilters.isEmpty {
            return events
        }
        
        // Apply each active filter
        if activeFilters.contains("Age") {
            events = events.filter { event in
                guard let startingAge = event.startingAge, let endingAge = event.endingAge else {
                    return false
                }
                // Check if the selected age falls within the event's age range
                return selectedAge >= startingAge && selectedAge <= endingAge
            }
        }
        
        if activeFilters.contains("Location"), let location = selectedLocation {
            events = events.filter { $0.location == location }
        }
        
        if activeFilters.contains("Date"), let date = selectedDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let selectedDateString = dateFormatter.string(from: date)
            
            events = events.filter { event in
                guard let eventDateString = event.eventDate else {
                    return false
                }
                
                return eventDateString.hasPrefix(selectedDateString)
            }
        }
        
        if activeFilters.contains("Gender"), let gender = selectedGender {
            events = events.filter { $0.gender.contains(gender) }
        }
        
        if activeFilters.contains("Genre"), let genre = selectedGenre {
            events = events.filter { $0.type.contains(genre) }
        }
        
        return events
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("All Events")
                .font(.title2)
                .bold()
                .padding(.leading)
            
            if filteredEvents.isEmpty {
                Text("No events match your filter criteria")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 20)
            } else {
                VStack(spacing: 15) {
                    ForEach(filteredEvents, id: \.id) { event in
                        NavigationLink(destination: EventDetailView(event: event, isFromRegisteredEvents: false)) {
                            EventCard(event: event)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

// Event Cards - Unchanged
struct RegisteredEventCard: View {
    var event: Event
    
    var body: some View {
        Image(uiImage: event.portraitImage)
            .resizable()
            .scaledToFill()
            .frame(width: 150, height: 180)
            .cornerRadius(10)
            .clipped()
    }
}

struct EventCard: View {
    var event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Event image
            Image(uiImage: event.portraitImage)
                .resizable()
                .scaledToFill()
                .frame(height: 150)
                .cornerRadius(10, corners: [.topLeft, .topRight])
                .clipped()
            
            // Info section
            VStack(alignment: .leading, spacing: 8) {
                // Event title
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(Color(red: 162/255, green: 121/255, blue: 13/255))
                    .lineLimit(1)
                
                // Top row: Date and Gender
                HStack {
                    // Date
                    if let date = event.eventDate {
                        HStack(spacing: 4) {
                            Image(systemName: "calendar")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text(formatDate(date))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Gender
                    if !event.gender.isEmpty {
                        HStack(spacing: 4) {
                            Image(systemName: "person")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                            Text(formatGenders(event.gender))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                // Bottom row: Genre/Type with tags
                if !event.type.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 6) {
                            ForEach(Array(event.type.prefix(3)), id: \.self) { type in
                                Text(type.rawValue)
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color(red: 162/255, green: 121/255, blue: 13/255).opacity(0.2))
                                    .foregroundColor(Color(red: 102/255, green: 76/255, blue: 8/255))
                                    .cornerRadius(12)
                            }
                            
                            if event.type.count > 3 {
                                Text("+\(event.type.count - 3)")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 3)
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.gray)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
            }
            .padding(12)
            .background(Color.white)
        }
        .cornerRadius(10)
        .shadow(color: Color.gray.opacity(0.3), radius: 3, x: 0, y: 2)
    }
    
    // Format date string to a readable format
    private func formatDate(_ dateString: String) -> String {
        // Assuming dateString is in format like "2023-04-15 14:00:00"
        let components = dateString.components(separatedBy: " ")
        if let dateComponent = components.first {
            let dateParts = dateComponent.components(separatedBy: "-")
            if dateParts.count >= 3 {
                let monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
                if let month = Int(dateParts[1]), month >= 1 && month <= 12 {
                    return "\(dateParts[2]) \(monthNames[month-1])"
                }
            }
        }
        return dateString
    }
    
    // Format array of genders to string
    private func formatGenders(_ genders: [Gender]) -> String {
        if genders.count == 1 {
            return genders[0].rawValue
        } else {
            return "Multiple"
        }
    }
}

// Extension for rounded specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
