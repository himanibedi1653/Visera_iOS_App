import SwiftUI

struct EventDetailView: View {
    var event: Event
    var isFromRegisteredEvents: Bool // New parameter to indicate the source
    @ObservedObject private var userModel = UserDataModel.shared
    @State private var showAlert = false // State to control the alert
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            formatter.timeStyle = .none
            return formatter
        }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                // Event Portrait Image (Centered)
                HStack {
                    Spacer() // Pushes the image to the center
                    Image(uiImage: event.portraitImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 500)
                        .clipped()
                    Spacer() // Pushes the image to the center
                }
                
                // Event Details
                VStack(alignment: .leading, spacing: 10) {
                    // Event Title (Golden Color)
                    Text(event.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "B69D53"))
                    
                    // Event Description
                    if let description = event.description {
                        Text(description)
                            .font(.title3)
                            .bold()
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    // Detailed Information Stack
                                        VStack(alignment: .leading, spacing: 10) {
                                            // Event Date
                                            if let eventDateString = event.eventDate,
                                               let eventDate = ISO8601DateFormatter().date(from: eventDateString) {
                                                DetailRow(
                                                    icon: "calendar",
                                                    title: "Event Date",
                                                    value: dateFormatter.string(from: eventDate)
                                                )
                                            }
                                            
                                            // Location
                                            if let location = event.location {
                                                DetailRow(
                                                    icon: "map.fill",
                                                    title: "Location",
                                                    value: location
                                                )
                                            }
                                            
                                            // Additional Information
                                            if let additionalInfo = event.additionalInformation {
                                                DetailRow(
                                                    icon: "info.circle.fill",
                                                    title: "Additional Information",
                                                    value: additionalInfo
                                                )
                                            }
                                            
                                            // Dress Theme
                                            if let dressTheme = event.dressTheme {
                                                DetailRow(
                                                    icon: "tshirt.fill",
                                                    title: "Dress Theme",
                                                    value: dressTheme
                                                )
                                            }
                                            
                                            // Age Range
                                            if let startingAge = event.startingAge, let endingAge = event.endingAge {
                                                DetailRow(
                                                    icon: "person.2.fill",
                                                    title: "Age Range",
                                                    value: "\(startingAge) - \(endingAge) years"
                                                )
                                            }
                                            
                                            // Gender
                                            if !event.gender.isEmpty {
                                                DetailRow(
                                                    icon: "figure.stand.dress.line.vertical.figure",
                                                    title: "Gender",
                                                    value: event.gender.map { $0.rawValue }.joined(separator: ", ")
                                                )
                                            }
                                            
                                            // Languages
                                            if !event.languages.isEmpty {
                                                DetailRow(
                                                    icon: "globe.central.south.asia.fill",
                                                    title: "Languages",
                                                    value: event.languages.joined(separator: ", ")
                                                )
                                            }
                                        }
                                        
                                        // Register Now Button (Conditional)
                                        if !isFromRegisteredEvents && !userModel.currentUser.profileData.eventsRegistered.contains(event.id) {
                                            Button(action: {
                                                if event.registrationLink != nil {
                                                    userModel.appendRegisteredEvents(event: event.id)
                                                    UIApplication.shared.open(event.registrationLink!)
                                                } else {
                                                    showAlert = true
                                                }
                                            }) {
                                                Text("Register Now")
                                                    .font(.headline)
                                                    .foregroundColor(.white)
                                                    .frame(maxWidth: .infinity)
                                                    .padding()
                                                    .background(Color(hex: "B69D53"))
                                                    .cornerRadius(10)
                                            }
                                            .alert(isPresented: $showAlert) {
                                                Alert(
                                                    title: Text("Registrations Closed"),
                                                    message: Text("Registrations are not open currently."),
                                                    dismissButton: .default(Text("OK"))
                                                )
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                            .navigationTitle("Event Details")
                            .navigationBarTitleDisplayMode(.inline)
                        }
                    }

                    // Reusable Detail Row View
                    struct DetailRow: View {
                        let icon: String
                        let title: String
                        let value: String
                        
                        var body: some View {
                            HStack(spacing: 12) {
                                Image(systemName: icon)
                                    .foregroundColor(Color(hex: "B69D53"))
                                    .frame(width: 30)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(title)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text(value)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }

                    // Preview for EventDetailView
                    struct EventDetailView_Previews: PreviewProvider {
                        static var previews: some View {
                            let sampleEvent = Event(
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
                                registrationLink: nil
                            )
                            
                            NavigationView {
                                EventDetailView(event: sampleEvent, isFromRegisteredEvents: false)
                            }
                        }
                    }
