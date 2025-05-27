//
//  PDFViewerView.swift
//  AWSQuizApp
//
//  Created by 藤田基紘 on 2025/05/27.
//

import SwiftUI
import PDFKit

struct PDFViewerView: View {
    @ObservedObject var viewModel: PDFViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // PDFKitView
            PDFKitRepresentedView(document: viewModel.document,
                                 currentPage: $viewModel.currentPage)
                .edgesIgnoringSafeArea(.all)
            
            // ナビゲーションコントロール
            HStack {
                Button(action: {
                    viewModel.goToPreviousPage()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.blue.opacity(0.8)))
                }
                .disabled(!viewModel.canGoToPreviousPage)
                .opacity(viewModel.canGoToPreviousPage ? 1.0 : 0.5)
                
                Spacer()
                
                Text("\(viewModel.currentPage) / \(viewModel.pageCount)")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    viewModel.goToNextPage()
                }) {
                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.blue.opacity(0.8)))
                }
                .disabled(!viewModel.canGoToNextPage)
                .opacity(viewModel.canGoToNextPage ? 1.0 : 0.5)
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .navigationBarTitle("PDF閲覧", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle")
                .font(.title2)
                .foregroundColor(.gray)
        })
        .onDisappear {
            viewModel.saveLastViewedPage()
        }
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let document: PDFKit.PDFDocument
    @Binding var currentPage: Int
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = document
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        if let page = document.page(at: currentPage - 1) {
            pdfView.go(to: page)
        }
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
        if let page = document.page(at: currentPage - 1) {
            uiView.go(to: page)
        }
    }
}
