//
//  WeatherService.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import Foundation

enum WeatherServiceError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingFailed
    case noWeatherData
}

final class WeatherService {
    private let apiKey = "eb8cbd50ddb4b078412365011c4654cf"
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

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

    // MARK: - Private

    private func makeURL(for city: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/weather"
        components.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en") // можна "uk", якщо хочеш опис українською
        ]

        return components.url
    }
}
