import SwiftUI

class AddMapLayerViewState: ObservableObject {
    @Published var layerName: String = ""
    @Published var layerTypeIndex = 0
    @Published var dismiss: Bool = false
    
    func save() {
        var layerType: MapObjectType!
        if layerTypeIndex == 0 {
            layerType = .point
        } else if layerTypeIndex == 1 {
            layerType = .polyLine
        } else {
            layerType = .polygon
        }
        
        let newMapLayer = MapLayer(id: UUID(), layerName: layerName, mapObjectType: layerType, objectIds: [])
        let fileRepository = FileRepository()
        try! fileRepository.saveMapLayer(mapLayer: newMapLayer)
        
        dismiss = true
    }
}
