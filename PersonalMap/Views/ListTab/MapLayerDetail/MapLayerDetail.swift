import SwiftUI

struct MapLayerDetail: View {
    let mapLayerId: UUID
    @State var mapLayer: MapLayer?
    
    var body: some View {
        VStack {
            
            if let mapLayer = mapLayer {
                Text("レイヤー名: \(mapLayer.layerName)")
                Text("レイヤの種類: \(mapLayer.mapObjectType.rawValue)")
                Text("オブジェクトの数: \(mapLayer.objectIds.count)")

                
                NavigationLink(destination: MapObjectList(mapLayerId: mapLayer.id, mapObjectType: mapLayer.mapObjectType)) {
                    Text("オブジェクト一覧")
                }

                Button {
                } label: {
                    Text("レイヤーの削除")
                }
                .padding(.top)
            } else {
                Text("Loading")
            }
            
        }
        .onAppear {
            let fileRepository = FileRepository()
            mapLayer = try? fileRepository.getMapLayer(mapLayerId: mapLayerId)
        }
    }
}

//struct MapLayerDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MapLayerDetail(mapLayer: MapLayer(id: UUID(), layerName: "レイヤー名", mapObjectType: .point, objectIds: []))
//    }
//}
