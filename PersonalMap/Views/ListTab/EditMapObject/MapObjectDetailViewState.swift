import SwiftUI

class MapObjectDetailViewState: ObservableObject {
    @Published var mapObject: MapObject

    init(mapObject: MapObject) {
        self.mapObject = mapObject
    }
}
