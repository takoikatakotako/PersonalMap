import Foundation

protocol MapObjectProtcol: Codable {
    var id: UUID { get }
    var isHidden: Bool { get }
    var objectName: String { get }
}

enum MapObject: Equatable {
    case point(MapPoint)
    case polyLine(MapPolyline)
    case polygon(MapPolygon)
    
    var objectName: String {
        switch self {
        case let .point(point):
            return point.objectName
        case let .polyLine(line):
            return line.objectName
        case let .polygon(polygon):
            return polygon.objectName
        }
    }
    
    func getValue() throws -> Data {
        switch self {
        case let .point(point):
            return try JSONEncoder().encode(point)
        case let .polyLine(line):
            return try JSONEncoder().encode(line)
        case let .polygon(polygon):
            return try JSONEncoder().encode(polygon)
        }
    }
}

extension MapObject: Identifiable {
    var id: UUID {
        switch self {
        case let .point(point):
            return point.id
        case let .polyLine(line):
            return line.id
        case let .polygon(polygon):
            return polygon.id
        }
    }
}

extension MapObject: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let mapObjectType = try container.decode(MapObjectTypeDecoder.self)
        switch mapObjectType.mapObjectType {
        case .point:
            if let mapPoint = try? container.decode(MapPoint.self) {
                self = .point(mapPoint)
                return
            }
        case .polyLine:
            if let mapPolyLine = try? container.decode(MapPolyline.self) {
                self = .polyLine(mapPolyLine)
                return
            }
        case .polygon:
            if let mapPolygon = try? container.decode(MapPolygon.self) {
                self = .polygon(mapPolygon)
                return
            }
        }
        
        // TODO: ちゃんとエラー作る
        throw InternalFileError.documentDirectoryNotFound
    }
}
