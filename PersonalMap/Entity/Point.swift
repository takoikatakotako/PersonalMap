import SwiftUI
import MapKit

struct Point: Identifiable {
    let id = UUID()
    var isHidden: Bool
    let layerName: String
    let location: CLLocationCoordinate2D
    let infos: [Info]
}
