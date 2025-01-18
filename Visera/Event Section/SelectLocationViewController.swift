//
//  SelectLocationViewController.swift
//  Visera-HomeScreen
//
//  Created by student-2 on 17/01/25.
//

import UIKit
import MapKit
protocol LocationSelectionDelegate: AnyObject {
    func didSelectLocation(_ location: String)
}

class SelectLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!

    weak var delegate: LocationSelectionDelegate?
        private let locationManager = CLLocationManager()
        private var isFirstLocationUpdate = true

        override func viewDidLoad() {
            super.viewDidLoad()
            mapView.delegate = self
            searchBar.delegate = self

            // Configure the location manager
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()

            // Add long press gesture recognizer
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            mapView.addGestureRecognizer(longPressGesture)
        }

        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let userLocation = locations.last else { return }

            if isFirstLocationUpdate {
                isFirstLocationUpdate = false
                let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                mapView.setRegion(region, animated: true)
            }
        }

        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
        }

        @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began {
                let locationInView = gesture.location(in: mapView)
                let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)

                // Add annotation
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "Selected Location"
                mapView.removeAnnotations(mapView.annotations) // Clear existing annotations
                mapView.addAnnotation(annotation)
            }
        }
    }


extension SelectLocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let locationName = searchBar.text, !locationName.isEmpty else {
            print("Search bar is empty")
            return
        }

        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationName) { [weak self] (placemarks, error) in
            guard let self = self else { return }

            if let error = error {
                print("Geocoding failed: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = locationName
                self.mapView.removeAnnotations(self.mapView.annotations)
                self.mapView.addAnnotation(annotation)
                
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)
            }
        }

        searchBar.resignFirstResponder()
    }
}
