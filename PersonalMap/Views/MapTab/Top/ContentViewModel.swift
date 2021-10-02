import SwiftUI
import MapKit

enum ContentViewModelSheet: Identifiable {
    case addPoint(UUID, CLLocationCoordinate2D)
    case addPolyLine(UUID, [CLLocationCoordinate2D])
    case addPolygon(UUID, [CLLocationCoordinate2D])
    case mapObjectList(UUID)
    
    var id: UUID {
        switch self {
        case let .addPoint(id, _):
            return id
        case let .addPolyLine(id, _):
            return id
        case let .addPolygon(id, _):
            return id
        case let .mapObjectList(id):
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
    
    // new Area
    var newPolygonLocations: [CLLocationCoordinate2D] = []

    /// 追加
    /// Point
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
    
    // ポイント追加モーダルを表示
    func showAddPointSheet(location: CLLocationCoordinate2D) {
        sheet = .addPoint(UUID(), location)
    }
    
    // ポイントを追加する
    func addPoint(point: MapPoint) {
        // 追加のタイミングで戻す
        evacuatedMapObjects.append(.point(point))
        mapObjects = evacuatedMapObjects
        evacuatedMapObjects = []
    }
    
    
    /// Line
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
        newLineLocations = []
    }
    
    // ライン候補に追加
    func appendLineLocations(location: CLLocationCoordinate2D) {
        newLineLocations.append(location)
        mapObjects = []
        mapObjects.append(.polyLine(MapPolyLine(isHidden: false, layerName: "新しいライン", locations: newLineLocations, infos: [])))
    }
    
    // ライン追加モーダルを表示
    func showAddLineSheet() {
        sheet = .addPolyLine(UUID(), newLineLocations)
    }
    
    // ラインを追加
    func addLine(line: MapPolyLine) {
        // 追加のタイミングで戻す
        evacuatedMapObjects.append(.polyLine(line))
        mapObjects = evacuatedMapObjects
        newLineLocations = []
        evacuatedMapObjects = []
    }
    
    
    /// Polygon
    // ポリゴン追加モード
    func setAddPolygonMode() {
        addObjectStatus = .polygon
        evacuatedMapObjects = mapObjects
        mapObjects = []
    }
    
    // ポリゴン追加モード解除
    func resetPolygonMode() {
        addObjectStatus = .ready
        mapObjects = evacuatedMapObjects
        evacuatedMapObjects = []
        newPolygonLocations = []
    }
    
    // ポリゴン候補に追加
    func appendPolygonLocation(location: CLLocationCoordinate2D) {
        newPolygonLocations.append(location)
        mapObjects = []
        mapObjects.append(.polygon(MapPolygon(isHidden: false, layerName: "新しいライン", locations: newPolygonLocations, infos: [])))
    }
    
    // ポリゴン追加モーダルを表示
    func shhowAddPolygonSheet() {
        sheet = .addPolygon(UUID(), newPolygonLocations)
    }
    
    // ラインを追加
    func addPolygon(polygon: MapPolygon) {
        // 追加のタイミングで戻す
        evacuatedMapObjects.append(.polygon(polygon))
        mapObjects = evacuatedMapObjects
        newLineLocations = []
        evacuatedMapObjects = []
    }
    
    // デフォルトモード
    func setReadyMode() {
        addObjectStatus = .ready
    }
    
    
    
    
    // Show
    func showChangeMapTypeActionSheet() {
        actionSheet = .changeMapType
    }
    
    func showMapObjectList() {
        sheet = .mapObjectList(UUID())
    }
    
    func changeMapType(mapType: MKMapType) {
        self.mapType = mapType
    }
}
