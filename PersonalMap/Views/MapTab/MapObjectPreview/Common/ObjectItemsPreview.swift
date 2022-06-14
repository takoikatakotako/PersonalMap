import SwiftUI

struct ObjectItemsPreview: View {
    let items: [Item]
    
    @State private var sheet: ObjectItemsPreviewSheetItem?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("項目")
                .font(Font.system(size: 20).bold())
            
            ForEach(items) { (item: Item) in
                switch item.itemType {
                case .text:
                    VStack(alignment: .leading) {
                        Text(item.key)
                            .bold()
                        Text(item.value)
                            .multilineTextAlignment(.leading)
                    }
                case .url:
                    Button {
                        openUrl(urlString: item.value)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.key)
                                .bold()
                            Text(item.value)
                                .multilineTextAlignment(.leading)
                        }
                    }
                case .image:
                    Button {
                        sheet = .showImage(imageName: item.value)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.key)
                                .bold()
                            Text(item.value)
                                .multilineTextAlignment(.leading)
                        }
                    }
                case .pdf:
                    Button {
                        sheet = .showPDF(fileName: item.value)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.key)
                                .bold()
                            Text(item.value)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
        }
        .sheet(item: $sheet) { item in
            switch item {
            case let .showImage(imageName: imageName):
                ImageViewerView(imageName: imageName)
            case let .showPDF(fileName: fileName):
                PDFViewerView(fileName: fileName)
            }
        }
        .padding(.top, 16)
    }
    
    private func openUrl(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, completionHandler: nil)
        }
    }
}

struct ObjectItemsPreview_Previews: PreviewProvider {
    static var previews: some View {
        ObjectItemsPreview(items: [])
    }
}
