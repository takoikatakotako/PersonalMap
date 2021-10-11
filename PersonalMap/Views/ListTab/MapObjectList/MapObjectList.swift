import SwiftUI

struct MapObjectList: View {
    let mapLayerId: UUID
    let mapObjectType: MapObjectType
    @State var mapObjects: [MapObject] = []
    @State var showingSheet = false
    
    var body: some View {
        List(mapObjects) { mapObject in
            NavigationLink {
                MapObjectDetailView(mapObject: mapObject)
            } label: {
                Text(mapObject.objectName)
            }
        }
        .onAppear {
            try? getMapPointObjects()
        }
        .navigationBarItems(trailing: Button(action: {
            showingSheet = true
        }, label: {
            Text("追加")
        }))
        .sheet(isPresented: $showingSheet) {
            // on dissmiss
            try? getMapPointObjects()
        } content: {
            switch mapObjectType {
                case .point:
                AddMapPointObjectView(mapLayerId: mapLayerId)
            case .polyLine:
                AddMapPolylineObjectView(mapLayerId: mapLayerId)
            case .polygon:
                AddMapPolygonObjectView(mapLayerId: mapLayerId)
            }
        }
    }
    
    private func getMapPointObjects() throws {
        let fileRepository = FileRepository()
        let mapLayer = try fileRepository.getMapLayer(mapLayerId: mapLayerId)
        mapObjects = try fileRepository.getMapObjects(mapObjectIds: mapLayer.objectIds)
    }
}

//struct MapPointObjectList_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectList(mapLayerId: UUID())
//    }
//}
