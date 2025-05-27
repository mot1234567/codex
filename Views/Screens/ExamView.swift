//
//  ExamView.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct ExamView: View {
    @StateObject private var questionViewModel = QuestionViewModel()
    @State private var showingQuestionView = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // 模擬試験の説明
                    VStack(alignment: .leading, spacing: 8) {
                        Text("模擬試験モード")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("実際の試験環境に近い形式で問題に挑戦できます。制限時間内にすべての問題に回答してください。")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // 模擬試験オプション
                    VStack(spacing: 16) {
                        ExamOptionCard(
                            title: "クラウドプラクティショナー模擬試験 1",
                            questionCount: 25,
                            timeLimit: 45,
                            difficulty: "標準",
                            onStart: {
                                questionViewModel.loadQuestions(count: 25)
                                showingQuestionView = true
                            }
                        )

                        ExamOptionCard(
                            title: "クラウドプラクティショナー模擬試験 2",
                            questionCount: 25,
                            timeLimit: 45,
                            difficulty: "標準",
                            onStart: {
                                questionViewModel.loadQuestions(count: 25)
                                showingQuestionView = true
                            }
                        )

                        ExamOptionCard(
                            title: "クラウドプラクティショナー模擬試験 3",
                            questionCount: 25,
                            timeLimit: 45,
                            difficulty: "難しい",
                            onStart: {
                                questionViewModel.loadQuestions(count: 25)
                                showingQuestionView = true
                            }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("模擬試験")
            .background(
                NavigationLink(
                    destination: QuestionView(viewModel: questionViewModel),
                    isActive: $showingQuestionView
                ) { EmptyView() }
            )
        }
    }
}

struct ExamOptionCard: View {
    var title: String
    var questionCount: Int
    var timeLimit: Int
    var difficulty: String
    var onStart: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            HStack {
                Label("\(questionCount)問", systemImage: "list.bullet")
                    .font(.subheadline)
                
                Spacer()
                
                Label("\(timeLimit)分", systemImage: "clock")
                    .font(.subheadline)
            }
            
            HStack {
                Label(difficulty, systemImage: "speedometer")
                    .font(.subheadline)
                
                Spacer()
                
                Button(action: {
                    onStart()
                }) {
                    Text("開始")
                        .fontWeight(.medium)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct ExamView_Previews: PreviewProvider {
    static var previews: some View {
        ExamView()
    }
}
