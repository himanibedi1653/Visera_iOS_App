import SwiftUI
import MapKit

struct IdentifiableCoordinate: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapSelectionView: View {
    @Binding var selectedLocation: String
    @State private var searchText: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 20.5937, longitude: 78.9629), // Center of India
        span: MKCoordinateSpan(latitudeDelta: 40, longitudeDelta: 40) // Zoom out to show entire India
    )
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var annotations: [IdentifiableCoordinate] = []
    @State private var showingSelectedAddress: Bool = false
    @State private var selectedAddress: String = ""
    @State private var isGeocodingInProgress: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                // Search Bar
                HStack {
                    TextField("Search for a location", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    Button(action: {
                        searchLocation()
                    }) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.blue)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // Map View with center indicator
                ZStack {
                    Map(
                        coordinateRegion: $region,
                        interactionModes: .all,
                        showsUserLocation: true,
                        annotationItems: annotations
                    ) { item in
                        MapMarker(coordinate: item.coordinate, tint: .red)
                    }
                    .edgesIgnoringSafeArea(.bottom)
                    
                    // Center pin indicator (always in the center of the screen)
                    VStack {
                        Image(systemName: "mappin")
                            .font(.title)
                            .foregroundColor(.red)
                        
                        // Shadow to make pin appear like it's hovering
                        Circle()
                            .fill(Color.red.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                    
                    // Show selected address in a banner when available
                    if showingSelectedAddress {
                        VStack {
                            Spacer()
                            Text(selectedAddress)
                                .padding()
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(10)
                                .padding(.bottom, 80)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    // Show loading indicator during geocoding
                    if isGeocodingInProgress {
                        VStack {
                            Spacer()
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                Text("Finding address...")
                                    .padding(.leading, 5)
                            }
                            .padding()
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(10)
                            .padding(.bottom, 80)
                        }
                    }
                }
                
                // Buttons at the bottom
                VStack(spacing: 10) {
                    Button(action: {
                        print("Button pressed: Get Current Center Location")
                        // Use the center coordinates of the current region view
                        let centerCoordinate = region.center
                        print("Center coordinates: \(centerCoordinate.latitude), \(centerCoordinate.longitude)")
                        isGeocodingInProgress = true
                        reverseGeocode(location: centerCoordinate)
                    }) {
                        Text("Get Current Center Location")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isGeocodingInProgress ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                    .disabled(isGeocodingInProgress)
                    
                    Button(action: {
                        if !selectedAddress.isEmpty {
                            selectedLocation = selectedAddress
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Confirm Selection")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(!selectedAddress.isEmpty ? Color.green : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(selectedAddress.isEmpty)
                }
                .padding()
            }
        }
        .navigationTitle("Select Location")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // If location is already selected, show it on the map
            if !selectedLocation.isEmpty {
                searchText = selectedLocation
                searchLocation()
            }
            
            // Make sure location services are enabled
            checkLocationServices()
        }
    }
    
    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            print("Location services are enabled")
        } else {
            print("Location services are NOT enabled")
            selectedAddress = "Please enable location services in Settings"
            showingSelectedAddress = true
        }
    }
    
    private func searchLocation() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        let search = MKLocalSearch(request: request)
        
        isGeocodingInProgress = true
        search.start { response, error in
            DispatchQueue.main.async {
                isGeocodingInProgress = false
                
                if let error = error {
                    print("Search error: \(error.localizedDescription)")
                    selectedAddress = "Error searching location: \(error.localizedDescription)"
                    showingSelectedAddress = true
                    return
                }
                
                if let item = response?.mapItems.first {
                    let coordinate = item.placemark.coordinate
                    region.center = coordinate
                    region.span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) // Zoom in closer
                    
                    // Add annotation for search result
                    annotations = [IdentifiableCoordinate(coordinate: coordinate)]
                    
                    // Get address for the found location
                    reverseGeocode(location: coordinate)
                } else {
                    selectedAddress = "No locations found for '\(searchText)'"
                    showingSelectedAddress = true
                }
            }
        }
    }
    
    private func reverseGeocode(location: CLLocationCoordinate2D) {
        print("Starting reverse geocoding for: \(location.latitude), \(location.longitude)")
        isGeocodingInProgress = true
        showingSelectedAddress = false
        
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        
        geocoder.reverseGeocodeLocation(clLocation) { placemarks, error in
            // Force UI updates to happen on the main thread
            DispatchQueue.main.async {
                isGeocodingInProgress = false
                
                if let error = error {
                    print("Reverse geocoding error: \(error.localizedDescription)")
                    self.selectedAddress = "Error finding address: \(error.localizedDescription)"
                    self.showingSelectedAddress = true
                    return
                }
                
                if let placemark = placemarks?.first {
                    // Format address components
                    var addressComponents: [String] = []
                    
                    if let name = placemark.name, !name.isEmpty {
                        addressComponents.append(name)
                    }
                    
                    if let thoroughfare = placemark.thoroughfare {
                        var streetAddress = thoroughfare
                        if let subThoroughfare = placemark.subThoroughfare {
                            streetAddress = "\(subThoroughfare) \(thoroughfare)"
                        }
                        addressComponents.append(streetAddress)
                    }
                    
                    if let locality = placemark.locality {
                        addressComponents.append(locality)
                    }
                    
                    if let subLocality = placemark.subLocality, !addressComponents.contains(subLocality) {
                        addressComponents.append(subLocality)
                    }
                    
                    if let administrativeArea = placemark.administrativeArea {
                        addressComponents.append(administrativeArea)
                    }
                    
                    if let postalCode = placemark.postalCode {
                        addressComponents.append(postalCode)
                    }
                    
                    if let country = placemark.country {
                        addressComponents.append(country)
                    }
                    
                    // Join all components with commas
                    self.selectedAddress = addressComponents.joined(separator: ", ")
                    print("Found address: \(self.selectedAddress)")
                    self.showingSelectedAddress = true
                    
                    // Save this coordinate as the selected one
                    self.selectedCoordinate = location
                    
                    // Add an annotation for the selected location
                    self.annotations = [IdentifiableCoordinate(coordinate: location)]
                } else {
                    print("No placemarks found")
                    self.selectedAddress = "No address found for this location"
                    self.showingSelectedAddress = true
                }
            }
        }
    }
}

struct MapSelectionView_Previews: PreviewProvider {
    @State static var location = ""
    
    static var previews: some View {
        NavigationView {
            MapSelectionView(selectedLocation: $location)
        }
    }
}
