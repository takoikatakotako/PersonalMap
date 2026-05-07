import SwiftUI
import MapKit

struct TopView: View {
    @StateObject var viewState = TopViewState()
    
    var body: some View {
        ZStack(alignment: .top) {
            MapObjectView(mapObjects: $viewState.mapObjects, mapType: $viewState.mapType, mapTileType: $viewState.mapTileType, route: $viewState.route, shouldReturnToLocation: $viewState.shouldReturnToLocation) { mapObjectId in
                viewState.annotationTapped(mapObjectId: mapObjectId)
            } longPressEnded: { location in
                viewState.longPressEnded(location: location)
            } routeNotFound: {
                viewState.routeNotFound()
            }
            .ignoresSafeArea(.all, edges: .top)

            HStack {
                Button {
                    viewState.carButtonTapped()
                } label: {
                    CommonButton(systemName: "car", active: viewState.mapType == .standard)
                }

                Button {
                    viewState.airplaneButtonTapped()
                } label: {
                    CommonButton(systemName: "airplane", active: viewState.mapType == .satellite)
                }

                Button {
                    viewState.busButtonTapped()
                } label: {
                    CommonButton(systemName: "bus", active: viewState.mapType == .hybrid)
                }

                Button {
                    viewState.bicycleButtonTapped()
                } label: {
                    CommonButton(systemName: "bicycle", active: viewState.mapType == .mutedStandard)
                }

                Button {
                    viewState.minusButtonTapped()
                } label: {
                    CommonButton(systemName: "minus.circle", active: true)
                }

                Button {
                    viewState.locationButtonTapped()
                } label: {
                    CommonButton(systemName: "location", active: true)
                }

                Button {
                    viewState.mapTileButtonTapped()
                } label: {
                    CommonButton(systemName: "map", active: true)
                }
            }
        }
        .sheet(item: $viewState.sheet, onDismiss: {
            
        }, content: { item in
            switch item {
            case let .showMapObject(mapObject):
                switch mapObject {
                case .point(let point):
                    MapPointPreview(point: point, route: $viewState.route)
                case .polyLine(let polyline):
                    MapPolyLinePreview(polyline: polyline, route: $viewState.route)
                case .polygon(let polygon):
                    MapPolygonPreview(polygon: polygon, route: $viewState.route)
                }
            }
        })
        .alert("マップタイル選択", isPresented: $viewState.showingMapTileAlert, actions: {
            Button("タイルなし", role: .none) {
                viewState.selectMapTile(mapTile: .none)
            }
            
            Button("標準地図", role: .none) {
                viewState.selectMapTile(mapTile: .standard)
            }
            
            Button("淡色地図", role: .none) {
                viewState.selectMapTile(mapTile: .pale)
            }
            
            Button("とじる", role: .none) {}
        }, message: {
            Text("マップタイルを選択してください。")
        })
        .alert("", isPresented: Binding(
            get: { viewState.routeConfirmLocation != nil },
            set: { if !$0 { viewState.routeConfirmLocation = nil } }
        )) {
            Button("キャンセル", role: .cancel) {
                viewState.routeConfirmLocation = nil
            }
            Button("はい") {
                if let location = viewState.routeConfirmLocation {
                    viewState.showRoute(destination: location)
                }
                viewState.routeConfirmLocation = nil
            }
        } message: {
            if let location = viewState.routeConfirmLocation {
                Text("現在地から\(location.latitude), \(location.longitude)へのアクセスを表示しますか？")
            }
        }
        .alert("", isPresented: Binding(
            get: { viewState.messageAlertText != nil },
            set: { if !$0 { viewState.messageAlertText = nil } }
        )) {
            Button("閉じる", role: .cancel) {
                viewState.messageAlertText = nil
            }
        } message: {
            if let message = viewState.messageAlertText {
                Text(message)
            }
        }
        .onAppear {
            viewState.onAppear()
        }
    }
}

#Preview {
    TopView()
}
