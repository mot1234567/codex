//
//  QuestionViewModel.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation

class QuestionViewModel: ObservableObject {
    @Published var currentQuestion: Question?
    @Published var selectedAnswerIndex: Int?
    @Published var showAnswer: Bool = false
    @Published var isCorrect: Bool = false
    @Published var currentQuestionIndex: Int = 0
    @Published var questions: [Question] = []
    @Published var selectedAnswers: [Int?] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var quizCompleted: Bool = false
    
    private var dataService: DataService
    private var userProgressViewModel: UserProgressViewModel
    
    init(dataService: DataService = DataService(), userProgressViewModel: UserProgressViewModel = UserProgressViewModel()) {
        self.dataService = dataService
        self.userProgressViewModel = userProgressViewModel
    }
    
    func loadQuestions(category: String? = nil, count: Int? = nil) {
        isLoading = true
        
        dataService.fetchQuestions(category: category) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(var loadedQuestions):
                    // カテゴリーでフィルタリング
                    if let category = category, category != "all" {
                        loadedQuestions = loadedQuestions.filter { $0.category == category }
                    }
                    
                    // シャッフルして指定数を取得
                    loadedQuestions.shuffle()
                    if let count = count, count < loadedQuestions.count {
                        loadedQuestions = Array(loadedQuestions.prefix(count))
                    }
                    
                    self.questions = loadedQuestions
                    self.selectedAnswers = Array(repeating: nil, count: loadedQuestions.count)
                    
                    if !loadedQuestions.isEmpty {
                        self.currentQuestion = loadedQuestions[0]
                        self.currentQuestionIndex = 0
                        self.resetQuestionState()
                    }
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func selectAnswer(at index: Int) {
        selectedAnswerIndex = index
        showAnswer = true
        isCorrect = index == currentQuestion?.correctAnswerIndex
        
        // 選択した回答を保存
        if currentQuestionIndex < selectedAnswers.count {
            selectedAnswers[currentQuestionIndex] = index
        }
        
        // 進捗を保存
        if let question = currentQuestion {
            userProgressViewModel.saveQuestionResult(
                questionId: question.id,
                isCorrect: isCorrect
            )
        }
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            currentQuestion = questions[currentQuestionIndex]
            
            // 既に回答済みかチェック
            if let savedAnswer = selectedAnswers[currentQuestionIndex] {
                selectedAnswerIndex = savedAnswer
                showAnswer = true
                isCorrect = savedAnswer == currentQuestion?.correctAnswerIndex
            } else {
                resetQuestionState()
            }
        } else {
            // 全問題終了
            quizCompleted = true
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
            currentQuestion = questions[currentQuestionIndex]
            
            // 既に回答済みかチェック
            if let savedAnswer = selectedAnswers[currentQuestionIndex] {
                selectedAnswerIndex = savedAnswer
                showAnswer = true
                isCorrect = savedAnswer == currentQuestion?.correctAnswerIndex
            } else {
                resetQuestionState()
            }
        }
    }
    
    private func resetQuestionState() {
        selectedAnswerIndex = nil
        showAnswer = false
        isCorrect = false
    }
    
    // 結果画面用の拡張
    var correctAnswerCount: Int {
        var count = 0
        for (index, question) in questions.enumerated() {
            if index < selectedAnswers.count,
               let selectedAnswer = selectedAnswers[index],
               selectedAnswer == question.correctAnswerIndex {
                count += 1
            }
        }
        return count
    }
    
    var correctAnswerPercentage: Double {
        guard !questions.isEmpty else { return 0 }
        return Double(correctAnswerCount) / Double(questions.count) * 100.0
    }
    
    var userAnswers: [Int] {
        return selectedAnswers.compactMap { $0 }
    }
    
    func restartQuiz() {
        currentQuestionIndex = 0
        if let firstQuestion = questions.first {
            currentQuestion = firstQuestion
        }
        selectedAnswers = Array(repeating: nil, count: questions.count)
        selectedAnswerIndex = nil
        showAnswer = false
        isCorrect = false
        quizCompleted = false
    }
    
    func completeQuiz() {
        // クイズ完了時の処理
        quizCompleted = true
        
        // 結果をExamResultとして保存（模擬試験モードの場合）
        let examResult = ExamResult(
            date: Date(),
            totalQuestions: questions.count,
            correctAnswers: correctAnswerCount,
            timeSpent: 0, // 時間計測が必要な場合は別途実装
            examType: "練習問題"
        )
        
        userProgressViewModel.saveExamResult(examResult)
    }
}
