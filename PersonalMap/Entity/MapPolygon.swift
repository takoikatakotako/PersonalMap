import SwiftUI
import MapKit

struct MapPolygon: MapObjectProtcol {
    let id = UUID()
    let mapObjectType: MapObjectType = .polygon
    var isHidden: Bool
    let layerName: String
    let coordinates: [Coordinate]
    let infos: [Info]
    
    var locationCoordinate2Ds: [CLLocationCoordinate2D] {
        return coordinates.map { $0.locationCoordinate2D }
    }
}
