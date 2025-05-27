//
//  UserProgress.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation

/// Stores overall progress data for a user.
///
/// Uses models defined in `ProgressModels.swift` to avoid duplicate type
/// definitions across the project.
struct UserProgress: Codable {
    var userId: String = UUID().uuidString
    /// Latest results for each question
    var completedQuestions: [String: QuestionResult]
    /// History of exam attempts
    var examResults: [ExamResult]
    /// Date of the most recent study session
    var lastStudyDate: Date
    /// Consecutive days of study
    var streakDays: Int

    init() {
        self.completedQuestions = [:]
        self.examResults = []
        self.lastStudyDate = Date()
        self.streakDays = 0
    }
}
