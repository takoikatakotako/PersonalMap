import SwiftUI

struct TextItemRow: View {
    let item: Item
    var body: some View {
        VStack(alignment: .leading) {
            Text("項目名: \(item.key)")
            Text("内容: \(item.value)")
        }
        .frame(height: 60)
    }
}

struct TextItemRow_Previews: PreviewProvider {
    static var previews: some View {
        TextItemRow(item: Item(id: UUID(), itemType: .text, key: "Key", value: "Value"))
            .previewLayout(.sizeThatFits)
    }
}
