//
//  ProgressBar.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI

struct ProgressBar: View {
    var value: Double
    var total: Double
    var color: Color = .blue
    var showText: Bool = true
    
    private var progress: Double {
        min(max(value / total, 0.0), 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if showText {
                HStack {
                    Text("\(Int(value))/\(Int(total))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 8)
                        .opacity(0.1)
                        .foregroundColor(color)
                        .cornerRadius(4)
                    
                    Rectangle()
                        .frame(width: geometry.size.width * progress, height: 8)
                        .foregroundColor(color)
                        .cornerRadius(4)
                }
            }
            .frame(height: 8)
        }
    }
}
