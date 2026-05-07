import SwiftUI

class AddMapLayerViewState: ObservableObject {
    @Published var layerName: String = ""
    @Published var layerTypeIndex = 0
    @Published var dismiss: Bool = false
    @Published var errorMessage: String?

    private let fileRepository = FileRepository()

    func save() {
        let layerType: MapObjectType
        switch layerTypeIndex {
        case 0: layerType = .point
        case 1: layerType = .polyLine
        default: layerType = .polygon
        }

        let newMapLayer = MapLayer(id: UUID(), layerName: layerName, mapObjectType: layerType, objectIds: [])
        do {
            try fileRepository.saveMapLayer(mapLayer: newMapLayer)
            dismiss = true
        } catch {
            errorMessage = "保存に失敗しました"
        }
    }
}
