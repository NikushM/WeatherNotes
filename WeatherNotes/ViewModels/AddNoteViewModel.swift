//
//  AddNoteViewModel.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class AddNoteViewModel: ObservableObject {
    // MARK: - Properties
    @Published var text: String = ""
    @Published var isSaving: Bool = false
    @Published var errorMessage: String?
    
    private let weatherService: WeatherService
    private let storage: NotesStorage
    
    // MARK: - Initialization
    init(
        weatherService: WeatherService? = nil,
        storage: NotesStorage? = nil
    ) {
        self.weatherService = weatherService ?? WeatherService()
        self.storage = storage ?? NotesStorage()
    }
    
    // MARK: - Save Note
    func saveNote(location: CLLocation?) async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter some text for the note."
            return
        }
        
        isSaving = true 
        errorMessage = nil
        
        do {
            let weather: WeatherSummary
            
            if let location {
                weather = try await weatherService.fetchWeather(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                )
            } else {
                weather = try await weatherService.fetchWeather(for: "Kyiv")
            }
            
            let newNote = Note(
                id: UUID(),
                text: trimmed,
                createdAt: Date(),
                weather: weather
            )
            
            var notes = storage.loadNotes()
            notes.insert(newNote, at: 0)
            storage.saveNotes(notes)
            text = ""
        } catch let error as WeatherServiceError {
            switch error {
            case .invalidURL:
                errorMessage = "Internal error: invalid URL."
            case .requestFailed:
                errorMessage = "Network request failed. Please check your connection."
            case .invalidResponse:
                errorMessage = "Server error. Please try again later."
            case .decodingFailed:
                errorMessage = "Failed to parse weather data."
            case .noWeatherData:
                errorMessage = "No weather data available."
            }
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
        
        isSaving = false
    }
}
