//
//  Category.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation
import SwiftUI

struct Category: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var iconName: String
    var color: String
    
    // JSONでは色を文字列として保存し、UIで使用時に変換
    var colorValue: Color {
        switch color {
        case "blue": return .blue
        case "green": return .green
        case "orange": return .orange
        case "red": return .red
        case "purple": return .purple
        default: return .blue
        }
    }
}
