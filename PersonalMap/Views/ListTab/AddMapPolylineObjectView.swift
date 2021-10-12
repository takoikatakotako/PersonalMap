import SwiftUI
import MapKit

struct AddMapPolylineObjectView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let mapLayerId: UUID
    @State var objectName: String = ""
    @State var showingSheet = false
    @State var coordinates: [Coordinate] = []
    
    var body: some View {
        VStack {
            Text("PolyLineオブジェクト名")
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
                // PolyLine
                let polyLine: MapPolyLine = MapPolyLine(id: UUID(), mapObjectType: .polyLine, imageName: "star.circle", isHidden: false, objectName: objectName, coordinates: coordinates, infos: [])
                let mapObject: MapObject = .polyLine(polyLine)
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
                Text("PolyLineを追加")
            }
        }
        .sheet(isPresented: $showingSheet) {
            // on dissmiss
        } content: {
            // LocationSelecterView(delegate: self)
            PolylineAndPolygonLocationSelecter(delegate: self)
        }
    }
}

extension AddMapPolylineObjectView: PolylineAndPolygonLocationSelecterDelegate {
    func getCoordinates(coordinates: [Coordinate]) {
        self.coordinates = coordinates
    }
}

struct AddMapPolylineObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapPolylineObjectView(mapLayerId: UUID())
    }
}
