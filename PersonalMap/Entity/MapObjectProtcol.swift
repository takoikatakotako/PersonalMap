import Foundation

protocol MapObjectProtcol {
    var id: UUID { get }
    var isHidden: Bool { get }
    var layerName: String { get }
}

enum  MapObject: Identifiable {
    case point(Point)
    case line(Line)
    case polygon(Polygon)
    
    var id: UUID {
        switch self {
        case let .point(point):
            return point.id
        case let .line(line):
            return line.id
        case let .polygon(polygon):
            return polygon.id
        }
    }
    
    var value: MapObjectProtcol {
        switch self {
        case let .point(point):
            return point
        case let .line(line):
            return line
        case let .polygon(polygon):
            return polygon
        }
    }
}
