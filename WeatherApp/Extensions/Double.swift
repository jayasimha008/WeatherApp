//
//  Double.swift
//  WeatherApp
//
//  Created by Jaya Siva Bhaskar Karlapalem on 9/8/24.
//

import Foundation

extension Double {
    func formattedTemperature() -> String {
        return String(format: "%.1f°",self)
    }
}
