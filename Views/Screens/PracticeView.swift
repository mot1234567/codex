//
//  PracticeView.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct PracticeView: View {
    @StateObject private var questionViewModel = QuestionViewModel()
    @StateObject private var userProgressViewModel = UserProgressViewModel()
    @State private var showingQuestionView = false
    @State private var selectedCategory: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // クイックスタートセクション
                    VStack(alignment: .leading) {
                        Text("クイックスタート")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Button(action: {
                            questionViewModel.loadQuestions(count: 10)
                            showingQuestionView = true
                        }) {
                            HStack {
                                Image(systemName: "play.fill")
                                Text("ランダム10問")
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                    
                    // カテゴリ別セクション
                    VStack(alignment: .leading) {
                        Text("カテゴリ別")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                            ForEach(Array(userProgressViewModel.categoryProgress.keys.sorted()), id: \.self) { categoryKey in
                                if let progress = userProgressViewModel.categoryProgress[categoryKey] {
                                    Button(action: {
                                        selectedCategory = categoryKey
                                        questionViewModel.loadQuestions(category: categoryKey, count: 20)
                                        showingQuestionView = true
                                    }) {
                                        CategoryCard(
                                            title: categoryKey,
                                            count: progress.totalQuestions,
                                            progress: progress
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("練習問題")
            .background(
                NavigationLink(
                    destination: QuestionView(viewModel: questionViewModel),
                    isActive: $showingQuestionView
                ) { EmptyView() }
            )
        }
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}
