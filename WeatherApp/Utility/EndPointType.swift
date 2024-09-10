//
//  EndPointType.swift
//  WeatherApp
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import Foundation

// Enum representing the HTTP methods used in network requests
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

// Protocol defining the structure of an endpoint for network requests
protocol EndPointType {
    var url: URL? { get }
    var path: String { get }
    var baseURL: String { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
    var method: HTTPMethod { get }
}

// Enum defining different endpoints for fetching weather data
enum WeatherEndPoint {
    case fetchWeatherByCity(_ city: String)
    case fetchWeatherIcon(_ name: String)
}

// Extension to conform WeatherEndPoint to the EndPointType protocol
extension WeatherEndPoint: EndPointType {
    private var apiKey: String {
        return "2de24da4889b3c0e7f9c72b3e46d19bc"
    }
    
    // Building the full URL for the endpoint
    var url: URL? {
        return URL(string: baseURL + path)
    }
    
    // Defining the path for each endpoint
    var path: String {
        switch self {
        case .fetchWeatherByCity(let city):
            let cityQuery = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

            return "data/2.5/weather?q=\(cityQuery)&appid=\(apiKey)&units=metric"
        case .fetchWeatherIcon(let iconName):
            return "img/wn/\(iconName)@2x.png"
        }
    }
    
    // Return the base URL for each endpoint
    var baseURL: String {
        switch self {
        case .fetchWeatherByCity:
            return "https://api.openweathermap.org/"
        case .fetchWeatherIcon:
            return "https://openweathermap.org/"
        }
    }

    var body: Encodable? { nil }

    var headers: [String : String]? {
        APIManager.commonHeaders
    }

    var method: HTTPMethod {
        return .get
    }


}

