//
//  AddNoteViewModel.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import Foundation
import Combine

@MainActor
final class AddNoteViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var isSaving: Bool = false
    @Published var errorMessage: String?
    
    private let weatherService: WeatherService
    private let storage: NotesStorage
    
    init(
        weatherService: WeatherService? = nil,
        storage: NotesStorage? = nil
    ) {
        self.weatherService = weatherService ?? WeatherService()
        self.storage = storage ?? NotesStorage()
    }
    
    func saveNote() async {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Please enter some text for the note."
            return
        }
        
        isSaving = true
        errorMessage = nil
        
        do {
            let weather = try await weatherService.fetchWeather(for: "Kyiv")
            
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
            
        } catch {
            errorMessage = "Failed to save note: \(error.localizedDescription)"
        }
        
        isSaving = false
    }
}
