//
//  CategoryCard.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct CategoryCard: View {
    var title: String
    var count: Int
    var iconName: String = "book.fill"
    var color: Color = .blue
    var progress: CategoryProgress? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(count)問")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            if let progress = progress {
                VStack(spacing: 4) {
                    HStack {
                        Text("進捗")
                            .font(.caption)
                        Spacer()
                        Text("\(Int(progress.completionPercentage))%")
                            .font(.caption)
                    }
                    
                    ProgressView(value: progress.completionPercentage / 100.0)
                        .progressViewStyle(LinearProgressViewStyle())
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .frame(minHeight: 100)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}

struct CategoryCard_Previews: PreviewProvider {
    static var previews: some View {
        CategoryCard(
            title: "クラウドの概念",
            count: 125,
            iconName: "cloud",
            color: .blue
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
