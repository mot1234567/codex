//
//  ExamViewModel.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation

class ExamViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var selectedAnswers: [Int?]
    @Published var timeRemaining: TimeInterval
    @Published var isExamActive: Bool = false
    @Published var isExamCompleted: Bool = false
    @Published var examResult: ExamResult?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var timer: Timer?
    private var startTime: Date?
    private var dataService: DataService
    private var userProgressViewModel: UserProgressViewModel
    private var examType: String
    private var totalTime: TimeInterval
    
    init(dataService: DataService = DataService(), userProgressViewModel: UserProgressViewModel = UserProgressViewModel(), examType: String = "標準", questionCount: Int = 25, timeInMinutes: Int = 45) {
        self.dataService = dataService
        self.userProgressViewModel = userProgressViewModel
        self.examType = examType
        self.totalTime = TimeInterval(timeInMinutes * 60)
        self.timeRemaining = self.totalTime
        self.selectedAnswers = Array(repeating: nil, count: questionCount)
    }
    
    func startExam() {
        isLoading = true
        
        dataService.fetchQuestions() { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                switch result {
                case .success(var loadedQuestions):
                    // 問題をシャッフルして指定数を取得
                    loadedQuestions.shuffle()
                    let examQuestions = Array(loadedQuestions.prefix(self.selectedAnswers.count))
                    
                    self.questions = examQuestions
                    self.selectedAnswers = Array(repeating: nil, count: examQuestions.count)
                    self.currentQuestionIndex = 0
                    self.isExamActive = true
                    self.isExamCompleted = false
                    self.examResult = nil
                    self.startTime = Date()
                    self.startTimer()
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func selectAnswer(at index: Int) {
        selectedAnswers[currentQuestionIndex] = index
    }
    
    func nextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        }
    }
    
    func previousQuestion() {
        if currentQuestionIndex > 0 {
            currentQuestionIndex -= 1
        }
    }
    
    func submitExam() {
        stopTimer()
        isExamActive = false
        isExamCompleted = true
        
        // 結果を計算
        var correctCount = 0
        for (index, question) in questions.enumerated() {
            if let selectedAnswer = selectedAnswers[index], selectedAnswer == question.correctAnswerIndex {
                correctCount += 1
            }
        }
        
        let timeSpent = totalTime - timeRemaining
        
        // 結果を保存
        let result = ExamResult(
            date: Date(),
            totalQuestions: questions.count,
            correctAnswers: correctCount,
            timeSpent: timeSpent,
            examType: examType
        )
        
        examResult = result
        userProgressViewModel.saveExamResult(result)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.submitExam()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    deinit {
        stopTimer()
    }
}
