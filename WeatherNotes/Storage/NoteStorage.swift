//
//  NoteStorage.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import Foundation

final class NotesStorage {
    private let key = "saved_notes"
    
    func loadNotes() -> [Note] {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return []
        }
        
        do {
            let notes = try JSONDecoder().decode([Note].self, from: data)
            return notes
        } catch {
            print("❌ Failed to decode notes:", error)
            return []
        }
    }
    
    func saveNotes(_ notes: [Note]) {
        do {
            let data = try JSONEncoder().encode(notes)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("❌ Failed to encode notes:", error)
        }
    }
}
