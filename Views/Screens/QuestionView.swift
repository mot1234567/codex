//
//  QuestionView.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct QuestionView: View {
    @ObservedObject var viewModel: QuestionViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showingResult = false
    
    var body: some View {
        VStack {
            // 進捗バー
            if let currentQuestion = viewModel.currentQuestion {
                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("問題 \(viewModel.currentQuestionIndex + 1)/\(viewModel.questions.count)")
                            .font(.headline)
                        
                        Spacer()
                        
                        if viewModel.isExamMode && viewModel.isTimerActive {
                            Text("残り時間: \(viewModel.formatTime(viewModel.timeRemaining))")
                                .font(.headline)
                                .foregroundColor(viewModel.timeRemaining < 300 ? .red : .primary) // 5分未満で赤色表示
                                .padding(.horizontal)
                        }
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "xmark.circle")
                                .font(.title2)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    ProgressBar(
                        value: Double(viewModel.currentQuestionIndex + 1),
                        total: Double(viewModel.questions.count)
                    )
                    .frame(height: 10)
                    
                    // 問題文
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text(currentQuestion.question)
                                .font(.title3)
                                .fontWeight(.medium)
                                .padding(.bottom, 10)
                            
                            // 選択肢
                            VStack(spacing: 12) {
                                ForEach(0..<currentQuestion.options.count, id: \.self) { index in
                                    AnswerButton(
                                        text: currentQuestion.options[index],
                                        isSelected: viewModel.selectedAnswerIndex == index,
                                        isCorrect: viewModel.showAnswer ? index == currentQuestion.correctAnswerIndex : nil,
                                        action: {
                                            if !viewModel.showAnswer {
                                                viewModel.selectAnswer(at: index)
                                            }
                                        }
                                    )
                                }
                            }
                            
                            // 解説（回答後に表示）
                            if viewModel.showAnswer {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("解説")
                                        .font(.headline)
                                        .padding(.top, 20)
                                    
                                    Text(currentQuestion.explanation)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                                .padding(.top, 10)
                            }
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    // ナビゲーションボタン
                    HStack {
                        Button(action: {
                            viewModel.previousQuestion()
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("前の問題")
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(viewModel.currentQuestionIndex > 0 ? Color.blue : Color.gray)
                            .cornerRadius(10)
                        }
                        .disabled(viewModel.currentQuestionIndex <= 0)
                        
                        Spacer()
                        
                        Button(action: {
                            if viewModel.showAnswer {
                                if viewModel.currentQuestionIndex < viewModel.questions.count - 1 {
                                    viewModel.nextQuestion()
                                } else {
                                    // 最後の問題の場合は結果画面へ
                                    viewModel.completeQuiz()
                                    showingResult = true
                                }
                            } else {
                                viewModel.selectAnswer(at: viewModel.selectedAnswerIndex ?? 0)
                            }
                        }) {
                            HStack {
                                Text(viewModel.showAnswer ?
                                     (viewModel.currentQuestionIndex < viewModel.questions.count - 1 ? "次の問題" : "終了") :
                                     "回答する")
                                if !viewModel.showAnswer {
                                    Image(systemName: "checkmark")
                                } else if viewModel.currentQuestionIndex < viewModel.questions.count - 1 {
                                    Image(systemName: "chevron.right")
                                }
                            }
                            .padding()
                            .foregroundColor(.white)
                            .background(viewModel.selectedAnswerIndex != nil || viewModel.showAnswer ? Color.blue : Color.gray)
                            .cornerRadius(10)
                        }
                        .disabled(viewModel.selectedAnswerIndex == nil && !viewModel.showAnswer)
                    }
                    .padding(.bottom)
                }
                .padding()
            } else {
                VStack {
                    ProgressView()
                    Text("問題を読み込み中...")
                        .padding()
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            if viewModel.questions.isEmpty {
                viewModel.loadQuestions()
            }
        }
        .background(
            NavigationLink(
                destination: ResultView(viewModel: viewModel),
                isActive: $showingResult
            ) { EmptyView() }
        )
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(viewModel: QuestionViewModel())
    }
}
