import SwiftUI
import PDFKit

struct AddItemPDFContent: View {
    @Binding var pdfDocument: PDFDocument?
    @Binding var showingSheet: AddItemViewSheet?
    var body: some View {
        HStack {
            if let document = pdfDocument, let page = document.page(at: 0),
               let image = page.thumbnail(of: CGSize(width: 120, height: 120), for: PDFDisplayBox.trimBox) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 120, height: 120)
            } else {
                Text("No Image")
                    .foregroundColor(Color.white)
                    .font(Font.system(size:20).bold())
                    .frame(width: 120, height: 120)
                    .background(Color(UIColor.lightGray))
            }
            
            Spacer()
            
            Button {
                showingSheet = .pdf
            } label: {
                Text("PDFを設定")
            }
        }
    }
}

//struct AddItemPdfContent_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemPDFContent()
//    }
//}
