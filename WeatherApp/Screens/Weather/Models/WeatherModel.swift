//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import UIKit

// Model representing the weather data received from the API
struct WeatherModel: Decodable, Identifiable {
    let id: Int
    let name: String
    let main: Main
    let weather: [Weather]    
}

// Model representing weather conditions
struct Weather: Decodable {
    let description, iconName: String
    let icon: String
    
    // Custom coding keys to map JSON keys to property names
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
        case icon
    }
}

// Model representing the main weather information
struct Main: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    
    // Custom coding keys to map JSON keys to property names
    enum CodingKeys: String, CodingKey {
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case temp
    }
}
