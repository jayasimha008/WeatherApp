//
//  APIManager.swift
//  WeatherApp
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import Foundation

// Enum representing different network errors
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case network(_ error: Error?)
    case invalidError
}

// Protocol defining a service for making API requests
protocol APIManagerService {
    func request<T: Decodable>(type: EndPointType) async throws -> T
}

// Class implementing APIManagerService to handle API requests
final class APIManager: APIManagerService {
    
    // Asynchronous function to make a request and decode the response into a type conforming to Decodable
    func request<T: Decodable>(type: EndPointType) async throws -> T {
        guard let url = type.url else { throw NetworkError.invalidURL }

        var request = URLRequest(url: url)

        if let body = type.body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        // Set HTTP headers for the request
        request.allHTTPHeaderFields = type.headers
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw NetworkError.invalidResponse }

        // Return data as is if the requested type is Data
        if T.self == Data.self {
            return data as! T
        }else {
            return try JSONDecoder().decode(T.self, from: data)
        }
    }
    
    // Static property providing common HTTP headers for requests
    static var commonHeaders: [String: String]? {
        ["Content-Type" : "application/json"]
    }
}
