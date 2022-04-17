import SwiftUI

class EditMapPointDetailViewState: ObservableObject {
    @Published var point: MapPoint
    @Published var sheet: EditMapPointSheet?

    init(point: MapPoint) {
        self.point = point
    }
}
