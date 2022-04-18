import SwiftUI

class EditMapObjectViewState: ObservableObject {
    @Published var mapObject: MapObject

    init(mapObject: MapObject) {
        self.mapObject = mapObject
    }
}
