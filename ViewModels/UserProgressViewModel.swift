//
//  UserProgressViewModel.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation

class UserProgressViewModel: ObservableObject {
    @Published var questionResults: [String: [QuestionResult]] = [:]
    @Published var examResults: [ExamResult] = []
    @Published var categoryProgress: [String: CategoryProgress] = [:]
    
    private let userDefaultsManager: UserDefaultsManager
    
    init(userDefaultsManager: UserDefaultsManager = UserDefaultsManager()) {
        self.userDefaultsManager = userDefaultsManager
        loadData()
    }
    
    // 問題の結果を保存
    func saveQuestionResult(questionId: String, isCorrect: Bool) {
        let result = QuestionResult(
            questionId: questionId,
            date: Date(),
            isCorrect: isCorrect
        )
        
        // 既存の結果を取得
        var results = questionResults[questionId] ?? []
        results.append(result)
        questionResults[questionId] = results
        
        // UserDefaultsに保存
        userDefaultsManager.saveQuestionResults(questionResults)
        
        // カテゴリ別進捗を更新
        updateCategoryProgress()
    }
    
    // 模擬試験の結果を保存
    func saveExamResult(_ result: ExamResult) {
        examResults.append(result)
        userDefaultsManager.saveExamResults(examResults)
    }
    
    // カテゴリ別の進捗状況を更新
    private func updateCategoryProgress() {
        // DataServiceからすべての問題を取得
        let dataService = DataService()
        dataService.fetchQuestions { [weak self] result in
            guard let self = self, case .success(let questions) = result else { return }
            
            // カテゴリごとにグループ化
            let questionsByCategory = Dictionary(grouping: questions) { $0.category }
            
            // 各カテゴリの進捗を計算
            for (category, categoryQuestions) in questionsByCategory {
                var totalAnswered = 0
                var totalCorrect = 0
                
                for question in categoryQuestions {
                    if let results = self.questionResults[question.id], !results.isEmpty {
                        totalAnswered += 1
                        
                        // 最新の回答が正解かどうか
                        if let latestResult = results.last, latestResult.isCorrect {
                            totalCorrect += 1
                        }
                    }
                }
                
                let progress = CategoryProgress(
                    category: category,
                    totalQuestions: categoryQuestions.count,
                    answeredQuestions: totalAnswered,
                    correctAnswers: totalCorrect
                )
                
                self.categoryProgress[category] = progress
            }
            
            // 進捗情報を保存
            self.userDefaultsManager.saveCategoryProgress(self.categoryProgress)
        }
    }
    
    // データの読み込み
    private func loadData() {
        questionResults = userDefaultsManager.loadQuestionResults()
        examResults = userDefaultsManager.loadExamResults()
        categoryProgress = userDefaultsManager.loadCategoryProgress()
    }
    
    // 特定のカテゴリの進捗を取得
    func getProgressForCategory(_ category: String) -> CategoryProgress? {
        return categoryProgress[category]
    }
    
    // 全体の進捗状況を取得
    func getOverallProgress() -> OverallProgress {
        let totalQuestions = categoryProgress.values.reduce(0) { $0 + $1.totalQuestions }
        let answeredQuestions = categoryProgress.values.reduce(0) { $0 + $1.answeredQuestions }
        let correctAnswers = categoryProgress.values.reduce(0) { $0 + $1.correctAnswers }
        
        return OverallProgress(
            totalQuestions: totalQuestions,
            answeredQuestions: answeredQuestions,
            correctAnswers: correctAnswers
        )
    }
    
    // 最近の学習履歴を取得
    func getRecentActivity(limit: Int = 5) -> [QuestionResult] {
        // すべての問題結果を日付順にソート
        let allResults = questionResults.values.flatMap { $0 }
        return allResults.sorted(by: { $0.date > $1.date }).prefix(limit).map { $0 }
    }
    
    // 進捗データをリセット
    func resetProgress() {
        questionResults = [:]
        examResults = []
        categoryProgress = [:]
        
        userDefaultsManager.saveQuestionResults(questionResults)
        userDefaultsManager.saveExamResults(examResults)
        userDefaultsManager.saveCategoryProgress(categoryProgress)
    }
}
