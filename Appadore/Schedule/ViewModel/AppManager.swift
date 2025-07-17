//
//  AppManager.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import Foundation
import SwiftUI
import CoreData


class AppManager: ObservableObject {
    @AppStorage("isGameScheduled") var isGameScheduled: Bool = false
    
    @Published var questions: [FlagQuestion] = []
    @Published var isCountdownRunning = false
    @Published var countdownRemaining = 20
    @Published var questionTimeRemaining = 0
    @Published var isGameOver = false
    @Published var totalScore = 0
    @Published var currentQuestionIndex = 0
    @Published var selectedAnswer: Int? = nil
    @Published var showingAnswer = false
    
    var currentQuestion: FlagQuestion? {
        guard currentQuestionIndex < questions.count else { return nil }
        return questions[currentQuestionIndex]
    }
    
    private var timer: Timer?
    
    func loadQuestions() {
        guard let url = Bundle.main.url(forResource: "questions", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(FlagQuestionSet.self, from: data)
            questions = decoded.questions.shuffled().prefix(15).map { $0 }
                print("Loaded questions count: \(questions.count)")
        } catch {
            print("Error loading questions: \(error)")
        }
    }

    
//    func resumeState() {
//        let request: NSFetchRequest<AppCoreDataState> = GameState.fetchRequest()
//        if let saved = try? context.fetch(request).first {
//            currentQuestionIndex = Int(saved.currentIndex)
//            questionTimeRemaining = Int(saved.remainingTime)
//            score = Int(saved.score)
//            startQuestionTimer()
//        }
//    }
    
//    func deleteSavedState() {
//        let request: NSFetchRequest<GameState> = GameState.fetchRequest()
//        if let saved = try? context.fetch(request).first {
//            context.delete(saved)
//            try? context.save()
//        }
//       
//    }
    
    func startCountdown() {
        isGameScheduled = true
        isCountdownRunning = true
        countdownRemaining = 20
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { time in
            self.countdownRemaining -= 1
            if self.countdownRemaining == 0 {
                time.invalidate()
                self.isCountdownRunning = false
                self.startQuestionTimer()
            }
        }
    }
    
    func startQuestionTimer() {
        selectedAnswer = nil
        showingAnswer = false
        questionTimeRemaining = ScheduleStorage.shared.getTotalSeconds()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            self.questionTimeRemaining -= 1
            if self.questionTimeRemaining == 0 {
                t.invalidate()
                self.showingAnswer = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.nextQuestion()
                }
            }
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        if currentQuestionIndex >= questions.count {
            isGameOver = true
//            deleteSavedState()
            return
        } else {
            startQuestionTimer()
        }
    }
    
    func selectAnswer(_ id: Int) {
        guard let question = currentQuestion else { return }
        selectedAnswer = id
        showingAnswer = true
        timer?.invalidate()
        if id == question.answerID {
            totalScore += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nextQuestion()
        }
    }
    
    func resetGame() {
        currentQuestionIndex = 0
        selectedAnswer = nil
        showingAnswer = false
        isCountdownRunning = false
        countdownRemaining = 20
        questionTimeRemaining = ScheduleStorage.shared.getTotalSeconds()
        isGameOver = false
        totalScore = 0
        questions = []
//        startCountdown()
        restoreGameState()
        loadQuestions()
        isGameScheduled = false
    }

    func saveGameState() {
        UserDefaults.standard.set(currentQuestionIndex, forKey: "currentQuestionIndex")
        UserDefaults.standard.set(questionTimeRemaining, forKey: "questionTimeRemaining")
        UserDefaults.standard.set(totalScore, forKey: "totalScore")
        // Save any other state as needed
    }

    func restoreGameState() {
        currentQuestionIndex = UserDefaults.standard.integer(forKey: "currentQuestionIndex")
        questionTimeRemaining = UserDefaults.standard.integer(forKey: "questionTimeRemaining")
        totalScore = UserDefaults.standard.integer(forKey: "totalScore")
        // Restore any other state as needed
    }
}
