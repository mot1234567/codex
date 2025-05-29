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
