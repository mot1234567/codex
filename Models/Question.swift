
//
//  Question.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//
import Foundation

// 問題データモデル
struct Question: Codable, Identifiable {
    let id: String
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
    let category: String
    let difficulty: String
}

// ユーザーの回答データ
struct QuestionResponse: Codable {
    let questionId: String
    let selectedAnswerIndex: Int
    let isCorrect: Bool
    let timestamp: Date
}

// JSONデータの構造
struct QuestionsData: Codable {
    let questions: [Question]
}
