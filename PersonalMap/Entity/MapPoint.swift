import SwiftUI
import MapKit

struct MapPoint: MapObjectProtcol, Identifiable, Codable {
    let id: UUID
    var mapObjectType: MapObjectType = .point
    var isHidden: Bool
    var objectName: String
    var coordinate: Coordinate
    var infos: [Info]
}
