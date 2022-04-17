import SwiftUI

class AddMapPolylineViewState: ObservableObject {
    let mapLayerId: UUID
    
    @Published var labelName: String = ""
    @Published var symbolName: String = "star.circle"
    @Published var coordinates: [Coordinate] = []
    @Published var items: [Item] = []
    @Published var message: String = ""
    @Published var showingAlert: Bool = false
    @Published var dismiss: Bool = false
    
    init(mapLayerId: UUID) {
        self.mapLayerId = mapLayerId
    }
    
    func savePolyLine() {
        if labelName.isEmpty {
            message = "ラベル名が入力されていません"
            showingAlert = true
            return
        }
        
        print(coordinates)
        
        if coordinates.count < 2 {
            message = "位置情報を二点以上入力してください"
            showingAlert = true
            return
        }
        
        let mapObject: MapObject = .polyLine(MapPolyLine(id: UUID(), imageName: symbolName, isHidden: false, objectName: labelName, coordinates: coordinates, items: items))
        
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
    }
}
