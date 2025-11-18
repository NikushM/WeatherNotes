//
//  WeatherView.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import SwiftUI

struct WeatherView: View {
    @State private var weather: WeatherSummary?
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let weatherService = WeatherService()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let weather {
                    VStack(spacing: 8) {
                        Text(weather.cityName)
                            .font(.title)

                        Text("\(Int(weather.temperature))°C")
                            .font(.system(size: 40, weight: .bold))

                        Text(weather.conditionDescription)
                            .font(.body)
                    }
                } else {
                    Text("No data yet")
                        .foregroundColor(.secondary)
                }

                if isLoading {
                    ProgressView()
                }

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }

                Button("Load Kyiv weather") {
                    Task {
                        await loadWeather()
                    }
                }
                .buttonStyle(.borderedProminent)

                Spacer()
            }
            .padding()
            .navigationTitle("Weather Test")
        }
    }

    private func loadWeather() async {
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }

        do {
            let result = try await weatherService.fetchWeather(for: "Kyiv")
            await MainActor.run {
                self.weather = result
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to load weather: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    WeatherView()
}
