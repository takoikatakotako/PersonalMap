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
            .onDelete(perform: rowRemove)
        }
        .navigationTitle(viewState.mapLayer.layerName)
        .onAppear {
            try? getMapPointObjects()
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
                        viewState.showingSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
        )
        .sheet(isPresented: $viewState.showingSheet) {
            // on dissmiss
            try? getMapPointObjects()
        } content: {
            switch viewState.mapLayer.mapObjectType {
            case .point:
                AddMapPointObjectView(mapLayerId: viewState.mapLayer.id)
            case .polyLine:
                AddMapPolylineObjectView(mapLayerId: viewState.mapLayer.id)
            case .polygon:
                AddMapPolygonObjectView(mapLayerId: viewState.mapLayer.id)
            }
        }
    }
    
    private func rowRemove(offsets: IndexSet) {
        let deletedMapObjectIds: [UUID] = offsets.map { viewState.mapObjects[$0].id }
        try! deleteMapObjects(deletedMapObjectIds: deletedMapObjectIds)
        viewState.mapObjects.remove(atOffsets: offsets)
    }
    
    private func getMapPointObjects() throws {
        let fileRepository = FileRepository()
        let mapLayer = try fileRepository.getMapLayer(mapLayerId: viewState.mapLayer.id)
        viewState.mapObjects = try fileRepository.getMapObjects(mapObjectIds: mapLayer.objectIds)
    }
    
    private func deleteMapObjects(deletedMapObjectIds: [UUID]) throws {
        let fileRepository = FileRepository()
        var mapLayer: MapLayer = try fileRepository.getMapLayer(mapLayerId: viewState.mapLayer.id)
        
        // 削除された MapObjectId を MapLayer から削除
        for deletedMapObjectId in deletedMapObjectIds {
            if let index = mapLayer.objectIds.firstIndex(of: deletedMapObjectId) {
                mapLayer.objectIds.remove(at: index)
            }
        }
        try fileRepository.saveMapLayer(mapLayer: mapLayer)
        
        // MapObject を削除
        for deletedMapObjectId in deletedMapObjectIds {
            try fileRepository.deleteMapObject(mapObjectId: deletedMapObjectId)
        }
    }
}

//struct MapPointObjectList_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectList(mapLayerId: UUID())
//    }
//}
