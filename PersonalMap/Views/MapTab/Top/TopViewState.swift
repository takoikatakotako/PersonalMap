import SwiftUI
import MapKit

class TopViewState: ObservableObject {
    @Published var mapObjects: [MapObject] = []
    @Published var mapType: MKMapType = .standard
    @Published var mapTileType: MapTileType = .none
    @Published var route: Route?
    @Published var sheet: TopSheetItem?
    
    // Alert
    @Published var alert: TopAlertItem?
    @Published var showingMapTileAlert: Bool = false
    @Published var routeConfirmLocation: Coordinate?
    @Published var messageAlertText: String?

    private let fileRepository = FileRepository()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(resetReceived(notification:)), name: .reset, object: nil)
    }
    
    func onAppear() {
        var updatedMapObjects: [MapObject] = []
        let mapLayers: [MapLayer] = try! fileRepository.getMapLyers()
        for mapLayer in mapLayers {
            for mapObjectId in mapLayer.objectIds {
                let mapObject: MapObject = try! fileRepository.getMapObject(mapObjectId: mapObjectId)
                updatedMapObjects.append(mapObject)
            }
        }
        
        // 差分がある場合は更新する
        if mapObjects != updatedMapObjects {
            mapObjects = updatedMapObjects
        }
    }
    
    func anotationTapped(mapObjectId: UUID) {
        let mapObject = try! fileRepository.getMapObject(mapObjectId: mapObjectId)
        sheet = .showMapObject(mapObject: mapObject)
    }
    
    func longPressEnded(location: CLLocationCoordinate2D) {
        alert = .routeConfirmAlert(location.coordinate)
        routeConfirmLocation = location.coordinate
    }

    func routeNotFound() {
        route = nil
        alert = .messageAlert("ルートが見つかりませんでした")
        messageAlertText = "ルートが見つかりませんでした"
    }
    
    func carButtonTapped() {
        mapType = .standard
    }
    
    func airplaneButtonTapped() {
        mapType = .satellite
    }
    
    func busButtonTapped() {
        mapType = .hybrid
    }
    
    func bycycleButtonTapped() {
        mapType = .mutedStandard
    }
    
    func minusButtonTapped() {
        route = nil
    }
    
    func mapTileButtonTapped() {
        showingMapTileAlert = true
    }
    
    func selectMapTile(mapTile: MapTileType) {
        self.mapTileType = mapTile
    }
    
    func showRoute(destination: Coordinate) {
        guard let lastKnownLocation: CLLocationCoordinate2D = LocationManager.shared.lastKnownLocation else {
            alert = .messageAlert("現在地が取得できませんでした。")
            messageAlertText = "現在地が取得できませんでした。"
            return
        }
                                
        route = Route(source: lastKnownLocation, destination: destination.locationCoordinate2D)
    }
    
    @objc func resetReceived(notification: NSNotification) {
        DispatchQueue.main.async {
            self.mapObjects = []
            self.mapType = .standard
            self.route = nil
            self.sheet = nil
            self.alert = nil
            self.routeConfirmLocation = nil
            self.messageAlertText = nil
        }
    }
}

