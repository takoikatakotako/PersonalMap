import Foundation

enum AddMapObjectSheet: Hashable, Identifiable {
    var id: Self { self }

    case symbol
    case location
    case locations
    case editLocations(index:Int)
    case item
}
