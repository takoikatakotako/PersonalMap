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
        let fileRepository = FileRepository()
        try! fileRepository.saveMapObject(mapObject: .polygon(polygon))
        
        dismiss = true
    }
}
