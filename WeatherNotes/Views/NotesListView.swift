import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesListViewModel()
    @State private var isPresentingAddNote = false
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                LinearGradient(
                    colors: [
                        Color.blue.opacity(colorScheme == .dark ? 0.6 : 0.3),
                        Color.cyan.opacity(colorScheme == .dark ? 0.4 : 0.1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    if viewModel.notes.isEmpty {
                        ContentUnavailableView {
                            Label("No notes yet", systemImage: "cloud.sun")
                        } description: {
                            Text("Add your first note with weather.")
                        }
                    } else {
                        List {
                            ForEach(viewModel.notes) { note in
                                NavigationLink {
                                    NoteDetailsView(note: note)
                                } label: {
                                    HStack(spacing: 12) {
                                        Image(systemName: note.weather.systemIconName)
                                            .symbolRenderingMode(.multicolor)
                                            .font(.title3)
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(note.text)
                                                .lineLimit(1)
                                                .font(.headline)
                                            
                                            Text(formatDate(note.createdAt))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 4) {
                                            Text("\(Int(note.weather.temperature))°C")
                                                .font(.headline)
                                            
                                            Text(note.weather.conditionDescription)
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                                .listRowBackground(
                                    Color(.secondarySystemBackground)
                                        .opacity(colorScheme == .dark ? 0.7 : 0.9)
                                )
                            }
                            .onDelete { offsets in
                                viewModel.deleteNotes(at: offsets)
                            }
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresentingAddNote = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddNote, onDismiss: {
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
