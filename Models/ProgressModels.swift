//
//  ProgressModels.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation

// 問題の回答結果
struct QuestionResult: Codable, Identifiable {
    var id: String { questionId }
    let questionId: String
    let date: Date
    let isCorrect: Bool
}

// 模擬試験の結果
struct ExamResult: Codable, Identifiable {
    var id: UUID = UUID()
    let date: Date
    let totalQuestions: Int
    let correctAnswers: Int
    let timeSpent: TimeInterval
    let examType: String
    
    var score: Double {
        return Double(correctAnswers) / Double(totalQuestions) * 100.0
    }
}

// カテゴリ別の進捗状況
struct CategoryProgress: Codable, Identifiable {
    var id: String { category }
    let category: String
    let totalQuestions: Int
    let answeredQuestions: Int
    let correctAnswers: Int
    
    var completionPercentage: Double {
        return Double(answeredQuestions) / Double(totalQuestions) * 100.0
    }
    
    var correctPercentage: Double {
        guard answeredQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(answeredQuestions) * 100.0
    }
}

// 全体の進捗状況
struct OverallProgress {
    let totalQuestions: Int
    let answeredQuestions: Int
    let correctAnswers: Int
    
    var completionPercentage: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(answeredQuestions) / Double(totalQuestions) * 100.0
    }
    
    var correctPercentage: Double {
        guard answeredQuestions > 0 else { return 0 }
        return Double(correctAnswers) / Double(answeredQuestions) * 100.0
    }
}
