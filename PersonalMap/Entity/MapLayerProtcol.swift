import Foundation

struct MapLayer: Codable, Identifiable {
    var id: UUID
    let layerName: String
    let mapObjectType: MapObjectType
    let objectIds: [UUID]
}

enum MapObjectType: String, Codable, Equatable {
    case point
    case polyLine
    case polygon
}
