import SwiftUI

struct MapObjectList: View {
    let mapLayerId: UUID
    @State var mapObjects: [MapObject] = []
    @State var showingSheet = false
    
    var body: some View {
        List(mapObjects) { mapObject in
            NavigationLink {
                MapPointDetail()
            } label: {
                Text(mapObject.objectName)
            }
        }
        .onAppear {
            getMapPointObjects()
        }
        .navigationBarItems(trailing: Button(action: {
            showingSheet = true
        }, label: {
            Text("追加")
        }))
        .sheet(isPresented: $showingSheet) {
            // on dissmiss
            getMapPointObjects()
        } content: {
            AddMapPointObjectView(mapLayerId: mapLayerId)
        }
    }
    
    private func getMapPointObjects() {
        let fileRepository = FileRepository()
        let mapLayer = try! fileRepository.getMapLayer(mapLayerId: mapLayerId)
        mapObjects = try! fileRepository.getMapPointObjects(mapPointObjectIds: mapLayer.objectIds)
    }
}

struct MapPointObjectList_Previews: PreviewProvider {
    static var previews: some View {
        MapObjectList(mapLayerId: UUID())
    }
}
