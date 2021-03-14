import SwiftUI
import MapKit

enum ContentViewModelSheet: Identifiable {
    case addPoint(UUID, CLLocationCoordinate2D)
    case addLine(UUID, [CLLocationCoordinate2D])
    case pointList(UUID)
    
    var id: UUID {
        switch self {
        case let .addPoint(id, _):
            return id
        case let .addLine(id, _):
            return id
        case let .pointList(id):
            return id
        }
    }
}

enum ContentViewModelActionSheet: Identifiable {
    case newObject
    case changeMapType
    
    var id: Int {
        hashValue
    }
}

class ContentViewModel: ObservableObject {
    // Map
    @Published var mapObjects: [MapObject] = []
    @Published var mapType: MKMapType = MKMapType.standard

    // Status
    @Published var addObjectStatus: AddObjectStatus = .ready
    
    // SwiftUI Action
    @Published var sheet: ContentViewModelSheet?
    @Published var actionSheet: ContentViewModelActionSheet?
    
    // 退避
    private var evacuatedMapObjects: [MapObject] = []
    
    // New Line
    var newLineLocations: [CLLocationCoordinate2D] = []
    
    
    /// 追加
    
    // ポイント追加モード
    func setAddPointMode() {
        addObjectStatus = .point
        evacuatedMapObjects = mapObjects
        mapObjects = []
    }
    
    // ポイント追加モード解除
    func resetAddPointMode() {
        addObjectStatus = .ready
        mapObjects = evacuatedMapObjects
        evacuatedMapObjects = []
    }
    
    // ポイントを追加
    func addPoint(point: Point) {
        evacuatedMapObjects.append(.point(point))
    }
    
    // ライン追加モード
    func setAddLineMode() {
        addObjectStatus = .line
        evacuatedMapObjects = mapObjects
        mapObjects = []
    }
    
    // ライン追加モード解除
    func resetAddLineMode() {
        addObjectStatus = .ready
        mapObjects = evacuatedMapObjects
        evacuatedMapObjects = []
    }
    
    // ラインを追加
    func addLine(line: Line) {
        evacuatedMapObjects.append(.line(line))
    }
    
    // エリア追加モード
    func setAddAreaMode() {
        addObjectStatus = .area
        evacuatedMapObjects = mapObjects
        mapObjects = []
    }
    
    // デフォルトモード
    func setReadyMode() {
        mapObjects = evacuatedMapObjects
        evacuatedMapObjects = []
        newLineLocations = []
        addObjectStatus = .ready
    }
    
    
    
    
    // Show
    
    func showAddPointSheet(location: CLLocationCoordinate2D) {
        sheet = .addPoint(UUID(), location)
    }
    
    func showChangeMapTypeActionSheet() {
        actionSheet = .changeMapType
    }
    
    
    
    // ラインを追加
    func addLine(location: CLLocationCoordinate2D) {
        newLineLocations.append(location)
        mapObjects = []
        mapObjects.append(.line(Line(isHidden: false, layerName: "新しいライン", locations: newLineLocations, infos: [])))
    }
    
    func addLineXXX() {
        mapObjects = []
        sheet = .addLine(UUID(), newLineLocations)
    }
    
    func showPointList() {
        sheet = .pointList(UUID())
    }
    
    func changeMapType(mapType: MKMapType) {
        self.mapType = mapType
    }
}
