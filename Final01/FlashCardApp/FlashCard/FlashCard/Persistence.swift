//
//  Persistence.swift
//  FlashCard
//
//  Created by RPS on 18/10/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    // Add a static preview property
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let context = controller.container.viewContext
        
        // Insert sample data here if needed
        let sampleFlashcard = FlashcardEntity(context: context)
        sampleFlashcard.word = "Hello"
        sampleFlashcard.translation = "Hola"
        sampleFlashcard.exampleSentence = "Hello, how are you?"

        let sampleFlashcard2 = FlashcardEntity(context: context)
        sampleFlashcard2.word = "Goodbye"
        sampleFlashcard2.translation = "Adiós"
        sampleFlashcard2.exampleSentence = "Goodbye, see you later!"

        do {
            try context.save()
        } catch {
            // Handle the error
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "FlashCard")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    func saveContext() {
        let context = viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
