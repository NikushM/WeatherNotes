//
//  NoteListViewModel.swift
//  WeatherNotes
//
//  Created by Nikush on 19.11.2025.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class NotesListViewModel: ObservableObject {
    // MARK: - Properties
    @Published private(set) var notes: [Note] = []
    
    private let storage: NotesStorage
    
    // MARK: - Initialization
    init(storage: NotesStorage? = nil) {
        self.storage = storage ?? NotesStorage()
        loadNotes()
    }
    
    // MARK: - Public Methods
    func loadNotes() {
        notes = storage.loadNotes()
    }
    
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        storage.saveNotes(notes)
    }
}
