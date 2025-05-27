//
//  PracticeView.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct PracticeView: View {
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
                            // ランダム10問の練習開始
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
                            CategoryCard(category: "クラウドの概念", count: 75)
                            CategoryCard(category: "セキュリティ", count: 85)
                            CategoryCard(category: "テクノロジー", count: 120)
                            CategoryCard(category: "請求と料金", count: 65)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("練習問題")
        }
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}
