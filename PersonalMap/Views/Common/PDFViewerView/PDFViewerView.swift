import SwiftUI
import PDFKit

struct PDFViewerView: UIViewRepresentable {
    let fileName: String

    func makeUIView(context: Context) -> PDFView {
        let fileRepository = FileRepository()
        let pdfDocument = fileRepository.getPDFDocument(fileName: fileName)
        
        let view = PDFView()
        view.document = pdfDocument
        view.autoScales = true
        return view
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}
