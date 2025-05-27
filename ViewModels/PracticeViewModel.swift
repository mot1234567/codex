//
//  PracticeViewModel.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation
import Combine

class PracticeViewModel: ObservableObject {
    @Published var categories: [String: Int] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var dataService: DataService
    var questionViewModel: QuestionViewModel
    
    init(dataService: DataService = DataService(), questionViewModel: QuestionViewModel = QuestionViewModel()) {
        self.dataService = dataService
        self.questionViewModel = questionViewModel
    }
    
    func loadCategories() {
        isLoading = true
        
        dataService.fetchQuestions() { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(let questions):
                    // カテゴリー別に問題数をカウント
                    var categoryCounts: [String: Int] = [:]
                    
                    for question in questions {
                        if let count = categoryCounts[question.category] {
                            categoryCounts[question.category] = count + 1
                        } else {
                            categoryCounts[question.category] = 1
                        }
                    }
                    
                    self.categories = categoryCounts
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func startPractice(category: String? = nil, questionCount: Int? = nil) {
        questionViewModel.loadQuestions(category: category, count: questionCount)
    }
    
    func completeSession() {
        // 練習セッション完了時の処理
        // 例: 統計の更新など
    }
}
