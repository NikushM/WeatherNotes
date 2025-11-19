//
//  AddNoteView.swift
//  WeatherNotes
//
//  Created by Nikush on 18.11.2025.
//

import SwiftUI

struct AddNoteView: View {
    @StateObject private var viewModel = AddNoteViewModel()
    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.teal.opacity(colorScheme == .dark ? 0.7 : 0.3),
                        Color.blue.opacity(colorScheme == .dark ? 0.5 : 0.15)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    TextEditor(text: $viewModel.text)
                        .frame(minHeight: 100, maxHeight: 180)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground).opacity(0.9))
                        )
                        .overlay(
                            Group {
                                if viewModel.text.isEmpty {
                                    Text("Write your note...")
                                        .foregroundColor(.secondary.opacity(0.6))
                                        .padding(.leading, 16)
                                        .padding(.top, 14)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    
                    if viewModel.isSaving {
                        ProgressView("Saving...")
                            .tint(.white)
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    
                    
                    Button {
                        Task {
                            await viewModel.saveNote(location: locationManager.currentLocation)
                            if viewModel.errorMessage == nil {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .foregroundColor(.accentColor)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .disabled(
                        viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        || viewModel.isSaving
                    )
                    .opacity(
                        viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        || viewModel.isSaving ? 0.5 : 1
                    )
                    
                    Spacer()
                }
            }
            .navigationTitle("Add Note")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                locationManager.requestLocation()
            }
        }
    }
}

#Preview {
    AddNoteView()
}
