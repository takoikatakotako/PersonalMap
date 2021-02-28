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
    @Published var points: [Point] = []
    @Published var mapType: MKMapType = MKMapType.standard

    // Status
    @Published var addObjectStatus: AddObjectStatus = .ready
    
    // SwiftUI Action
    @Published var sheet: ContentViewModelSheet?
    @Published var actionSheet: ContentViewModelActionSheet?
    
    func addPoint(location: CLLocationCoordinate2D) {
        sheet = .addPoint(UUID(), location)
    }
    
    func addLine(location: CLLocationCoordinate2D) {
        points.append(Point(isHidden: false, layerName: "\(points.count)", location: location, infos: []))
    }
    
    func showPointList() {
        sheet = .pointList(UUID())
    }
    
    func changeMapTypeButtonTapped() {
        actionSheet = .changeMapType
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
