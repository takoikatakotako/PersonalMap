import Foundation

enum AddMapObjectSheet: Identifiable {
    case symbol
    case location
    case item
    var id: Int {
        hashValue
    }
}
