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
    var iconName: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text("\(count)問")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(height: 100)
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
