import SwiftUI
import MapKit

struct Point: MapObjectProtcol, Identifiable {
    let id = UUID()
    var isHidden: Bool
    let layerName: String
    let location: CLLocationCoordinate2D
    let infos: [Info]
}
