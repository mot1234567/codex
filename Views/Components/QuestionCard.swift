//
//  QuestionCard.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct QuestionCard: View {
    var question: Question
    var selectedAnswerIndex: Int?
    var showAnswer: Bool
    var onAnswerSelected: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 問題文
            Text(question.question)
                .font(.headline)
                .padding(.bottom, 8)
            
            // 選択肢
            VStack(spacing: 12) {
                ForEach(0..<question.options.count, id: \.self) { index in
                    AnswerButton(
                        text: question.options[index],
                        isSelected: selectedAnswerIndex == index,
                        isCorrect: showAnswer ? index == question.correctAnswerIndex : nil,
                        action: {
                            if !showAnswer {
                                onAnswerSelected(index)
                            }
                        }
                    )
                }
            }
            
            // 解説（回答後に表示）
            if showAnswer {
                VStack(alignment: .leading, spacing: 8) {
                    Text("解説")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text(question.explanation)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
