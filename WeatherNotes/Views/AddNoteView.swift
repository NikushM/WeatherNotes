//
//  AddNoteView.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import SwiftUI

struct AddNoteView: View {
    @StateObject private var viewModel = AddNoteViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextEditor(text: $viewModel.text)
                    .frame(minHeight: 150)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal)
                
                if viewModel.isSaving {
                    ProgressView("Saving...")
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Button {
                    Task {
                        await viewModel.saveNote()
                        if viewModel.errorMessage == nil {
                            // Якщо збереження пройшло без помилок — закриваємо екран
                            dismiss()
                        }
                    }
                } label: {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Add Note")
        }
    }
}

#Preview {
    AddNoteView()
}
