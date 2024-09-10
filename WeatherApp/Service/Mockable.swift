//
//  JSONLoader.swift
//  WeatherApp
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJson<T: Decodable>(fileName: String, decodeType: T.Type) -> T
}

extension Mockable {
    var bundle: Bundle {
        return Bundle.main
    }

    func loadJson<T: Decodable>(fileName: String, decodeType: T.Type) -> T {
        guard let path = bundle.url(forResource: fileName, withExtension: "json") else {
            fatalError("Failed to load JSON file.")
        }
        do {
            let data = try Data(contentsOf: path)
            let decodeObject = try JSONDecoder().decode(decodeType, from: data)
            return decodeObject
        }catch {
            print("❌ \(error)")
            fatalError("Failed to decode the JSON.")
        }
    }
}

