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
    @Published var countdownRemaining = AppConstants.countdownStartValue
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
            if let questionIDs = UserDefaults.standard.array(forKey: "questionIDs") as? [String] {
                // Load all questions from JSON
                let allQuestions = decoded.questions
                questions = questionIDs.compactMap { id in
                    allQuestions.first(where: { $0.id == id })
                }
            } else {
                let shuffledQuestions = decoded.questions.shuffled().prefix(15)
                questions = Array(shuffledQuestions)
                let questionIDs = questions.map { $0.id }
                UserDefaults.standard.set(questionIDs, forKey: "questionIDs")
            }
        } catch {
            print("Error loading questions: \(error)")
        }
    }
    
    func startCountdown() {
        isGameScheduled = true
        isCountdownRunning = true
        countdownRemaining = AppConstants.countdownStartValue
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
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(AppConstants.timeDelayBetweenQuestions)) {
                    self.nextQuestion()
                }
            }
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        if currentQuestionIndex >= questions.count {
            isGameOver = true
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
        countdownRemaining = AppConstants.countdownStartValue
        questionTimeRemaining = ScheduleStorage.shared.getTotalSeconds()
        isGameOver = false
        totalScore = 0
        questions = []
        loadQuestions()
    }

    func saveGameState() {
        let data = try? JSONEncoder().encode(questions)
        UserDefaults.standard.set(data, forKey: "questionsData")
        UserDefaults.standard.set(currentQuestionIndex, forKey: "currentQuestionIndex")
        UserDefaults.standard.set(questionTimeRemaining, forKey: "questionTimeRemaining")
        UserDefaults.standard.set(totalScore, forKey: "totalScore")
    }

    func restoreGameState() {
        if let data = UserDefaults.standard.data(forKey: "questionsData"),
           let savedQuestions = try? JSONDecoder().decode([FlagQuestion].self, from: data) {
            questions = savedQuestions
        }
        currentQuestionIndex = UserDefaults.standard.integer(forKey: "currentQuestionIndex")
        questionTimeRemaining = UserDefaults.standard.integer(forKey: "questionTimeRemaining")
        totalScore = UserDefaults.standard.integer(forKey: "totalScore")
    }
}
