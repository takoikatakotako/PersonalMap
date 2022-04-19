import SwiftUI

enum TopSheetItem: Identifiable, Hashable {
    var id: Self {
        return self
    }
    case showMapObject(mapObject: MapObject)
}
