import SwiftUI

enum MapObjectMultiLocationSelecterSheet: Hashable, Identifiable {
    var id: Self { self }
    
    case locations
    case editLocations(index:Int)
}
