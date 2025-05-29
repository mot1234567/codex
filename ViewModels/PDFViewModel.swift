import Foundation
import PDFKit

class PDFViewModel: ObservableObject {
    @Published var document: PDFKit.PDFDocument
    @Published var currentPage: Int
    
    private let documentId: String
    private let pdfService = PDFService()
    
    var pageCount: Int { document.pageCount }
    
    init(document: PDFKit.PDFDocument, documentId: String) {
        self.document = document
        self.documentId = documentId
        let savedPage = pdfService.getLastViewedPage(for: documentId)
        if savedPage >= 1 && savedPage <= document.pageCount {
            self.currentPage = savedPage
        } else {
            self.currentPage = 1
        }
    }
    
    var canGoToPreviousPage: Bool { currentPage > 1 }
    var canGoToNextPage: Bool { currentPage < pageCount }
    
    func goToPreviousPage() {
        guard canGoToPreviousPage else { return }
        currentPage -= 1
    }
    
    func goToNextPage() {
        guard canGoToNextPage else { return }
        currentPage += 1
    }
    
    func saveLastViewedPage() {
        pdfService.saveLastViewedPage(for: documentId, page: currentPage)
    }
}
