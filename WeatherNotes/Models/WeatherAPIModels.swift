//
//  WeatherAPIModels.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import Foundation

struct WeatherAPIResponse: Decodable {
    let name: String
    let main: MainInfo
    let weather: [WeatherInfo]
}

struct MainInfo: Decodable {
    let temp: Double
}

struct WeatherInfo: Decodable {
    let description: String
    let icon: String
}
