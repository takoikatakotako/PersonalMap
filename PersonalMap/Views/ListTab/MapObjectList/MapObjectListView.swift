import SwiftUI

struct MapObjectListView: View {
    @StateObject var  viewState: MapObjectListViewState
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(mapLayer: MapLayer) {
        _viewState = StateObject(wrappedValue: MapObjectListViewState(mapLayer: mapLayer))
    }
    
    var body: some View {
        List {
            ForEach(viewState.mapObjects) { (mapObject: MapObject) in
                NavigationLink {                    
                    switch mapObject {
                    case .point(let point):
                        EditMapPointView(point: point)
                    case .polyLine(let polyLine):
                        EditMapPolylineView(polyLine: polyLine)
                    case .polygon(let polygon):
                        EditMapPolygonView(polygon: polygon)
                    }
                } label: {
                    Text(mapObject.objectName)
                }
            }
            .onMove(perform: viewState.rowMove)
            .onDelete(perform: viewState.rowRemove)
        }
        .navigationTitle(viewState.mapLayer.layerName)
        .onAppear {
            viewState.onAppear()
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
            // on dissmiss
            viewState.sheetDissmiss()
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
    }
}

//struct MapPointObjectList_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectList(mapLayerId: UUID())
//    }
//}
