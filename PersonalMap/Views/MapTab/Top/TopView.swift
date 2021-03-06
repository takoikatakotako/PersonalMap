import SwiftUI
import MapKit

struct TopView: View {
    @StateObject var viewState = TopViewState()
    
    var body: some View {
        ZStack(alignment: .top) {
            MapObjectView(mapObjects: $viewState.mapObjects, mapType: $viewState.mapType, route: $viewState.route) { mapObjectId in
                viewState.anotationTapped(mapObjectId: mapObjectId)
            } longPressEnded: { location in
                viewState.longPressEnded(location: location)
            } routeNotFound2: {
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
                    viewState.minusButtonTapped()
                } label: {
                    CommonButton(systemName: "minus.circle", active: true)
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
        .alert(item: $viewState.alert) { item in
            switch item {
            case .routeConfirmAlert(let location):
                return Alert(
                    title: Text(""),
                    message: Text("???????????????\(location.latitude), \(location.longitude)??????????????????????????????????????????"),
                    primaryButton: .default(Text("???????????????")),
                    secondaryButton: .default(Text("??????"), action: {
                        viewState.showRoute(destination: location)
                    })
                )
            case .messageAlert(let message):
                return Alert(title: Text(""), message: Text(message), dismissButton: .default(Text("?????????")))
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
