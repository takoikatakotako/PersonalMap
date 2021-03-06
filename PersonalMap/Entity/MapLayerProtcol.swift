import Foundation

struct MapLayer: Codable, Identifiable {
    var id: UUID
    let layerName: String
    let mapObjectType: MapObjectType
    var objectIds: [UUID]
}

enum MapObjectType: String, Codable, Equatable {
    case point
    case polyLine
    case polygon
    
    var name: String {
        switch self {
        case .point:
            return "ポイント"
        case .polyLine:
            return "ライン"
        case .polygon:
            return "エリア"
        }
    }
}
