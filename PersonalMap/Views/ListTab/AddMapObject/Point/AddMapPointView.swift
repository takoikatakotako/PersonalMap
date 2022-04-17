import SwiftUI

struct AddMapPointView: View {
    let mapLayerId: UUID
    @State private var items: [Item] = []
    
    @State private var message: String = ""
    @State private var showingAlert: Bool = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    @StateObject var viewState: AddMapPointViewState = AddMapPointViewState()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    MapObjectLabelTextField(labelName: $viewState.labelName)
                    
                    MapObjectSymbolSelecter(symbolName: $viewState.symbolName)
                    
                    MapObjectSingleLocationSelecter(latitude: $viewState.latitude, longitude: $viewState.longitude)
                    
                    MapObjectItems(items: $items)
                }
            }
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
        if viewState.labelName.isEmpty {
            message = "ラベル名が入力されていません"
            showingAlert = true
            return
        }
        
        if viewState.latitude.isEmpty || viewState.longitude.isEmpty {
            message = "緯度、経度が入力されていません"
            showingAlert = true
            return
        }
        
        guard let latitude = Double(viewState.latitude),
              let longitude = Double(viewState.longitude),
              0 <= latitude && latitude <= 180,
              0 <= longitude && longitude <= 180 else {
                  message = "不正な緯度経度が入力されています"
                  showingAlert = true
                  return
              }
        
        let mapObject: MapObject = .point(MapPoint(id: UUID(), imageName: viewState.symbolName, isHidden: false, objectName: viewState.labelName, coordinate: Coordinate(latitude: latitude, longitude: longitude), items: items))
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

//extension AddMapPointView: PointLocationSelecterDelegate {
//    func getLocation(latitude: Double, longitude: Double) {
//        viewState.latitude = latitude.description
//        viewState.longitude = longitude.description
//    }
//}


struct AddMapPointObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapPointView(mapLayerId: UUID())
    }
}
