//
//  DataService.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import Foundation
import ProgressModels

class DataService {
    enum DataError: Error {
        case fileNotFound
        case decodingError
        case networkError
        case unknown
    }
    
    func fetchQuestions(category: String? = nil, completion: @escaping (Result<[Question], DataError>) -> Void) {
        // ファイルからJSONデータを読み込む
        guard let fileURL = Bundle.main.url(forResource: "questions", withExtension: "json") else {
            completion(.failure(.fileNotFound))
            return
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let questionsData = try decoder.decode(QuestionsData.self, from: data)
            
            var questions = questionsData.questions
            
            // カテゴリでフィルタリング（必要な場合）
            if let category = category, category != "all" {
                questions = questions.filter { $0.category == category }
            }
            
            completion(.success(questions))
        } catch {
            print("Error decoding questions: \(error)")
            completion(.failure(.decodingError))
        }
    }
    
    // PDFファイルの一覧を取得
    func fetchPDFDocuments() -> [PDFDocument] {
        // PDFServiceに移動したため、そちらを使用
        let pdfService = PDFService()
        return pdfService.fetchPDFDocuments()
    }
}

// JSONデータの構造
struct QuestionsData: Codable {
    let questions: [Question]
}

// 問題データモデル
struct Question: Codable, Identifiable {
    let id: String
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
    let explanation: String
    let category: String
    let difficulty: String
}
