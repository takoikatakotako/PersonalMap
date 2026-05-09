import Testing
import MapKit
@testable import PersonalMap

@MainActor
@Suite("TopViewState")
struct TopViewStateTests {
    private func makeState(
        repo: FileRepositoryProtocol = MockFileRepository(),
        location: LocationProviding = MockLocationProvider()
    ) -> TopViewState {
        TopViewState(fileRepository: repo, locationProvider: location)
    }

    // MARK: - showRoute

    @Test
    func showRouteWithoutLocationSetsErrorMessage() {
        let state = makeState(location: MockLocationProvider(lastKnownLocation: nil))
        state.showRoute(destination: Coordinate(latitude: 35.0, longitude: 139.0))
        #expect(state.route == nil)
        #expect(state.messageAlertText == "現在地が取得できませんでした。")
    }

    @Test
    func showRouteWithLocationCreatesRoute() {
        let here = CLLocationCoordinate2D(latitude: 35.0, longitude: 139.0)
        let state = makeState(location: MockLocationProvider(lastKnownLocation: here))
        state.showRoute(destination: Coordinate(latitude: 36.0, longitude: 140.0))
        #expect(state.route != nil)
        #expect(state.route?.source.latitude == 35.0)
        #expect(state.route?.destination.latitude == 36.0)
        #expect(state.messageAlertText == nil)
    }

    // MARK: - mapType buttons

    @Test
    func mapTypeButtonsSelectExpectedTypes() {
        let state = makeState()

        state.airplaneButtonTapped()
        #expect(state.mapType == .satellite)

        state.busButtonTapped()
        #expect(state.mapType == .hybrid)

        state.bicycleButtonTapped()
        #expect(state.mapType == .mutedStandard)

        state.carButtonTapped()
        #expect(state.mapType == .standard)
    }

    // MARK: - selectMapTile

    @Test
    func selectMapTileUpdatesType() {
        let state = makeState()
        state.selectMapTile(mapTile: .pale)
        #expect(state.mapTileType == .pale)
        state.selectMapTile(mapTile: .none)
        #expect(state.mapTileType == .none)
    }

    @Test
    func mapTileButtonShowsAlert() {
        let state = makeState()
        #expect(state.showingMapTileAlert == false)
        state.mapTileButtonTapped()
        #expect(state.showingMapTileAlert == true)
    }

    // MARK: - location/route flow

    @Test
    func locationButtonRequestsReturnToCurrent() {
        let state = makeState()
        #expect(state.shouldReturnToLocation == false)
        state.locationButtonTapped()
        #expect(state.shouldReturnToLocation == true)
    }

    @Test
    func minusButtonClearsRoute() {
        let state = makeState()
        state.route = Route(
            source: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            destination: CLLocationCoordinate2D(latitude: 1, longitude: 1)
        )
        state.minusButtonTapped()
        #expect(state.route == nil)
    }

    @Test
    func longPressEndedSetsRouteConfirmLocation() {
        let state = makeState()
        state.longPressEnded(location: CLLocationCoordinate2D(latitude: 35.5, longitude: 139.5))
        #expect(state.routeConfirmLocation?.latitude == 35.5)
        #expect(state.routeConfirmLocation?.longitude == 139.5)
    }

    @Test
    func routeNotFoundClearsRouteAndShowsMessage() {
        let state = makeState()
        state.route = Route(
            source: CLLocationCoordinate2D(latitude: 0, longitude: 0),
            destination: CLLocationCoordinate2D(latitude: 1, longitude: 1)
        )
        state.routeNotFound()
        #expect(state.route == nil)
        #expect(state.messageAlertText == "ルートが見つかりませんでした")
    }

    // MARK: - onAppear

    @Test
    func onAppearLoadsMapObjectsFromRepository() {
        let pointId = UUID()
        let layerId = UUID()
        let point = MapPoint(
            id: pointId,
            imageName: "circle",
            isHidden: false,
            objectName: "p",
            coordinate: Coordinate(latitude: 0, longitude: 0),
            items: []
        )
        let layer = MapLayer(
            id: layerId,
            layerName: "L",
            mapObjectType: .point,
            objectIds: [pointId]
        )
        let repo = MockFileRepository()
        repo.layers = [layer]
        repo.objectsById = [pointId: .point(point)]

        let state = makeState(repo: repo)
        state.onAppear()

        #expect(state.mapObjects.count == 1)
        #expect(state.mapObjects.first == .point(point))
        #expect(state.messageAlertText == nil)
    }

    @Test
    func onAppearShowsErrorWhenRepositoryFails() {
        let repo = MockFileRepository()
        repo.getMapLayersError = NSError(domain: "test", code: 1)
        let state = makeState(repo: repo)
        state.onAppear()
        #expect(state.messageAlertText == "データの読み込みに失敗しました")
        #expect(state.mapObjects.isEmpty)
    }

    @Test
    func annotationTappedShowsSheet() {
        let pointId = UUID()
        let point = MapPoint(
            id: pointId,
            imageName: "circle",
            isHidden: false,
            objectName: "p",
            coordinate: Coordinate(latitude: 0, longitude: 0),
            items: []
        )
        let repo = MockFileRepository()
        repo.objectsById = [pointId: .point(point)]
        let state = makeState(repo: repo)
        state.annotationTapped(mapObjectId: pointId)
        #expect(state.sheet == .showMapObject(mapObject: .point(point)))
    }
}
