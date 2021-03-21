import Foundation

protocol MapObjectProtcol {
    var id: UUID { get }
    var isHidden: Bool { get }
    var layerName: String { get }
}

enum  MapObject: Identifiable {
    case point(Point)
    case polyLine(PolyLine)
    case polygon(Polygon)
    
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
