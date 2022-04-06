import SwiftUI

class MapObjectListViewState: ObservableObject {
 
    @Published var showingSheet = false
    @Published var mapObjects: [MapObject] = []

    let mapLayer: MapLayer

    init(mapLayer: MapLayer) {
        self.mapLayer = mapLayer
    }
}

