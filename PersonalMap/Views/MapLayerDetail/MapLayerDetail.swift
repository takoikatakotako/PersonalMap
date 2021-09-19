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
                    Text("ポイントの追加、削除")
                }
            }
            else if mapLayer.mapLayerType == .polyLine {
                NavigationLink(destination: Text("sss")) {
                    Text("ポリラインの追加、削除")
                }
            } else if mapLayer.mapLayerType == .polygon {
                NavigationLink(destination: Text("sss")) {
                    Text("ポリゴンの追加、削除")
                }
            }
            
            Button {
            } label: {
                Text("削除")
            }
        }
    }
}

struct MapLayerDetail_Previews: PreviewProvider {
    static var previews: some View {
        MapLayerDetail(mapLayer: MapLayer(id: UUID(), layerName: "レイヤー名", mapLayerType: .point, objectIds: []))
    }
}
