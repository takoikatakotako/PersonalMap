import SwiftUI

struct MapLayerDetail: View {
    let mapLayerId: UUID
    @State var mapLayer: MapLayer?
    
    var body: some View {
        VStack(spacing: 12) {
            if let mapLayer = mapLayer {
                VStack {
                    Text("レイヤー名")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .font(Font.system(size: 20).bold())
                    
                    Text(mapLayer.layerName)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .font(Font.system(size: 20))
                }
                
                VStack {
                    Text("レイヤの種類")
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .font(Font.system(size: 20).bold())
                    
                    Text(mapLayer.mapObjectType.rawValue)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .font(Font.system(size: 20))
                }
                
                
                NavigationLink(destination: MapObjectList(mapLayerId: mapLayer.id, mapObjectType: mapLayer.mapObjectType)) {
                    Text("オブジェクト一覧")
                        .foregroundColor(Color.black)
                        .frame(width: 200)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                
                Button {
                } label: {
                    Text("レイヤーの削除")
                        .foregroundColor(Color.black)
                        .frame(width: 200)
                        .padding(.vertical, 12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 2)
                        )
                }
                .padding(.top)
                
            } else {
                Text("Loading")
            }
            Spacer()
        }
        .padding(.horizontal, 16)
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
