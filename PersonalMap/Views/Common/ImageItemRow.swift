import SwiftUI

struct ImageItemRow: View {
    let item: Item
    let image: UIImage?
        
    init(item: Item) {
        self.item = item
        let fileRepository = FileRepository()
        image = fileRepository.getImageData(fileName: item.value)
    }
    
    var body: some View {
        HStack {
            Text("Key: \(item.key)")
            Spacer()
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 60, height: 60)
            } else {
                Text("イメージ")
            }
        }
    }
}

struct ImageItemRow_Previews: PreviewProvider {
    static var previews: some View {
        ImageItemRow(item: Item(id: UUID(), itemType: .text, key: "Key", value: "Value"))
            .previewLayout(.sizeThatFits)
    }
}
