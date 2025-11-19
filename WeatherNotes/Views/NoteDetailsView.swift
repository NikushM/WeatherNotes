import SwiftUI

// MARK: - NoteDetailsView

struct NoteDetailsView: View {
    let note: Note
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    var body: some View {
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(note.text)
                        .font(.title2)
                        .bold()
                    
                    Text(formatDate(note.createdAt))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    HStack(spacing: 16) {
                        Image(systemName: note.weather.systemIconName)
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 32))
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(Color(.secondarySystemBackground)
                                        .opacity(colorScheme == .dark ? 0.9 : 0.8))
                            )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(note.weather.cityName)
                                .font(.headline)
                            
                            Text(note.weather.conditionDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("\(Int(note.weather.temperature))°C")
                            .font(.system(size: 40, weight: .bold))
                    }
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Date Formatter
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    NoteDetailsView(
        note: Note(
            id: UUID(),
            text: "Walk in the park",
            createdAt: Date(),
            weather: WeatherSummary(
                temperature: 12,
                conditionDescription: "Clear sky",
                iconCode: "01d",
                cityName: "Kyiv"
            )
        )
    )
}
