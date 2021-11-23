import SwiftUI
import MapKit

struct MapPolygon: MapObjectProtcol {
    let id: UUID
    var mapObjectType: MapObjectType = .polygon
    var imageName: String
    var isHidden: Bool
    var objectName: String
    var coordinates: [Coordinate]
    var items: [Item]
    
    var locationCoordinate2Ds: [CLLocationCoordinate2D] {
        return coordinates.map { $0.locationCoordinate2D }
    }
}
