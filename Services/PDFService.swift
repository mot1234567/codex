//
//  PDFService.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation
import PDFKit

class PDFService {
    func loadPDF(named fileName: String) -> PDFKit.PDFDocument? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "pdf") else {
            print("PDF file not found: \(fileName)")
            return nil
        }
        
        guard let document = PDFKit.PDFDocument(url: url) else {
            print("Could not create PDF document from: \(fileName)")
            return nil
        }
        
        return document
    }
    
    func saveLastViewedPage(for documentId: String, page: Int) {
        UserDefaults.standard.set(page, forKey: "pdf_lastpage_\(documentId)")
    }
    
    func getLastViewedPage(for documentId: String) -> Int {
        return UserDefaults.standard.integer(forKey: "pdf_lastpage_\(documentId)")
    }
    
    // PDFファイルの一覧を取得
    func fetchPDFDocuments() -> [PDFDocument] {
        // 実際のアプリではBundleからPDFファイルを検索する
        // ここではサンプルデータを返す
        return [
            PDFDocument(id: "aws-cp-guide", title: "AWS クラウドプラクティショナー学習ガイド", fileName: "aws-cp-guide"),
            PDFDocument(id: "aws-saa-guide", title: "AWS ソリューションアーキテクトアソシエイト学習ガイド", fileName: "aws-saa-guide")
        ]
    }
}
