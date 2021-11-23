import Foundation

struct Item: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    let itemType: ItemType
    let key: String
    let value: String
}
