import SwiftUI
import MapKit
import PDFKit

class AddItemViewState: ObservableObject {
    @Published var selection = 0
    @Published var key: String = ""
    @Published var value: String = ""
    
    @Published var image: UIImage?
    @Published var showingAlert = false
    @Published var alertMessage = ""
    @Published var showingSheet: AddItemViewSheet?
    @Published var pdfDocument: PDFDocument?
    @Published var dismiss = false
    
    @Published var items: [Item] {
        didSet {
            bindingItems = items
        }
    }
    @Binding var bindingItems: [Item]

    private let fileRepository = FileRepository()

    init(items: Binding<[Item]>) {
        self.items = items.wrappedValue
        self._bindingItems = items
    }
    
    
    func saveTextItem() {
        if value.isEmpty {
            alertMessage = "Valueを入力させてください"
            showingAlert = true
            return
        }
        
        let item = Item(id: UUID(), itemType: .text, key: key, value: value)
        items.append(item)
        
        dismiss = true
    }
    
    func saveUrlItem() {
        if URL(string: value) == nil {
            alertMessage = "URLが正しくありません"
            showingAlert = true
            return
        }
        
        let item = Item(id: UUID(), itemType: .url, key: key, value: value)
        items.append(item)

        dismiss = true
    }
    
    func saveImageItem() {
        guard let image = image else {
            alertMessage = "画像が選択されていません"
            showingAlert = true
            return
        }
        
        guard let pngData = image.pngData() else {
            alertMessage = "画像の保存に失敗しました"
            showingAlert = true
            return
        }
        
        do {
            let fileName = UUID().description + ".png"
            try fileRepository.saveImageData(data: pngData, fileName: fileName)
            let item = Item(id: UUID(), itemType: .image, key: key, value: fileName)
            items.append(item)
            
            dismiss = true
        } catch {
            alertMessage = "画像の保存に失敗しました"
            showingAlert = true
        }
    }
    
    func savePDFItem() {
        
    }
}
