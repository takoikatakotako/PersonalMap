import SwiftUI

struct AddMapPolygonObjectView: View {
    let mapLayerId: UUID
    @State private var labelName: String = ""
    @State private var symbolName: String = "star.circle"
    @State private var coordinates: [Coordinate] = []
    @State private var items: [Item] = []
    @State private var message: String = ""
    @State private var showingAlert: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    MapObjectLabelTextField(labelName: $labelName)
                    
                    MapObjectSymbolSelecter(symbolName: $symbolName)

                    VStack(alignment: .leading) {
                        Text("位置情報を選択")
                            .font(Font.system(size: 20).bold())
                            .padding(.top, 12)
                                                
                        ForEach(coordinates.indices, id: \.self) { index in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("latitude: \(coordinates[index].latitude.description)")
                                    Text("latitude: \(coordinates[index].longitude.description)")
                                }
                                Spacer()
                                
                                Button {
                                    // sheet = .editLocations(index: index)
                                } label: {
                                    Text("編集")
                                }
                            }
                            Divider()
                         }
                        
                        HStack {
                            Spacer()
                            Button {
                                // sheet = .locations
                            } label: {
                                Text("位置情報を設定")
                            }
                        }
                    }
                    
                    
                    MapObjectItems(items: $items)
                }
            }
//            .sheet(item: $sheet, onDismiss: {
//
//            }, content: { item in
//                switch item {
//                case .locations:
//                    PolylineAndPolygonLocationSelecter(delegate: self)
//                case .editLocations(let index):
//                    AddMapObjectEditLocation(coordinates: $coordinates, index: index)
//                }
//            })
            .alert(isPresented: $showingAlert)  {
                Alert(title: Text(""), message: Text(message), dismissButton: .default(Text("閉じる")))
            }
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("エリアの新規登録")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        savePolygon()
                    }, label: {
                        Text("登録")
                            .font(Font.system(size: 16).bold())
                    })
            )
        }
    }
    
    private func savePolygon() {
        if labelName.isEmpty {
            message = "ラベル名が入力されていません"
            showingAlert = true
            return
        }
        
        if coordinates.count < 2 {
            message = "緯度、経度が入力されていません"
            showingAlert = true
            return
        }
        
        
        // Polygon
        let polygon: MapPolygon = MapPolygon(id: UUID(), mapObjectType: .polygon, imageName: symbolName, isHidden: false, objectName: labelName, coordinates: coordinates, items: [])
        let mapObject: MapObject = .polygon(polygon)
        let fileRepository = FileRepository()
        try! fileRepository.initialize()
        try! fileRepository.saveMapObject(mapObject: mapObject)

        // layer に追加
        let mapLayer = try! fileRepository.getMapLayer(mapLayerId: mapLayerId)
        let newMapLayer = MapLayer(
            id: mapLayer.id,
            layerName: mapLayer.layerName,
            mapObjectType: mapLayer.mapObjectType,
            objectIds: [mapObject.id] + mapLayer.objectIds)
        try! fileRepository.saveMapLayer(mapLayer: newMapLayer)
        presentationMode.wrappedValue.dismiss()
    }
}
