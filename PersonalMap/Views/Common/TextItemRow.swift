import SwiftUI

struct TextItemRow: View {
    let item: Item
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(item.key)")
                .bold()
            Text("\(item.value)")
        }
        .frame(minHeight: 60)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TextItemRow(item: Item(id: UUID(), itemType: .text, key: "Key", value: "Value"))
}
