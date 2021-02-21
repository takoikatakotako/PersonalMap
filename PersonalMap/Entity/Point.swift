import SwiftUI
import MapKit

struct Point: Identifiable {
    let id = UUID()
    let layerName: String
    let location: CLLocationCoordinate2D
}
