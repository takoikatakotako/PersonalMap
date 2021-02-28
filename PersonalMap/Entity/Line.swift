import SwiftUI
import MapKit

struct Line: MapObjectProtcol, Identifiable {
    let id = UUID()
    var isHidden: Bool
    let layerName: String
    let locations: [CLLocationCoordinate2D]
    let infos: [Info]
}
