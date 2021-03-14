import Foundation

protocol MapObjectProtcol {
    var id: UUID { get }
    var isHidden: Bool { get }
    var layerName: String { get }
}

enum  MapObject: Identifiable {
    case point(Point)
    case line(Line)
    
    var id: UUID {
        switch self {
        case let .point(point):
            return point.id
        case let .line(line):
            return line.id
        }
    }
    
    var value: MapObjectProtcol {
        switch self {
        case let .point(point):
            return point
        case let .line(line):
            return line
        }
    }
}
