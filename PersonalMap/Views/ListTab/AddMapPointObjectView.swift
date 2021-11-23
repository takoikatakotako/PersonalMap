import SwiftUI

enum AddMapPointObjectSheet: Identifiable {
    case symbol
    case location
    case item
    var id: Int {
        hashValue
    }
}

struct AddMapPointObjectView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    let mapLayerId: UUID
    @State var objectName: String = ""
    @State private var symbolName: String = "star.circle"
    @State var sheet: AddMapPointObjectSheet?
    @State var longitude: Double?
    @State var latitude: Double?
    @State var items: [Item] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("ラベル名")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                TextField("ラベル名を入力してください", text: $objectName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Text("シンボルの選択")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                HStack {
                    Image(systemName: symbolName)
                        .resizable()
                        .foregroundColor(Color.blue)
                        .frame(width: 52, height: 52)
                        .padding(24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    Spacer()
                    Button {
                        sheet = .symbol
                    } label: {
                        Text("シンボルを設定")
                    }
                }

                Text("位置情報を選択")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("緯度: \(latitude?.description ?? "???")")
                        Text("経度: \(longitude?.description ?? "???")")
                    }
                    Spacer()
                    Button {
                        sheet = .location
                    } label: {
                        Text("位置情報を設定")
                    }
                }
                
                Text("項目の作成")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(items) { item in
                            Text("\(item.key): \(item.value)")
                        }
                    }
                    Spacer()
                    Button {
                        sheet = .item
                    } label: {
                        Text("項目を設定")
                    }
                }
                
                Spacer()
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
        let mapObject: MapObject = .point(MapPoint(id: UUID(), imageName: "star.circle", isHidden: false, objectName: objectName, coordinate: Coordinate(latitude: latitude!, longitude: longitude!), items: []))
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
        self.latitude = latitude
        self.longitude = longitude
    }
}


struct AddMapPointObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapPointObjectView(mapLayerId: UUID())
    }
}
