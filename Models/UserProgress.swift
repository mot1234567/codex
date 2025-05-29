//
//  UserProgress.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation

/// ユーザー全体の進捗データを保持するモデル
struct UserProgress: Codable {
    /// ユーザー識別子
    var userId: String = UUID().uuidString
    /// 問題 ID ごとの回答結果
    var completedQuestions: [String: QuestionResult]
    /// 模擬試験の結果一覧
    var examResults: [ExamResult]
    /// 最終学習日
    var lastStudyDate: Date
    /// 連続学習日数
    var streakDays: Int

    init() {
        self.completedQuestions = [:]
        self.examResults = []
        self.lastStudyDate = Date()
        self.streakDays = 0
    }
}
