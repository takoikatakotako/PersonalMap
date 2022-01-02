import SwiftUI

struct AddMapPointObjectView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let mapLayerId: UUID
    @State private var labelName: String = ""
    @State private var symbolName: String = "star.circle"
    @State private var longitude: String = ""
    @State private var latitude: String = ""
    @State private var items: [Item] = []
    
    @State private var sheet: AddMapObjectSheet?
    @State private var message: String = ""
    @State private var showingAlert: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    AddMapObjectLabelTextField(labelName: $labelName)
                    
                    AddMapObjectSymbolSelecter(symbolName: symbolName, sheet: $sheet)
                    
                    AddMapObjectSingleLocationSelecter(latitude: $latitude, longitude: $longitude, sheet: $sheet)
                    
                    AddMapObjectItems(items: items, sheet: $sheet)
                }
            }
            .sheet(item: $sheet, onDismiss: {
                
            }, content: { item in
                switch item {
                case .symbol:
                    SymbolSelecter(delegate: self)
                case .location:
                    PointLocationSelecter(delegate: self)
                case .item:
                    ItemListView(items: $items)
                }
            })
            .alert(isPresented: $showingAlert)  {
                Alert(title: Text(""), message: Text(message), dismissButton: .default(Text("閉じる")))
            }
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("ポイントの新規登録")
            .navigationBarItems(
                trailing:
                    Button(action: {
                        savePoint()
                    }, label: {
                        Text("登録")
                            .font(Font.system(size: 16).bold())
                    })
            )
        }
    }
    
    private func savePoint() {
        if labelName.isEmpty {
            message = "ラベル名が入力されていません"
            showingAlert = true
            return
        }
        
        if latitude.isEmpty || longitude.isEmpty {
            message = "緯度、経度が入力されていません"
            showingAlert = true
            return
        }
        
        guard let latitude = Double(latitude),
              let longitude = Double(longitude),
              0 <= latitude && latitude <= 180,
              0 <= longitude && longitude <= 180 else {
                  message = "不正な緯度経度が入力されています"
                  showingAlert = true
                  return
              }
        
        let mapObject: MapObject = .point(MapPoint(id: UUID(), imageName: symbolName, isHidden: false, objectName: labelName, coordinate: Coordinate(latitude: latitude, longitude: longitude), items: items))
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

extension AddMapPointObjectView: SymbolSelecterDelegate {
    func symbolSelected(symbolName: String) {
        self.symbolName = symbolName
    }
}

extension AddMapPointObjectView: PointLocationSelecterDelegate {
    func getLocation(latitude: Double, longitude: Double) {
        self.latitude = latitude.description
        self.longitude = longitude.description
    }
}


struct AddMapPointObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapPointObjectView(mapLayerId: UUID())
    }
}
