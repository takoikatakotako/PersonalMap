import SwiftUI
import UniformTypeIdentifiers
import PDFKit

struct PDFPickerView : UIViewControllerRepresentable {
    @Binding var document: PDFDocument?
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: PDFPickerView
        
        init(_ parent: PDFPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
            if url.startAccessingSecurityScopedResource() {
                let document = PDFDocument(url: url) ?? nil
                self.parent.document = document
            }
            url.stopAccessingSecurityScopedResource()
        }
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentPickerViewController =  UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        documentPickerViewController.delegate = context.coordinator
        return documentPickerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
