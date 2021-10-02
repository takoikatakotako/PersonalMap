import Foundation

struct Info: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    let key: String
    let value: String
}
