import SwiftUI

struct MapObjectListView: View {
    @StateObject var viewState: MapObjectListViewState

    @Environment(\.dismiss) var dismiss
    @State private var selectedMapObject: MapObject?
    @State private var route: Route?

    init(mapLayer: MapLayer) {
        _viewState = StateObject(wrappedValue: MapObjectListViewState(mapLayer: mapLayer))
    }

    var body: some View {
        List {
            ForEach(viewState.mapObjects) { (mapObject: MapObject) in
                Button {
                    selectedMapObject = mapObject
                } label: {
                    HStack {
                        Text(mapObject.objectName)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                .foregroundColor(.primary)
            }
            .onMove(perform: viewState.rowMove)
            .onDelete(perform: viewState.rowRemove)
        }
        .navigationTitle(viewState.navigationTitle)
        .onAppear {
            viewState.onAppear()
        }
        .alert("エラー", isPresented: Binding(
            get: { viewState.errorMessage != nil },
            set: { if !$0 { viewState.errorMessage = nil } }
        )) {
            Button("閉じる", role: .cancel) { viewState.errorMessage = nil }
        } message: {
            if let message = viewState.errorMessage { Text(message) }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.backward")
                }),
            trailing:
                HStack {
                    EditButton()
                    
                    Button(action: {
                        viewState.plusTapped()
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
        )
        .sheet(isPresented: $viewState.showingSheet) {
            viewState.sheetDismiss()
        } content: {
            switch viewState.mapLayer.mapObjectType {
            case .point:
                AddMapPointView(mapLayerId: viewState.mapLayer.id)
            case .polyLine:
                AddMapPolylineView(mapLayerId: viewState.mapLayer.id)
            case .polygon:
                AddMapPolygonView(mapLayerId: viewState.mapLayer.id)
            }
        }
        .sheet(item: $selectedMapObject) { mapObject in
            switch mapObject {
            case .point(let point):
                MapPointPreview(point: point, route: $route)
            case .polyLine(let polyLine):
                MapPolyLinePreview(polyline: polyLine, route: $route)
            case .polygon(let polygon):
                MapPolygonPreview(polygon: polygon, route: $route)
            }
        }
    }
}

//struct MapPointObjectList_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectList(mapLayerId: UUID())
//    }
//}
