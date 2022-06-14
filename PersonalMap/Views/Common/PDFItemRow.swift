import SwiftUI
import PDFKit

struct PDFItemRow: View {
    let item: Item
    let image: UIImage?
        
    init(item: Item) {
        self.item = item
        
        let fileRepository = FileRepository()

        guard
            let pdfDocument = fileRepository.getPDFDocument(fileName: item.value),
            let page = pdfDocument.page(at: 0)
        else {
            self.image = nil
            return
        }
        
        self.image = page.thumbnail(of: CGSize(width: 120, height: 120), for: PDFDisplayBox.trimBox)
    }
    
    var body: some View {
        HStack {
            Text("\(item.key)")
                .bold()
            Spacer()
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 60, height: 60)
            } else {
                Text("イメージ")
            }
        }
        .frame(minHeight: 60)
    }
}
