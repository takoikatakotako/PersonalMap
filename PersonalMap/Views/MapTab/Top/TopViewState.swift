import SwiftUI
import MapKit

class TopViewState: ObservableObject {
    @Published var mapObjects: [MapObject] = []
    @Published var mapType: MKMapType = .standard
    @Published var mapTileType: MapTileType = .none
    @Published var route: Route?
    @Published var sheet: TopSheetItem?
    
    @Published var shouldReturnToLocation: Bool = false

    // Alert
    @Published var showingMapTileAlert: Bool = false
    @Published var routeConfirmLocation: Coordinate?
    @Published var messageAlertText: String?

    private let fileRepository: FileRepositoryProtocol
    private let locationProvider: LocationProviding

    init(
        fileRepository: FileRepositoryProtocol = FileRepository(),
        locationProvider: LocationProviding = LocationManager.shared
    ) {
        self.fileRepository = fileRepository
        self.locationProvider = locationProvider
        NotificationCenter.default.addObserver(self, selector: #selector(resetReceived(notification:)), name: .reset, object: nil)
    }
    
    func onAppear() {
        do {
            var updatedMapObjects: [MapObject] = []
            let mapLayers = try fileRepository.getMapLayers()
            for mapLayer in mapLayers {
                for mapObjectId in mapLayer.objectIds {
                    let mapObject = try fileRepository.getMapObject(mapObjectId: mapObjectId)
                    updatedMapObjects.append(mapObject)
                }
            }

            // 差分がある場合は更新する
            if mapObjects != updatedMapObjects {
                mapObjects = updatedMapObjects
            }
        } catch {
            messageAlertText = "データの読み込みに失敗しました"
        }
    }

    func annotationTapped(mapObjectId: UUID) {
        do {
            let mapObject = try fileRepository.getMapObject(mapObjectId: mapObjectId)
            sheet = .showMapObject(mapObject: mapObject)
        } catch {
            messageAlertText = "データの読み込みに失敗しました"
        }
    }
    
    func longPressEnded(location: CLLocationCoordinate2D) {
        routeConfirmLocation = location.coordinate
    }

    func routeNotFound() {
        route = nil
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
    
    func bicycleButtonTapped() {
        mapType = .mutedStandard
    }
    
    func minusButtonTapped() {
        route = nil
    }

    func locationButtonTapped() {
        shouldReturnToLocation = true
    }
    
    func mapTileButtonTapped() {
        showingMapTileAlert = true
    }
    
    func selectMapTile(mapTile: MapTileType) {
        self.mapTileType = mapTile
    }
    
    func showRoute(destination: Coordinate) {
        guard let lastKnownLocation = locationProvider.lastKnownLocation else {
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
            self.routeConfirmLocation = nil
            self.messageAlertText = nil
        }
    }
}

