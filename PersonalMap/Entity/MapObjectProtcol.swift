import Foundation

protocol MapObjectProtcol {
    var id: UUID { get }
    var isHidden: Bool { get }
    var layerName: String { get }
}

enum  MapObject {
    case point(Point)
    case line(Line)
}
