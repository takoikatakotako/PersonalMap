import SwiftUI

class MapObjectListViewState: ObservableObject {
    var mapLayer: MapLayer
    
    @Published var showingSheet = false
    @Published var mapObjects: [MapObject] = []
    @Published var errorMessage: String?
    
    private let fileRepository = FileRepository()
    
    var navigationTitle: String {
        let objectType: String
        switch mapLayer.mapObjectType {
        case .point:
            objectType = "ポイント"
        case .polyLine:
            objectType = "ライン"
        case .polygon:
            objectType = "エリア"
        }
        return "(\(objectType))\(mapLayer.layerName)"
    }
    
    
    init(mapLayer: MapLayer) {
        self.mapLayer = mapLayer
    }
    
    func onAppear() {
        try? getMapPointObjects()
    }
    
    func rowMove(fromOffsets: IndexSet, toOffset: Int) {
        mapObjects.move(fromOffsets: fromOffsets, toOffset: toOffset)
        mapLayer.objectIds = mapObjects.map { $0.id }
        do { try fileRepository.saveMapLayer(mapLayer: mapLayer) }
        catch { errorMessage = "保存に失敗しました" }
    }

    func rowRemove(offsets: IndexSet) {
        let deletedMapObjectIds: [UUID] = offsets.map { mapObjects[$0].id }
        do {
            try deleteMapObjects(deletedMapObjectIds: deletedMapObjectIds)
            mapObjects.remove(atOffsets: offsets)
        } catch {
            errorMessage = "削除に失敗しました"
        }
    }
    
    func sheetDissmiss() {
        try? getMapPointObjects()
    }
    
    func plusTapped() {
        showingSheet = true
    }
    
    private func getMapPointObjects() throws {
        let mapLayer = try fileRepository.getMapLayer(mapLayerId: mapLayer.id)
        mapObjects = try fileRepository.getMapObjects(mapObjectIds: mapLayer.objectIds)
    }
    
    private func deleteMapObjects(deletedMapObjectIds: [UUID]) throws {
        var mapLayer: MapLayer = try fileRepository.getMapLayer(mapLayerId: mapLayer.id)
        
        // 削除された MapObjectId を MapLayer から削除
        for deletedMapObjectId in deletedMapObjectIds {
            if let index = mapLayer.objectIds.firstIndex(of: deletedMapObjectId) {
                mapLayer.objectIds.remove(at: index)
            }
        }
        try fileRepository.saveMapLayer(mapLayer: mapLayer)
        
        // MapObject を削除
        for deletedMapObjectId in deletedMapObjectIds {
            try fileRepository.deleteMapObject(mapObjectId: deletedMapObjectId)
        }
    }
}

