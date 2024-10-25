//
//  UserProfile.swift
//  FlashCard
//
//  Created by RPS on 19/10/24.
//

import CoreData






public class UserProfile: NSManagedObject {
    // You can add any custom functionality or methods here if needed.
}

extension UserProfile {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: String(describing: UserProfile.self))
    }

    @NSManaged public var name: String? // Optional String for the user's name
    @NSManaged public var masteredFlashcards: Int64 // Integer for mastered flashcards count
    @NSManaged public var quizAttempts: Int64 // Integer for total quiz attempts
    @NSManaged public var correctAnswers: Int64 // Integer for correct answers count
}



