import SwiftUI
import MapKit

struct MapPolyline: MapObjectProtcol, Equatable, Identifiable, Codable, Hashable {
    let id: UUID
    var mapObjectType: MapObjectType = .polyLine
    var imageName: String
    var isHidden: Bool
    var objectName: String
    var coordinates: [Coordinate]
    var items: [Item]
    
    var locationCoordinate2Ds: [CLLocationCoordinate2D] {
        return coordinates.map { $0.locationCoordinate2D }
    }
}
