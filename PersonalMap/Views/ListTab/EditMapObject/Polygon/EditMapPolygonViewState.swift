import SwiftUI

class EditMapPolygonViewState: ObservableObject {
    @Published var polygon: MapPolygon
    @Published var showingAlert: Bool = false
    @Published var message: String = ""
    @Published var dismiss: Bool = false
    
    private let fileRepository = FileRepository()
    
    init(polygon: MapPolygon) {
        self.polygon = polygon
    }
        
    func savePolygon() {
        do {
            try fileRepository.saveMapObject(mapObject: .polygon(polygon))
            dismiss = true
        } catch {
            message = "保存に失敗しました"
            showingAlert = true
        }
    }
}
