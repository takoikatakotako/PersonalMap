import SwiftUI

struct MapLayerListView: View {
    @ObservedObject var  viewState: MapLayerListViewState = MapLayerListViewState()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewState.mapLayers) { (mapLayer: MapLayer) in
                    NavigationLink(destination: MapObjectListView(mapLayer: mapLayer)) {
                        VStack(alignment: .leading) {
                            Text(mapLayer.layerName)
                            Text(mapLayer.mapObjectType.name)
                        }
                    }
                }
                .onDelete(perform: rowRemove)
            }
            .onAppear {
                let fileRepository = FileRepository()
                try! fileRepository.initialize()
                let mapLayers = try! fileRepository.getMapLyers()
                viewState.mapLayers = mapLayers
            }
            .sheet(
                isPresented: $viewState.showingSheet, onDismiss: {
                    let mapLayers = try! FileRepository().getMapLyers()
                    viewState.mapLayers = mapLayers
                }, content: {
                    AddMapLayerView()
                })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("レイヤーリスト")
            .navigationBarItems(trailing: Button(action: {
                viewState.showingSheet = true
            }, label: {
                HStack {
                    EditButton()
                    
                    Button(action: {
                        viewState.showingSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }))
        }
    }
    
    func rowRemove(offsets: IndexSet) {
        let deleteLayerIds: [UUID] = offsets.map { viewState.mapLayers[$0].id }
        for deleteLayerId in deleteLayerIds {
            try! deleteMapLayer(deleteLayerId: deleteLayerId)
        }
//        try! deleteMapObjects(deletedMapObjectIds: deletedMapObjectIds)
//        mapObjects.remove(atOffsets: offsets)
    }
    
    
    private func deleteMapLayer(deleteLayerId: UUID) throws {
        let fileRepository = FileRepository()
        
    }
    
    
    private func deleteMapObjects(deletedMapObjectIds: [UUID]) throws {
//        let fileRepository = FileRepository()
//        var mapLayer: MapLayer = try fileRepository.getMapLayer(mapLayerId: mapLayer.id)
//
//        // 削除された MapObjectId を MapLayer から削除
//        for deletedMapObjectId in deletedMapObjectIds {
//            if let index = mapLayer.objectIds.firstIndex(of: deletedMapObjectId) {
//                mapLayer.objectIds.remove(at: index)
//            }
//        }
//        try fileRepository.saveMapLayer(mapLayer: mapLayer)
//
//        // MapObject を削除
//        for deletedMapObjectId in deletedMapObjectIds {
//            try fileRepository.deleteMapObject(mapObjectId: deletedMapObjectId)
//        }
    }
    
}

struct LayerListView_Previews: PreviewProvider {
    static var previews: some View {
        MapLayerListView()
    }
}
