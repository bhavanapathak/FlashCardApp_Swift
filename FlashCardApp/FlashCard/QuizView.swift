//
//  QuizView.swift
//  FlashCard
//
//  Created by RPS on 19/10/24.

     
import SwiftUI

struct QuizView: View {
    @Binding var learnedCount: Int
    var flashcards: [FlashcardEntity]
    @Binding var correctCount: Int
    @Binding var wrongCount: Int
    
    @State private var userName: String = ""
    @State private var isNameEntered: Bool = false
    @State private var currentFlashcard: FlashcardEntity?
    @State private var options: [String] = []
    @State private var selectedOption: String? = nil
    
    @State private var isQuizComplete: Bool = false
    @State private var attemptedFlashcards: Set<FlashcardEntity> = []
    @State private var timer: Timer?
    @State private var timeRemaining: Int = 10
    @State private var correctAnswer: String = ""
    
    // Progress bar
    private var retentionRate: Double {
        let totalAttempts = correctCount + wrongCount
        return totalAttempts > 0 ? Double(correctCount) / Double(totalAttempts) : 0
    }

    var body: some View {
        VStack {
            if isQuizComplete {
                // Quiz completion view
                Text("Quiz Complete!")
                    .font(.largeTitle)
                    .padding()
                
                if correctCount > 5 {
                    Text("Congratulations, \(userName)! 🎉")
                        .font(.headline)
                        .padding(.top, 10)
                } else {
                    Text("Better luck next time, \(userName)! 😊")
                        .font(.headline)
                        .padding(.top, 10)
                }
                
                Text("Correct: \(correctCount)")
                    .font(.headline)
                    .foregroundColor(.green)
                Text("Wrong: \(wrongCount)")
                    .font(.headline)
                    .foregroundColor(.red)
                
                // Retention rate progress bar
                ProgressView("Retention Rate: \(Int(retentionRate * 100))%", value: retentionRate, total: 1.0)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()
                
                Button("Retry Quiz") {
                    resetQuiz()
                }
                .padding()
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)
            } else {
                if isNameEntered {
                    if let flashcard = currentFlashcard {
                        Text(flashcard.word ?? "Unknown")
                            .font(.largeTitle)
                            .padding()
                        
                        // Timer display
                        HStack {
                            Text("Time Remaining: \(timeRemaining)s")
                                .font(.headline)
                                .foregroundColor(timeRemaining > 5 ? .black : .red)
                            Text("⏳")
                        }
                        .padding()
                        
                        VStack {
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    checkAnswer(selectedOption: option)
                                }) {
                                    Text(option)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(
                                            backgroundColor(for: option)
                                        )
                                        .foregroundColor(.black)
                                        .cornerRadius(10)
                                        .padding(.bottom, 5)
                                }
                                .disabled(selectedOption != nil)
                            }
                        }
                    } else {
                        Text("Loading...")
                            .font(.headline)
                    }
                    
                    Spacer()
                    
                    Button("End Quiz") {
                        stopTimer()
                        isQuizComplete = true
                    }
                    .padding()
                    .background(Color.red.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                } else {
                    // User name input view
                    Text("Enter Your Name to Start the Quiz")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    
                    TextField("Your Name", text: $userName)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding()
                    
                    Button("Start Quiz") {
                        if !userName.isEmpty {
                            isNameEntered = true
                            loadNewFlashcard()
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.blue.opacity(0.1)) // Set background color for the entire view
        .onAppear(perform: {
            correctCount = 0
            wrongCount = 0
            attemptedFlashcards.removeAll()
            isQuizComplete = false
        })
        .onDisappear {
            stopTimer()
        }
    }
    
    private func startTimer() {
        stopTimer()
        timeRemaining = 10
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                handleTimeout()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func handleTimeout() {
        stopTimer()
        wrongCount += 1
        selectedOption = nil
        showCorrectAnswer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            loadNewFlashcard()
        }
    }
    
    private func loadNewFlashcard() {
        if attemptedFlashcards.count < flashcards.count {
            currentFlashcard = getRandomFlashcard()
            options = generateOptions(for: currentFlashcard)
            selectedOption = nil
            correctAnswer = currentFlashcard?.translation ?? "Unknown"
            startTimer()
        } else {
            isQuizComplete = true
            stopTimer()
        }
    }
    
    private func getRandomFlashcard() -> FlashcardEntity? {
        let availableFlashcards = flashcards.filter { !attemptedFlashcards.contains($0) }
        return availableFlashcards.shuffled().first
    }
    
    private func generateOptions(for flashcard: FlashcardEntity?) -> [String] {
        guard let flashcard = flashcard else { return [] }
        let correctAnswer = flashcard.translation ?? "Unknown"
        var fakeOptions: [String] = []
        let otherFlashcards = flashcards.filter { $0 != flashcard }
        let randomOptions = otherFlashcards.shuffled().prefix(3)
        fakeOptions = randomOptions.compactMap { $0.translation }
        var allOptions = [correctAnswer] + fakeOptions
        allOptions.shuffle()
        return allOptions
    }
    
    private func checkAnswer(selectedOption: String) {
        stopTimer()
        self.selectedOption = selectedOption
        if selectedOption == correctAnswer {
            correctCount += 1
        } else {
            wrongCount += 1
        }
        showCorrectAnswer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            loadNewFlashcard()
        }
    }
    
    private func resetQuiz() {
        correctCount = 0
        wrongCount = 0
        isQuizComplete = false
        attemptedFlashcards.removeAll()
        loadNewFlashcard()
    }
    
    private func backgroundColor(for option: String) -> Color {
        if let selected = selectedOption {
            if selected == option && selected == correctAnswer {
                return Color.green
            } else if selected == option && selected != correctAnswer {
                return Color.red
            } else if option == correctAnswer {
                return Color.green
            }
        }
        return Color.blue.opacity(0.2)
    }
    
    private func showCorrectAnswer() {
        if let currentFlashcard = currentFlashcard {
            attemptedFlashcards.insert(currentFlashcard)
        }
    }
}

// Preview
struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(learnedCount: .constant(0), flashcards: [], correctCount: .constant(0), wrongCount: .constant(0))
    }
}

