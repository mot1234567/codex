//
//  PDFThumbnail.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI
import PDFKit

struct PDFThumbnail: View {
    var document: PDFDocument
    var width: CGFloat = 120
    var height: CGFloat = 160
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: width, height: height)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                
                Image(systemName: document.iconName)
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
            }
            
            Text(document.title)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: width)
        }
    }
}
