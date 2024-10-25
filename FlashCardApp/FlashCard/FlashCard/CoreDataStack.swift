//
//  CoreDataStack.swift
//  FlashCard
//
//  Created by RPS on 19/10/24.
//


import CoreData

struct CoreDataStack {
    static let shared = CoreDataStack()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FlashCard")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
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

