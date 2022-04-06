import SwiftUI

class MapObjectListViewState: ObservableObject {
 
    @Published var showingSheet = false
    @Published var mapObjects: [MapObject] = []

    let mapLayer: MapLayer
    
    private let fileRepository = FileRepository()

    init(mapLayer: MapLayer) {
        self.mapLayer = mapLayer
    }
    
    func onAppear() {
        try? getMapPointObjects()
    }
    
    func rowRemove(offsets: IndexSet) {
        let deletedMapObjectIds: [UUID] = offsets.map { mapObjects[$0].id }
        try! deleteMapObjects(deletedMapObjectIds: deletedMapObjectIds)
        mapObjects.remove(atOffsets: offsets)
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

