//
//  FlashCardApp.swift
//  FlashCard
//
//  Created by RPS on 18/10/24.
//

import SwiftUI

@main
struct FlashCardApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            WelcomeFlashcardView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
