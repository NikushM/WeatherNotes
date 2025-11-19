//
//  WeatherAPIModels.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import Foundation

// MARK: - WeatherAPIResponse
struct WeatherAPIResponse: Decodable {
    let name: String
    let main: MainInfo
    let weather: [WeatherInfo]
}

// MARK: - MainInfo
struct MainInfo: Decodable {
    let temp: Double
}

// MARK: - WeatherInfo
struct WeatherInfo: Decodable {
    let description: String
    let icon: String
}
