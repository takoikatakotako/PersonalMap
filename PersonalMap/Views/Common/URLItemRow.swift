import SwiftUI

struct URLItemRow: View {
    let item: Item
    var body: some View {
        VStack(alignment: .leading) {
            Text("Key: \(item.key)")
            Text("Value: \(item.value)")
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
