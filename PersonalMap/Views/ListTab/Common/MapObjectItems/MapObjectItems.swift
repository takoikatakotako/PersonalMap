import SwiftUI

struct MapObjectItems: View {
    @Binding var items: [Item]
    @State private var sheet: MapObjectItemsSheetItem?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("項目の作成")
                .font(Font.system(size: 20).bold())
                .padding(.top, 12)
                .padding(.bottom, 4)
            
            VStack(alignment: .leading, spacing: 4) {
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
                                Image(uiImage: imageNameToUIImage(imageName: item.value))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                            }
                        }
                    case .pdf:
                        Button {
                            
                        } label: {
                            VStack(alignment: .leading) {
                                Text(item.key)
                                    .bold()
                                Image(uiImage: imageNameToUIImage(imageName: item.value))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                            }
                        }
                    }
                }
            }
            
            HStack {
                Spacer()
                Button {
                    sheet = .showItemList
                } label: {
                    Text("項目を設定")
                }
            }
            .padding(.bottom, 8)
        }
        .sheet(item: $sheet) { item in
            switch item {
            case .showItemList:
                ItemListView(items: $items)
            case let .showImage(imageName: imageName):
                ImageViewerView(imageName: imageName)
            }
        }
    }
    
    private func openUrl(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, completionHandler: nil)
        }
    }
    
    private func imageNameToUIImage(imageName: String) -> UIImage {
        let fileRepository = FileRepository()
        return fileRepository.getImageData(fileName: imageName) ?? UIImage()
    }
}

//struct AddMapObjectItems_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMapObjectItems()
//    }
//}
