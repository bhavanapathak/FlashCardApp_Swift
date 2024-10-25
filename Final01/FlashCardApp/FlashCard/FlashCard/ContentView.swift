//
//  ContentView.swift
//  FlashCard
//
//  Created by RPS on 18/10/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var searchText: String = ""
    @State private var showingAddCard = false
    @State private var showingQuiz = false
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: FlashcardEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FlashcardEntity.word, ascending: true)]
    ) var flashcards: FetchedResults<FlashcardEntity>
    
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var learnedCount = 0 // Track learned flashcards
    private var retentionRate: Double {
        let totalLearned = Double(learnedCount)
        let total = Double(flashcards.count)
        return total > 0 ? totalLearned / total : 0
    }
    
    var filteredFlashcards: [FlashcardEntity] {
        if searchText.isEmpty {
            return Array(flashcards)
        } else {
            return flashcards.filter { $0.word?.contains(searchText) ?? false }
        }
    }
    
    var body: some View {
        VStack {
            // Search bar
            SearchBar(text: $searchText)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)

            // List of flashcards
            List {
                ForEach(filteredFlashcards, id: \.self) { flashcard in
                    NavigationLink(destination: FlippableFlashcardView(flashcard: flashcard)) {
                        Text(flashcard.word ?? "Unknown Word")
                            .font(.headline)
                            .padding()
                            .background(Color.blue.opacity(0.3)) // Light background color
                            .cornerRadius(10)
                            .foregroundColor(.white) // Text color
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Add shadow
                    }
                }
                .onDelete(perform: deleteFlashcards)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Flashcards")
            .background(Color.gray.opacity(0.05)) // Subtle background for the list

            // Navigation buttons at the bottom
            HStack {
                Button(action: {
                    showingAddCard.toggle()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.blue) // Changed button color to purple
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                Button(action: {
                    showingQuiz.toggle() // Navigate to Quiz View
                }) {
                    Text("Start Quiz")
                        .fontWeight(.semibold)
                        .padding(10)
                        .background(Color.blue) // Changed button color to purple
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1)) // Background for buttons
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
        }
        .padding()
        .background(Color.white) // Overall background
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingAddCard) {
            FlashcardDetailView(flashcard: nil) // Pass nil for new flashcard
        }
        .sheet(isPresented: $showingQuiz) {
            QuizView(learnedCount: $learnedCount, flashcards: Array(flashcards), correctCount: $correctCount, wrongCount: $wrongCount)
        }
    }
    
    private func deleteFlashcards(at offsets: IndexSet) {
        for index in offsets {
            let flashcard = flashcards[index]
            viewContext.delete(flashcard)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error saving context after deleting flashcard: \(error)")
        }
    }
}

