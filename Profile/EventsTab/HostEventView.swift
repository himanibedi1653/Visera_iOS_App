import SwiftUI

struct AddAnEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var eventsModel: EventsDetailModel
    
    @State private var eventTitle: String = ""
    @State private var registrationLastDate: Date = Date()
    @State private var eventDate: Date = Date()
    @State private var location: String = ""
    @State private var description: String = ""
    @State private var additionalInformation: String = ""
    @State private var selectedGenders: [Gender] = []
    @State private var selectedGenres: [TypeOfEvent] = []
    @State private var eventImage: UIImage? = nil
    @State private var showImagePicker: Bool = false
    @State private var minAge: Int = 18
    @State private var maxAge: Int = 30
    @State private var registrationLink: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToMapSelection: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                // Event Title
                Section {
                    TextField("Event Title", text: $eventTitle)
                }
                
                // Registration Last Date
                Section {
                    HStack {
                        Text("Registration Last Date")
                        Spacer()
                        DatePicker("", selection: $registrationLastDate, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                    }
                }
                
                // Event Date
                Section {
                    HStack {
                        Text("Event Date")
                        Spacer()
                        DatePicker("", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                    }
                }
                
                // Location
                Section {
                    HStack {
                        Text(location.isEmpty ? "Choose Location" : location)
                        Spacer()
                        Button(action: {
                            navigateToMapSelection = true
                        }) {
                            Image(systemName: "map")
                                .foregroundColor(Color(red: 162/255, green: 121/255, blue: 13/255))
                        }
                    }
                }
                
                // Description
                Section {
                    TextField("Description", text: $description)
                }
                
                // Additional Information
                Section {
                    TextField("Additional Information", text: $additionalInformation)
                }
                
                // Age Range with Steppers
                Section(header: Text("Age Range")) {
                    // Minimum Age Stepper
                    HStack {
                        Text("Minimum Age: \(minAge)")
                        Spacer()
                        Stepper("", value: $minAge, in: 1...99, onEditingChanged: { _ in
                            // Ensure max age is at least equal to min age
                            if maxAge < minAge {
                                maxAge = minAge
                            }
                        })
                        .labelsHidden()
                    }
                    
                    // Maximum Age Stepper
                    HStack {
                        Text("Maximum Age: \(maxAge)")
                        Spacer()
                        Stepper("", value: $maxAge, in: minAge...99)
                        .labelsHidden()
                    }
                }
                
                // Registration Link
                Section {
                    TextField("Registration Link", text: $registrationLink)
                }
                
                // Gender (Multiple Selection)
                Section {
                    NavigationLink(destination: GenderMultiSelectionView(selectedGenders: $selectedGenders)) {
                        HStack {
                            Text("Gender")
                            Spacer()
                            Text(selectedGenders.isEmpty ? "No Selection" : "\(selectedGenders.count) selected")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Genre (Multiple Selection)
                Section {
                    NavigationLink(destination: GenreMultiSelectionView(selectedGenres: $selectedGenres)) {
                        HStack {
                            Text("Genre")
                            Spacer()
                            Text(selectedGenres.isEmpty ? "No Selection" : "\(selectedGenres.count) selected")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                // Event Image Upload
                Section {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        HStack {
                            Text("Upload Event Image")
                            Spacer()
                            if let eventImage = eventImage {
                                Image(uiImage: eventImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 50)
                            } else {
                                Text("No Image Selected")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Host Event")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                NavigationLink(
                    destination: MapSelectionView(selectedLocation: $location),
                    isActive: $navigateToMapSelection,
                    label: { EmptyView() }
                )
                .hidden()
            )
            .navigationBarItems(trailing: Button("Done") {
                validateAndSaveEvent()
            })
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(
                    selectedImage: $eventImage,
                    sourceType: .photoLibrary
                )
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Validation and Save Function
    private func validateAndSaveEvent() {
        // Validate Event Title
        guard !eventTitle.isEmpty else {
            showAlert(message: "Event title is required.")
            return
        }
        
        // Validate Description
        guard !description.isEmpty else {
            showAlert(message: "Description is required.")
            return
        }
        
        // Validate Additional Information
        guard !additionalInformation.isEmpty else {
            showAlert(message: "Additional information is required.")
            return
        }
        
        // Validate Location
        guard !location.isEmpty else {
            showAlert(message: "Please select a location.")
            return
        }
        
        // Validate Event Image
        guard eventImage != nil else {
            showAlert(message: "Please provide an event image.")
            return
        }
        
        // Validate Gender and Genre selections
        guard !selectedGenders.isEmpty else {
            showAlert(message: "Please select at least one gender.")
            return
        }
        
        guard !selectedGenres.isEmpty else {
            showAlert(message: "Please select at least one genre.")
            return
        }
        
        // If all validations pass, save the event and dismiss the modal
        saveEvent()
        presentationMode.wrappedValue.dismiss()
    }
    
    // Save Event Function
    private func saveEvent() {
        // Create a new event
        let newEvent = Event(
            id: UUID().hashValue, // Generate a unique ID
            portraitImage: eventImage!,
            landscapeImage: eventImage!,
            title: eventTitle,
            description: description,
            registrationLastDate: registrationLastDate.description,
            eventDate: eventDate.description,
            numberOfRegistrations: 0,
            location: location,
            additionalInformation: additionalInformation,
            dressTheme: nil,
            startingAge: minAge,
            endingAge: maxAge,
            gender: selectedGenders,
            type: selectedGenres,
            languages: [],
            registrationLink: URL(string: registrationLink))
        
        // Debug print
        print("Saving event: \(newEvent.title)")
        
        // Add the event to the data model at the top of the list
        eventsModel.addNewEventAtTop(event: newEvent)
        
        // Debug print
        print("Event added to model. Total events: \(eventsModel.getAllEvents().count)")
    }
    
    // Show Alert Function
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

// Gender Multi-Selection View
struct GenderMultiSelectionView: View {
    @Binding var selectedGenders: [Gender]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(Gender.allCases, id: \.self) { gender in
                Button(action: {
                    toggleSelection(gender: gender)
                }) {
                    HStack {
                        Text(gender.rawValue)
                        Spacer()
                        if selectedGenders.contains(gender) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(red: 162/255, green: 121/255, blue: 13/255))
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Genders")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Done") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func toggleSelection(gender: Gender) {
        if selectedGenders.contains(gender) {
            selectedGenders.removeAll { $0 == gender }
        } else {
            selectedGenders.append(gender)
        }
    }
}

// Genre Multi-Selection View
struct GenreMultiSelectionView: View {
    @Binding var selectedGenres: [TypeOfEvent]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            ForEach(TypeOfEvent.allCases, id: \.self) { genre in
                Button(action: {
                    toggleSelection(genre: genre)
                }) {
                    HStack {
                        Text(genre.rawValue)
                        Spacer()
                        if selectedGenres.contains(genre) {
                            Image(systemName: "checkmark")
                                .foregroundColor(Color(red: 162/255, green: 121/255, blue: 13/255))
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Genres")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button("Done") {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    private func toggleSelection(genre: TypeOfEvent) {
        if selectedGenres.contains(genre) {
            selectedGenres.removeAll { $0 == genre }
        } else {
            selectedGenres.append(genre)
        }
    }
}

// Image Picker
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Preview for AddAnEventView
struct AddAnEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddAnEventView(eventsModel: EventsDetailModel.shared)
    }
}
