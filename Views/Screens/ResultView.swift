//
//  ResultView.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: QuestionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // 結果サマリー
                VStack(spacing: 16) {
                    Text("結果")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 30) {
                        ResultStatView(
                            title: "正解数",
                            value: "\(viewModel.correctAnswerCount)/\(viewModel.questions.count)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        
                        ResultStatView(
                            title: "正答率",
                            value: "\(Int(viewModel.correctAnswerPercentage))%",
                            icon: "percent",
                            color: .blue
                        )
                    }
                    
                    // 合格ライン
                    let isPassed = viewModel.correctAnswerPercentage >= 70
                    Text(isPassed ? "合格ライン突破！" : "もう少し頑張りましょう")
                        .font(.headline)
                        .foregroundColor(isPassed ? .green : .orange)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(isPassed ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
                        )
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // 問題リスト
                VStack(alignment: .leading, spacing: 16) {
                    Text("問題の復習")
                        .font(.headline)
                        .padding(.bottom, 4)
                    
                    ForEach(0..<viewModel.questions.count, id: \.self) { index in
                        let question = viewModel.questions[index]
                        let isCorrect = viewModel.userAnswers[index] == question.correctAnswerIndex
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("問題 \(index + 1)")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                HStack(spacing: 4) {
                                    Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                        .foregroundColor(isCorrect ? .green : .red)
                                    
                                    Text(isCorrect ? "正解" : "不正解")
                                        .font(.caption)
                                        .foregroundColor(isCorrect ? .green : .red)
                                }
                            }
                            
                            Text(question.question)
                                .font(.body)
                                .lineLimit(2)
                            
                            if let userAnswer = viewModel.userAnswers[index], userAnswer != question.correctAnswerIndex {
                                Text("あなたの回答: \(question.options[userAnswer])")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            
                            Text("正解: \(question.options[question.correctAnswerIndex])")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                
                // アクションボタン
                VStack(spacing: 16) {
                    Button(action: {
                        viewModel.restartQuiz()
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("もう一度挑戦する")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "house")
                            Text("ホームに戻る")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray5))
                        .foregroundColor(.primary)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle("結果", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle")
                .font(.title2)
                .foregroundColor(.gray)
        })
    }
}

struct ResultStatView: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(minWidth: 100)
    }
}

