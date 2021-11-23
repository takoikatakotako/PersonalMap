import SwiftUI


struct AddMapPolygonObjectView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let mapLayerId: UUID
    @State var objectName: String = ""
    @State var showingSheet = false
    @State var coordinates: [Coordinate] = []
    
    var body: some View {
        VStack {
            Text("Polygonオブジェクト名")
                .font(Font.system(size: 20).bold())
                .padding(.top, 16)
            TextField("オブジェクト名を入力してください", text: $objectName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button {
                showingSheet = true
            } label: {
                Text("位置情報を設定")
            }
            
            ForEach(coordinates, id: \.self) { coordinate in  // プロパティcodeをidの代わりに指定
                Text("緯度: \(coordinate.latitude.description)")
                Text("軽度: \(coordinate.longitude.description)")
            }
            
            Button {
                // Polygon
                let polygon: MapPolygon = MapPolygon(id: UUID(), mapObjectType: .polygon, imageName: "star.circle", isHidden: false, objectName: objectName, coordinates: coordinates, items: [])
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
            } label: {
                Text("Polygonを追加")
            }
        }
        .sheet(isPresented: $showingSheet) {
            // on dissmiss
        } content: {
            PolylineAndPolygonLocationSelecter(delegate: self)
        }
    }
}

extension AddMapPolygonObjectView: PolylineAndPolygonLocationSelecterDelegate {
    func getCoordinates(coordinates: [Coordinate]) {
        self.coordinates = coordinates
    }
}
