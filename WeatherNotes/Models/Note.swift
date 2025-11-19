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

extension WeatherSummary {
    var systemIconName: String {
        switch iconCode.prefix(2) {
        case "01":
            return "sun.max.fill"
        case "02", "03":
            return "cloud.sun.fill"
        case "04":
            return "cloud.fill"
        case "09", "10":
            return "cloud.rain.fill"
        case "11":
            return "cloud.bolt.rain.fill"
        case "13":
            return "snowflake"
        case "50":
            return "cloud.fog.fill"
        default:
            return "cloud.fill"
        }
    }
}
