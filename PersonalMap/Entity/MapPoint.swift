import SwiftUI
import MapKit

struct MapPoint: MapObjectProtcol, Equatable, Identifiable, Codable {
    let id: UUID
    var mapObjectType: MapObjectType = .point
    var imageName: String
    var isHidden: Bool
    var objectName: String
    var coordinate: Coordinate
    var items: [Item]
}
