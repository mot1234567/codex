//
//  UserProgress.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation

struct UserProgress: Codable {
    var userId: String = UUID().uuidString
    var completedQuestions: [String: QuestionResult] // 問題ID: 結果
    var examResults: [ExamResult]
    var lastStudyDate: Date
    var streakDays: Int
    
    init() {
        self.completedQuestions = [:]
        self.examResults = []
        self.lastStudyDate = Date()
        self.streakDays = 0
    }
}

struct QuestionResult: Codable {
    var questionId: String
    var isCorrect: Bool
    var attemptCount: Int
    var lastAttemptDate: Date
    
    init(questionId: String, isCorrect: Bool) {
        self.questionId = questionId
        self.isCorrect = isCorrect
        self.attemptCount = 1
        self.lastAttemptDate = Date()
    }
}

struct ExamResult: Codable, Identifiable {
    var id: String = UUID().uuidString
    var date: Date
    var totalQuestions: Int
    var correctAnswers: Int
    var timeSpent: TimeInterval
    var examType: String
    
    var scorePercentage: Double {
        return Double(correctAnswers) / Double(totalQuestions) * 100.0
    }
}
