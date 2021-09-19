import SwiftUI

struct MapPointObjectList: View {
    let mapLayerId: UUID
    @State var mapPointObjects: [MapPointObject] = []
    @State var showingSheet = false
    
    var body: some View {
        List(mapPointObjects) { mapPointObject in
            Text(mapPointObject.id.description)
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
        mapPointObjects = try! fileRepository.getMapPointObjects(mapPointObjectIds: mapLayer.objectIds)
    }
}

struct MapPointObjectList_Previews: PreviewProvider {
    static var previews: some View {
        MapPointObjectList(mapLayerId: UUID())
    }
}
