import SwiftUI
import MapKit

enum ContentViewModelSheet: Identifiable {
    case addPoint(UUID, CLLocationCoordinate2D)
    case pointList(UUID)
    
    var id: UUID {
        switch self {
        case let .addPoint(id, _):
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
    @Published var points: [Point] = []
    @Published var mapType: MKMapType = MKMapType.standard

    // Status
    @Published var addObjectStatus: AddObjectStatus = .ready
    
    // SwiftUI Action
    @Published var sheet: ContentViewModelSheet?
    @Published var actionSheet: ContentViewModelActionSheet?
    
    var newLineLocations: [CLLocationCoordinate2D] = []
    
    // ButtonTapped
    func changeMapTypeButtonTapped() {
        actionSheet = .changeMapType
    }
    
    func addMapObject(mapObject: MapObject) {
        mapObjects.append(mapObject)
    }
    
    func addPoint(location: CLLocationCoordinate2D) {
        sheet = .addPoint(UUID(), location)
    }
    
    func addLine(location: CLLocationCoordinate2D) {
        newLineLocations.append(location)
        mapObjects = []
        mapObjects.append(.line(Line(isHidden: false, layerName: "xxx", locations: newLineLocations, infos: [])))
    }
    
    func showPointList() {
        sheet = .pointList(UUID())
    }
    
    func addObjectStatus(status: AddObjectStatus) {
        self.addObjectStatus = status
    }
    
    func changeMapType(mapType: MKMapType) {
        self.mapType = mapType
    }
}

//レイヤー名
//タイトル
// 項目は自由に
// 送電線名: xxx [String: String]
