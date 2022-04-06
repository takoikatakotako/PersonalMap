import SwiftUI

class MapLayerListViewState: ObservableObject {
    @Published var mapLayers: [MapLayer] = []
    @Published var showingSheet = false

    private let fileRepository = FileRepository()

    
    func plusTapped() {
        showingSheet = true
    }
    
    func sheetDissmiss() {
        
    }
    
    func rowRemove(offsets: IndexSet) {
        let deleteLayerIds: [UUID] = offsets.map { mapLayers[$0].id }
        for deleteLayerId in deleteLayerIds {
            try! fileRepository.deleteMapLayer(mapLayerId: deleteLayerId)
        }
        mapLayers.remove(atOffsets: offsets)
    }
    
    func onAppear() {
        try! fileRepository.initialize()
        let mapLayers = try! fileRepository.getMapLyers()
        self.mapLayers = mapLayers
    }
}
