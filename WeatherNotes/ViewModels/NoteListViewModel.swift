//
//  NoteListViewModel.swift
//  WeatherNotes
//
//  Created by Nikush on 19.11.2025.
//

import Foundation
import Combine

@MainActor
final class NotesListViewModel: ObservableObject {
    @Published private(set) var notes: [Note] = []
    
    private let storage: NotesStorage
    
    init(storage: NotesStorage? = nil) {
        self.storage = storage ?? NotesStorage()
        loadNotes()
    }
    
    func loadNotes() {
        notes = storage.loadNotes()
    }
}
