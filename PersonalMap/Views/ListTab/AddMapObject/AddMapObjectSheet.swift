import Foundation

enum AddMapObjectSheet: Hashable, Identifiable {
    var id: Self { self }

    case location
    case locations
    case editLocations(index:Int)
    case item
}
