import SwiftUI

struct MapObjectListView: View {
    @ObservedObject var  viewState: MapObjectListViewState
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(mapLayer: MapLayer) {
        viewState = MapObjectListViewState(mapLayer: mapLayer)
    }
    
    var body: some View {
        List {
            ForEach(viewState.mapObjects) { (mapObject: MapObject) in
                NavigationLink {
                    MapObjectDetailView(mapObject: mapObject)
                } label: {
                    Text(mapObject.objectName)
                }
            }
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
                AddMapPolylineObjectView(mapLayerId: viewState.mapLayer.id)
            case .polygon:
                AddMapPolygonObjectView(mapLayerId: viewState.mapLayer.id)
            }
        }
    }
}

//struct MapPointObjectList_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectList(mapLayerId: UUID())
//    }
//}
