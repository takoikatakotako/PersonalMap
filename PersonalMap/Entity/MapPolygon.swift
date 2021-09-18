import SwiftUI
import MapKit

struct MapPolygon: MapObjectProtcol, Identifiable {
    let id = UUID()
    var isHidden: Bool
    let layerName: String
    let locations: [CLLocationCoordinate2D]
    let infos: [Info]
}
