//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import SwiftUI
import CoreLocation
import Combine

// ViewModel to handle location updates and reverse geocoding
class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var geocoder = CLGeocoder()

    @Published var cityName: String = "Unknown"

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    // CLLocationManagerDelegate method called when new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Reverse geocode the location to get the city name
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    // Update the city name on the main thread
                    self?.cityName = placemark.locality ?? "Unknown"
                }
            }
        }
    }
    // CLLocationManagerDelegate method called when location updates fail
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

