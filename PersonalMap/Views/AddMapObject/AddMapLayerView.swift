import SwiftUI

struct AddMapLayerView: View {
    
    @State var layerName: String = ""
    @State var mapLayerType: MapLayerType = .point
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("レイヤー名")
                        .font(Font.system(size: 20).bold())
                        .padding(.top, 16)
                    TextField("レイヤー名を入力してください", text: $layerName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Text("レイヤーの種類")
                        .font(Font.system(size: 20).bold())
                        .padding(.top, 16)
                    
                    HStack {
                        Button {
                            mapLayerType = .point
                        } label: {
                            Text("ポイント")
                                .foregroundColor(mapLayerType == .point ? Color.black : Color.gray)
                        }

                        Button {
                            mapLayerType = .polyLine
                        } label: {
                            Text("ライン")
                                .foregroundColor(mapLayerType == .polyLine ? Color.black : Color.gray)
                        }
                        
                        Button {
                            mapLayerType = .polygon
                        } label: {
                            Text("ポリゴン")
                                .foregroundColor(mapLayerType == .polygon ? Color.black : Color.gray)
                        }
                    }
                    
                    
                    Button {
                        let newMapLayer = MapLayer(id: UUID(), layerName: layerName, mapLayerType: mapLayerType, objectIds: [])

                        let fileRepository = FileRepository()
                        try! fileRepository.initialize()
                        try! fileRepository.saveMapLayer(mapLayer: newMapLayer)
                    } label: {
                        Text("追加")
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Mapレイヤーを追加")
        }
    }
}

struct AddMapObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapLayerView()
    }
}
