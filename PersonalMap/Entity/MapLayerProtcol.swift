import Foundation

struct MapLayer: Codable, Identifiable {
    var id: UUID
    let layerName: String
    let mapLayerType: MapLayerType
    let objectIds: [UUID]
}

enum MapLayerType: String, Codable {
    case point
    case polyLine
    case polygon
}
