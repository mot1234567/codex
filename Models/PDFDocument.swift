//
//  PDFDocument.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation

// PDFService.swiftで使用するPDFドキュメントモデル
struct PDFDocument: Identifiable {
    let id: String
    let title: String
    let fileName: String
    
    // 追加のメタデータ
    var author: String?
    var description: String?
    var pageCount: Int?
    var lastViewedDate: Date?
}
