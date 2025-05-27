import SwiftUI

struct HomeView: View {
    @ObservedObject var userProgressViewModel = UserProgressViewModel()
    @State private var showingQuestionView = false
    @State private var showingExamView = false
    @State private var showingPDFView = false
    @State private var selectedPDF: PDFDocument?
    @State private var selectedCategory: String?
    
    private let dataService = DataService()
    private let pdfService = PDFService()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // ヘッダーセクション
                    VStack(alignment: .leading, spacing: 8) {
                        Text("AWS認定問題集")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("クラウドプラクティショナー & ソリューションアーキテクト")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                    // 進捗サマリー
                    let overallProgress = userProgressViewModel.getOverallProgress()
                    VStack(spacing: 16) {
                        HStack {
                            Text("学習進捗")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(Int(overallProgress.completionPercentage))%完了")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        ProgressBar(
                            value: Double(overallProgress.answeredQuestions),
                            total: Double(overallProgress.totalQuestions),
                            color: .blue
                        )
                        
                        HStack {
                            ProgressStatView(
                                title: "回答済み",
                                value: "\(overallProgress.answeredQuestions)/\(overallProgress.totalQuestions)",
                                icon: "checkmark.circle.fill",
                                color: .blue
                            )
                            
                            Divider()
                            
                            ProgressStatView(
                                title: "正答率",
                                value: "\(Int(overallProgress.correctPercentage))%",
                                icon: "chart.bar.fill",
                                color: .green
                            )
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    // 学習モード
                    VStack(alignment: .leading, spacing: 16) {
                        Text("学習モード")
                            .font(.headline)
                        
                        HStack(spacing: 16) {
                            NavigationLink(destination:
                                QuestionView(viewModel: QuestionViewModel())
                                    .onAppear {
                                        // 練習問題モード（10問）
                                        let vm = QuestionViewModel()
                                        vm.loadQuestions(count: 10)
                                    },
                                isActive: $showingQuestionView
                            ) {
                                StudyModeCard(
                                    title: "練習問題",
                                    description: "10問の小テスト",
                                    icon: "book.fill",
                                    color: .blue
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            NavigationLink(destination:
                                QuestionView(viewModel: QuestionViewModel())
                                    .onAppear {
                                        // 模擬試験モード（25問）
                                        let vm = QuestionViewModel()
                                        vm.loadQuestions(count: 25)
                                    },
                                isActive: $showingExamView
                            ) {
                                StudyModeCard(
                                    title: "模擬試験",
                                    description: "25問の本番形式",
                                    icon: "timer",
                                    color: .orange
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    
                    // カテゴリ別学習
                    VStack(alignment: .leading, spacing: 16) {
                        Text("カテゴリ別学習")
                            .font(.headline)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                            ForEach(["クラウドの概念", "セキュリティ", "テクノロジー", "請求と料金"], id: \.self) { category in
                                let progress = userProgressViewModel.getProgressForCategory(category)
                                
                                Button(action: {
                                    selectedCategory = category
                                    showingQuestionView = true
                                }) {
                                    CategoryCard(
                                        title: category,
                                        count: progress?.totalQuestions ?? 0,
                                        iconName: iconForCategory(category),
                                        color: colorForCategory(category)
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding()
                    
                    // 学習資料
                    VStack(alignment: .leading, spacing: 16) {
                        Text("学習資料")
                            .font(.headline)
                        
                        ForEach(dataService.fetchPDFDocuments()) { document in
                            Button(action: {
                                selectedPDF = document
                                showingPDFView = true
                            }) {
                                HStack {
                                    Image(systemName: "doc.text.fill")
                                        .font(.title2)
                                        .foregroundColor(.blue)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(document.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Text("最終閲覧: \(formattedLastViewed(for: document.id))")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationBarHidden(true)
            .background(
                NavigationLink(
                    destination: Group {
                        if let pdf = selectedPDF, let document = pdfService.loadPDF(named: pdf.fileName) {
                            PDFViewerView(
                                viewModel: PDFViewModel(
                                    document: document,
                                    documentId: pdf.id
                                )
                            )
                        } else {
                            Text("PDFを読み込めませんでした")
                        }
                    },
                    isActive: $showingPDFView
                ) {
                    EmptyView()
                }
            )
            .background(
                NavigationLink(
                    destination: QuestionView(
                        viewModel: QuestionViewModel()
                    ).onAppear {
                        let vm = QuestionViewModel()
                        vm.loadQuestions(category: selectedCategory, count: 10)
                    },
                    isActive: $showingQuestionView
                ) {
                    EmptyView()
                }
            )
        }
    }
    
    // カテゴリに応じたアイコン名を返す
    private func iconForCategory(_ category: String) -> String {
        switch category {
        case "クラウドの概念":
            return "cloud"
        case "セキュリティ":
            return "lock.shield"
        case "テクノロジー":
            return "server.rack"
        case "請求と料金":
            return "dollarsign.circle"
        default:
            return "questionmark"
        }
    }
    
    // カテゴリに応じた色を返す
    private func colorForCategory(_ category: String) -> Color {
        switch category {
        case "クラウドの概念":
            return .blue
        case "セキュリティ":
            return .green
        case "テクノロジー":
            return .orange
        case "請求と料金":
            return .red
        default:
            return .gray
        }
    }
    
    // 最終閲覧日時のフォーマット
    private func formattedLastViewed(for documentId: String) -> String {
        let page = pdfService.getLastViewedPage(for: documentId)
        if page > 0 {
            return "ページ \(page)"
        } else {
            return "未閲覧"
        }
    }
}

struct ProgressStatView: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.headline)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct StudyModeCard: View {
    var title: String
    var description: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
            
            Spacer()
            
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(height: 150)
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}
