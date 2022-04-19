import SwiftUI
import MapKit

struct TopView: View {
    @StateObject var viewState = TopViewState()
    
    var body: some View {
        ZStack(alignment: .top) {
            MapObjectView(mapObjects: $viewState.mapObjects, mapType: $viewState.mapType, route: $viewState.route) { mapObjectId in
                viewState.sheet = .showMapObject(mapObjectId)
            } longPressEnded: { location in
                viewState.alert = .routeConfirmAlert(UUID(), location)
            } routeNotFound2: {
                viewState.route = nil
                viewState.alert = .messageAlert(UUID(), "ルートが見つかりませんでした")
            }
            .ignoresSafeArea(.all, edges: .top)
            
            HStack {
                Button {
                    viewState.mapType = .standard
                } label: {
                    CommonButton(systemName: "car", active: viewState.mapType == .standard)
                }
                
                Button {
                    viewState.mapType = .satellite
                } label: {
                    CommonButton(systemName: "airplane", active: viewState.mapType == .satellite)
                }
            }
        }
        .sheet(item: $viewState.sheet, onDismiss: {
            
        }, content: { item in
            switch item {
            case let .showMapObject(id):
                let fileRepository = FileRepository()
                let mapObject = try! fileRepository.getMapObject(mapObjectId: id)
                
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
        .alert(item: $viewState.alert) { item in
            switch item {
            case let .routeConfirmAlert(_, location):
                return Alert(
                    title: Text(""),
                    message: Text("現在地から\(location.latitude), \(location.longitude)へのアクセスを表示しますか？"),
                    primaryButton: .default(Text("キャンセル")),
                    secondaryButton: .default(Text("はい"), action: {
                        
                        guard let lastKnownLocation: CLLocationCoordinate2D = LocationManager.shared.lastKnownLocation else {
                            return
                        }
                                                
                        viewState.route = Route(source: lastKnownLocation, destination: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    })
                )
            case let .messageAlert(_, message):
                return Alert(title: Text(""), message: Text(message), dismissButton: .default(Text("閉じる")))
            }
        }
        .onAppear {
            viewState.onAppear()
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
