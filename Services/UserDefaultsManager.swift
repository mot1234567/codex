//
//  UserDefaultsManager.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation

class UserDefaultsManager {
    private let questionResultsKey = "aws_quiz_question_results"
    private let examResultsKey = "aws_quiz_exam_results"
    private let categoryProgressKey = "aws_quiz_category_progress"
    private let lastViewedPDFPageKey = "aws_quiz_last_viewed_pdf_page"
    
    // 問題の回答結果を保存
    func saveQuestionResults(_ results: [String: [QuestionResult]]) {
        if let encoded = try? JSONEncoder().encode(results) {
            UserDefaults.standard.set(encoded, forKey: questionResultsKey)
        }
    }
    
    // 問題の回答結果を読み込み
    func loadQuestionResults() -> [String: [QuestionResult]] {
        if let data = UserDefaults.standard.data(forKey: questionResultsKey),
           let decoded = try? JSONDecoder().decode([String: [QuestionResult]].self, from: data) {
            return decoded
        }
        return [:]
    }
    
    // 模擬試験の結果を保存
    func saveExamResults(_ results: [ExamResult]) {
        if let encoded = try? JSONEncoder().encode(results) {
            UserDefaults.standard.set(encoded, forKey: examResultsKey)
        }
    }
    
    // 模擬試験の結果を読み込み
    func loadExamResults() -> [ExamResult] {
        if let data = UserDefaults.standard.data(forKey: examResultsKey),
           let decoded = try? JSONDecoder().decode([ExamResult].self, from: data) {
            return decoded
        }
        return []
    }
    
    // カテゴリ別進捗を保存
    func saveCategoryProgress(_ progress: [String: CategoryProgress]) {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: categoryProgressKey)
        }
    }
    
    // カテゴリ別進捗を読み込み
    func loadCategoryProgress() -> [String: CategoryProgress] {
        if let data = UserDefaults.standard.data(forKey: categoryProgressKey),
           let decoded = try? JSONDecoder().decode([String: CategoryProgress].self, from: data) {
            return decoded
        }
        return [:]
    }
    
    // PDFの最後に表示していたページを保存
    func saveLastViewedPDFPage(for documentId: String, page: Int) {
        UserDefaults.standard.set(page, forKey: "\(lastViewedPDFPageKey)_\(documentId)")
    }
    
    // PDFの最後に表示していたページを読み込み
    func loadLastViewedPDFPage(for documentId: String) -> Int {
        return UserDefaults.standard.integer(forKey: "\(lastViewedPDFPageKey)_\(documentId)")
    }
    
    // すべてのデータをリセット
    func resetAllData() {
        UserDefaults.standard.removeObject(forKey: questionResultsKey)
        UserDefaults.standard.removeObject(forKey: examResultsKey)
        UserDefaults.standard.removeObject(forKey: categoryProgressKey)
        
        // PDFの最後に表示していたページ情報は残す
    }
    
    private let userProgressKey = "aws_quiz_user_progress"
    
    func saveUserProgress(_ progress: UserProgress) {
        if let encoded = try? JSONEncoder().encode(progress) {
            UserDefaults.standard.set(encoded, forKey: userProgressKey)
        }
    }
    
    func loadUserProgress() -> UserProgress? {
        if let data = UserDefaults.standard.data(forKey: userProgressKey),
           let decoded = try? JSONDecoder().decode(UserProgress.self, from: data) {
            return decoded
        }
        return nil
    }
}
