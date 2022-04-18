import SwiftUI

class EditMapPolylineViewState: ObservableObject {
    @Published var polyLine: MapPolyLine
    
    init(polyLine: MapPolyLine) {
        self.polyLine = polyLine
    }
}
