import SwiftUI
import MapKit

struct MapPoint: MapObjectProtcol, Identifiable, Codable {
    let id = UUID()
    let mapObjectType: MapObjectType = .point
    var isHidden: Bool
    let layerName: String
    let coordinate: Coordinate
    let infos: [Info]
}
