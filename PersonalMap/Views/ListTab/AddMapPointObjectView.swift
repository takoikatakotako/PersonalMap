import SwiftUI

struct AddMapPointObjectView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let mapLayerId: UUID
    @State var objectName: String = ""
    @State var showingSheet = false
    @State var longitude: Double?
    @State var latitude: Double?
    
    var body: some View {
        VStack {
            Text("ポイントオブジェクト名")
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
            
            Text("緯度: \(latitude?.description ?? "???")")
            Text("軽度: \(longitude?.description ?? "???")")
            
            
            Button {
                // point を保存
                let mapObject: MapObject = .point(MapPoint(id: UUID(), imageName: "star.circle", isHidden: false, objectName: objectName, coordinate: Coordinate(latitude: latitude!, longitude: longitude!), infos: []))
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
                Text("ポイントを追加")
            }
        }
        .sheet(isPresented: $showingSheet) {
            // on dissmiss
        } content: {
            PointLocationSelecter(delegate: self)
        }
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
