import SwiftUI

class MapLayerListViewState: ObservableObject {
    @Published var mapLayers: [MapLayer] = []
    @Published var showingSheet = false

}
