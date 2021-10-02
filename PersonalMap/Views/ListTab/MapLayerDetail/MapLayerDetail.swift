import SwiftUI

struct MapLayerDetail: View {
    let mapLayer: MapLayer
    
    var body: some View {
        VStack {
            Text("レイヤー名: \(mapLayer.layerName)")
            Text("レイヤの種類: \(mapLayer.mapLayerType.rawValue)")
            Text("オブジェクトの数: \(mapLayer.objectIds.count)")
            
            if mapLayer.mapLayerType == .point {
                NavigationLink(destination: MapPointObjectList(mapLayerId: mapLayer.id)) {
                    Text("ポイント一覧")
                }
            }
            else if mapLayer.mapLayerType == .polyLine {
                NavigationLink(destination: Text("sss")) {
                    Text("ポリライン一覧")
                }
            } else if mapLayer.mapLayerType == .polygon {
                NavigationLink(destination: Text("sss")) {
                    Text("ポリゴン一覧")
                }
            }
            
            Button {
            } label: {
                Text("レイヤーの削除")
            }
            .padding(.top)
        }
    }
}

struct MapLayerDetail_Previews: PreviewProvider {
    static var previews: some View {
        MapLayerDetail(mapLayer: MapLayer(id: UUID(), layerName: "レイヤー名", mapLayerType: .point, objectIds: []))
    }
}
