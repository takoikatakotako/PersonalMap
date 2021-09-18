import Foundation

protocol MapObjectProtcol {
    var id: UUID { get }
    var isHidden: Bool { get }
    var layerName: String { get }
}

enum MapObject: Identifiable {
    case point(MapPoint)
    case polyLine(MapPolyLine)
    case polygon(MapPolygon)
    
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
    
    var objectName: String {
        switch self {
        case let .point(point):
            return point.layerName
        case let .polyLine(line):
            return line.layerName
        case let .polygon(polygon):
            return polygon.layerName
        }
    }
    
    var value: MapObjectProtcol {
        switch self {
        case let .point(point):
            return point
        case let .polyLine(line):
            return line
        case let .polygon(polygon):
            return polygon
        }
    }
}
