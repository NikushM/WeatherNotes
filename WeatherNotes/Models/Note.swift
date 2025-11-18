//
//  Note.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var text: String
    let createdAt: Date
    var weather: WeatherSummary
}

struct WeatherSummary: Codable {
    let temperature: Double
    let conditionDescription: String
    let iconCode: String
    let cityName: String
}
