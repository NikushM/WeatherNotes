//
//  WeatherService.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import Foundation
import CoreLocation

// MARK: - WeatherServiceError
enum WeatherServiceError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingFailed
    case noWeatherData
}

// MARK: - WeatherService
final class WeatherService {
    private let apiKey: String
    private let session: URLSession
    
    // MARK: - Initialization
    init(session: URLSession, apiKey: String = Bundle.main.object(forInfoDictionaryKey: "OPENWEATHER_API_KEY") as? String ?? "") {
        self.session = session
        self.apiKey = apiKey
    }
    
    convenience init() {
        self.init(session: URLSession.shared)
    }
    
    // MARK: - Public Methods
    func fetchWeather(for city: String) async throws -> WeatherSummary {
        guard let url = makeURL(for: city) else {
            throw WeatherServiceError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw WeatherServiceError.invalidResponse
        }
        
        do {
            let apiResponse = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
            
            guard let weatherInfo = apiResponse.weather.first else {
                throw WeatherServiceError.noWeatherData
            }
            
            let summary = WeatherSummary(
                temperature: apiResponse.main.temp,
                conditionDescription: weatherInfo.description.capitalized,
                iconCode: weatherInfo.icon,
                cityName: apiResponse.name
            )
            
            return summary
        } catch {
            print("❌ Decode error:", error)
            throw WeatherServiceError.decodingFailed
        }
    }
    
    // MARK: - Private Helpers
    
    private func makeURL(for city: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en")
        ]
        
        return components.url
    }
}

extension WeatherService {
    // MARK: - Geolocation Fetch
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherSummary {
        guard let url = makeURL(latitude: latitude, longitude: longitude) else {
            throw WeatherServiceError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw WeatherServiceError.invalidResponse
        }
        
        do {
            let apiResponse = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
            
            guard let weatherInfo = apiResponse.weather.first else {
                throw WeatherServiceError.noWeatherData
            }
            
            return WeatherSummary(
                temperature: apiResponse.main.temp,
                conditionDescription: weatherInfo.description.capitalized,
                iconCode: weatherInfo.icon,
                cityName: apiResponse.name
            )
        } catch {
            throw WeatherServiceError.decodingFailed
        }
    }
    
    // MARK: - Geolocation URL Builder
    private func makeURL(latitude: Double, longitude: Double) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "lat", value: "\(latitude)"),
            URLQueryItem(name: "lon", value: "\(longitude)"),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en")
        ]
        return components.url
    }
}
