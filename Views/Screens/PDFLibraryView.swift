//
//  PDFLibraryView.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct PDFLibraryView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 教材セクション
                    VStack(alignment: .leading) {
                        Text("AWS認定学習教材")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            PDFDocumentCard(
                                title: "クラウドプラクティショナー公式ガイド",
                                description: "AWS認定クラウドプラクティショナーの公式試験ガイド",
                                pageCount: 54,
                                icon: "doc.text"
                            )
                            
                            PDFDocumentCard(
                                title: "AWSサービス概要",
                                description: "主要なAWSサービスの概要と使用例",
                                pageCount: 32,
                                icon: "server.rack"
                            )
                            
                            PDFDocumentCard(
                                title: "セキュリティのベストプラクティス",
                                description: "AWSにおけるセキュリティ対策の基本",
                                pageCount: 28,
                                icon: "lock.shield"
                            )
                            
                            PDFDocumentCard(
                                title: "料金モデルと見積もり",
                                description: "AWSの料金体系と見積もり方法",
                                pageCount: 18,
                                icon: "dollarsign.circle"
                            )
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("学習教材")
        }
    }
}

struct PDFDocumentCard: View {
    var title: String
    var description: String
    var pageCount: Int
    var icon: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(.blue)
                .frame(width: 60, height: 60)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(pageCount)ページ")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PDFLibraryView_Previews: PreviewProvider {
    static var previews: some View {
        PDFLibraryView()
    }
}
