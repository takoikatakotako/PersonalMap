import SwiftUI

struct URLItemRow: View {
    let item: Item
    var body: some View {
        VStack(alignment: .leading) {
            Text("項目名: \(item.key)")
            Text("内容: \(item.value)")
        }
        .frame(height: 60)
    }
}

struct URLItemRow_Previews: PreviewProvider {
    static var previews: some View {
        URLItemRow(item: Item(id: UUID(), itemType: .text, key: "Key", value: "Value"))
            .previewLayout(.sizeThatFits)
    }
}
