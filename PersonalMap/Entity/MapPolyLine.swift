import SwiftUI
import MapKit

struct MapPolyLine: MapObjectProtcol, Identifiable, Codable {
    let id: UUID
    var mapObjectType: MapObjectType = .polyLine
    var isHidden: Bool
    let layerName: String
    let coordinates: [Coordinate]
    let infos: [Info]
    
    var locationCoordinate2Ds: [CLLocationCoordinate2D] {
        return coordinates.map { $0.locationCoordinate2D }
    }
}
