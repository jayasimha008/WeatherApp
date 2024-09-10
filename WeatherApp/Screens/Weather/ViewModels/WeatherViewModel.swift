//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import SwiftUI

final class WeatherViewModel: ObservableObject {
    
    // Published properties to notify SwiftUI views about changes
    @Published var isError: Bool = false
    @Published var weathers: [WeatherModel] = []
    @Published var imageCache = [String: UIImage]()

    private let manager: APIManagerService
    private let cacheManager = CacheManager()

    init(manager: APIManagerService = APIManager()) {
        self.manager = manager
    }
    
    // Fetches weather data for a given city
    func fetchWeather(for city: String) {
        guard !city.isEmpty else { return }
        Task {
            do {
                // Make an API request to fetch weather data
                let weather: WeatherModel = try await manager.request(type: WeatherEndPoint.fetchWeatherByCity(city))
                
                // Update UI-related properties on the main thread
                DispatchQueue.main.async {
                    self.weathers.append(weather)
                    self.loadIcon(for: weather)
                    self.isError = false  // Reset error on successful fetch
                }
            } catch {
                // Handle error and update the isError property on the main thread
                DispatchQueue.main.async {
                    self.isError = true // Set error on failure
                }
            }
        }
    }
    // Loads weather icon and updates image cache
    private func loadIcon(for weather: WeatherModel) {
        guard let iconCode = weather.weather.first?.icon else { return }
        
        // Check if the icon is already cached
        if let cachedImage = cacheManager.getCachedImage(forKey: iconCode) {
            // Update image cache on the main thread
            DispatchQueue.main.async {
                self.imageCache[iconCode] = cachedImage
            }
            return
        }
        // Fetch icon data if not cached
        Task {
            do {
                let data: Data = try await manager.request(type: WeatherEndPoint.fetchWeatherIcon(iconCode))
                guard let image = UIImage(data: data) else { return }
                // Update image cache on the main thread
                DispatchQueue.main.async {
                    self.cacheManager.cacheImage(image, forKey: iconCode)
                    self.imageCache[iconCode] = image
                }
                
            } catch {
                // Log errors encountered during icon fetch
                print(error)
            }
        }
    }

}
