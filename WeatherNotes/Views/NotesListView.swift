//
//  NotesListView.swift
//  WeatherNotes
//
//  Created by Nikush on 19.11.2025.
//

import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesListViewModel()
    @State private var isPresentingAddNote = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.notes.isEmpty {
                    ContentUnavailableView(
                        "No notes yet",
                        systemImage: "cloud.sun",
                        description: Text("Add your first note with weather.")
                    )
                } else {
                    List(viewModel.notes) { note in
                        NavigationLink {
                            NoteDetailsView(note: note)
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(note.text)
                                        .lineLimit(1)
                                        .font(.headline)
                                    
                                    Text(formatDate(note.createdAt))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(alignment: .trailing) {
                                    Text("\(Int(note.weather.temperature))°C")
                                        .font(.headline)
                                    
                                    Text(note.weather.conditionDescription)
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Weather Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddNote, onDismiss: {
                // Після закриття екрану додавання — перечитуємо нотатки
                viewModel.loadNotes()
            }) {
                AddNoteView()
            }
            .onAppear {
                viewModel.loadNotes()
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NotesListView()
}
