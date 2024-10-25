//
//  UserProfile.swift
//  FlashCard
//
//  Created by RPS on 19/10/24.
//
//

import Foundation
import SwiftData


@Model public class UserProfile {
    var name: String?
    var masteredFlashcards: Int64? = 0
    var quizAttempt: Int64? = 0
    var correctAnswres: Int64? = 0
    public init() {

    }
    
}
