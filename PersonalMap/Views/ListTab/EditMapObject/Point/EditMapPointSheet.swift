import Foundation

enum EditMapPointSheet: Hashable, Identifiable {
    var id: Self { self }

    case symbol
    case location
    case item
}
