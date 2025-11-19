//
//  NoteDetailsView.swift
//  WeatherNotes
//
//  Created by Nikush on 19.11.2025.
//

import SwiftUI

struct NoteDetailsView: View {
    let note: Note
    
    var body: some View {
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
                    VStack(alignment: .leading, spacing: 8) {
                        Text(note.weather.cityName)
                            .font(.headline)
                        
                        Text(note.weather.conditionDescription)
                            .font(.subheadline)
                    }
                    
                    Spacer()
                    
                    Text("\(Int(note.weather.temperature))°C")
                        .font(.system(size: 40, weight: .bold))
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
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
