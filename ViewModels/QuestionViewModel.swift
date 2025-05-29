//
//  QuestionViewModel.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation
import Combine

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
    @Published var timeRemaining: TimeInterval = 0
    @Published var isTimerActive: Bool = false
    @Published var isExamMode: Bool = false
    
    private var timer: Timer?
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
    
    
    func completeQuiz() {
        stopTimer()
        
        // クイズ完了時の処理
        quizCompleted = true
        
        // 結果をExamResultとして保存（模擬試験モードの場合）
        let examResult = ExamResult(
            date: Date(),
            totalQuestions: questions.count,
            correctAnswers: correctAnswerCount,
            timeSpent: isExamMode ? (45 * 60 - timeRemaining) : 0, // 45分からの経過時間
            examType: isExamMode ? "模擬試験" : "練習問題"
        )
        
        userProgressViewModel.saveExamResult(examResult)
    }
    
    func startTimer(duration: TimeInterval) {
        timeRemaining = duration
        isTimerActive = true
        isExamMode = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.completeQuiz()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isTimerActive = false
    }
    
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    deinit {
        stopTimer()
    }
}
