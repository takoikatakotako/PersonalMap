import SwiftUI

struct MapObjectList: View {
    let mapLayer: MapLayer
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var mapObjects: [MapObject] = []
    @State private var showingSheet = false
    
    var body: some View {
        List {
            ForEach(mapObjects) { mapObject in
                NavigationLink {
                    MapObjectDetailView(mapObject: mapObject)
                } label: {
                    Text(mapObject.objectName)
                }
            }
            .onDelete(perform: rowRemove)
        }
        .navigationTitle(mapLayer.layerName)
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
                        showingSheet = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
        )
        .sheet(isPresented: $showingSheet) {
            // on dissmiss
            try? getMapPointObjects()
        } content: {
            switch mapLayer.mapObjectType {
            case .point:
                AddMapPointObjectView(mapLayerId: mapLayer.id)
            case .polyLine:
                AddMapPolylineObjectView(mapLayerId: mapLayer.id)
            case .polygon:
                AddMapPolygonObjectView(mapLayerId: mapLayer.id)
            }
        }
    }
    
    func rowRemove(offsets: IndexSet) {
        let deletedMapObjectIds: [UUID] = offsets.map { mapObjects[$0].id }
        try! deleteMapObjects(deletedMapObjectIds: deletedMapObjectIds)
        mapObjects.remove(atOffsets: offsets)
    }
    
    private func getMapPointObjects() throws {
        let fileRepository = FileRepository()
        let mapLayer = try fileRepository.getMapLayer(mapLayerId: mapLayer.id)
        mapObjects = try fileRepository.getMapObjects(mapObjectIds: mapLayer.objectIds)
    }
    
    private func deleteMapObjects(deletedMapObjectIds: [UUID]) throws {
        let fileRepository = FileRepository()
        var mapLayer: MapLayer = try fileRepository.getMapLayer(mapLayerId: mapLayer.id)
        
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
