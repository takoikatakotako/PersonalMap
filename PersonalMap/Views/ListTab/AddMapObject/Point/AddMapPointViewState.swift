import SwiftUI

class AddMapPointViewState: ObservableObject {
    let mapLayerId: UUID
    
    @Published var labelName: String = ""
    @Published var hidden: Bool = false
    @Published var symbolName: String = "star.circle"
    @Published var longitude: String = ""
    @Published var latitude: String = ""
    @Published var items: [Item] = []
    @Published var message: String = ""
    @Published var showingAlert: Bool = false
    @Published var dismiss: Bool = false
    
    init(mapLayerId: UUID) {
        self.mapLayerId = mapLayerId
    }
    
    func savePoint() {
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
        
        let mapObject: MapObject = .point(MapPoint(id: UUID(), imageName: symbolName, isHidden: hidden, objectName: labelName, coordinate: Coordinate(latitude: latitude, longitude: longitude), items: items))
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
        
        dismiss = true
    }
}
