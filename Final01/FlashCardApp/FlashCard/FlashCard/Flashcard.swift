//
//  Flashcard.swift
//  FlashCard
//
//  Created by RPS on 19/10/24.
//


import Foundation
import CoreData

struct Flashcard: Identifiable {
    var id: UUID
    var word: String
    var translation: String
    var exampleSentence: String

    init(word: String, translation: String, exampleSentence: String) {
        self.id = UUID()
        self.word = word
        self.translation = translation
        self.exampleSentence = exampleSentence
    }
}
