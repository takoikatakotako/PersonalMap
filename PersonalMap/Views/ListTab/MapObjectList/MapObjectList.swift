import SwiftUI

struct MapObjectList: View {
    let mapLayer: MapLayer
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var mapObjects: [MapObject] = []
    @State private var showingSheet = false
    
    var body: some View {
        List(mapObjects) { mapObject in
            NavigationLink {
                MapObjectDetailView(mapObject: mapObject)
            } label: {
                Text(mapObject.objectName)
            }
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
                    Button(action: {
                    }, label: {
                        Image(systemName: "trash")
                    })
                    
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
    
    private func getMapPointObjects() throws {
        let fileRepository = FileRepository()
        let mapLayer = try fileRepository.getMapLayer(mapLayerId: mapLayer.id)
        mapObjects = try fileRepository.getMapObjects(mapObjectIds: mapLayer.objectIds)
    }
}

//struct MapPointObjectList_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectList(mapLayerId: UUID())
//    }
//}
