import SwiftUI

class EditMapPolylineViewState: ObservableObject {
    @Published var polyline: MapPolyLine
    @Published var showingAlert: Bool = false
    @Published var message: String = ""
    @Published var dismiss: Bool = false
    
    private let fileRepository = FileRepository()
    
    init(polyLine: MapPolyLine) {
        self.polyline = polyLine
    }
    
    func savePolyline() {
        if polyline.objectName.isEmpty {
            message = "ラベル名が入力されていません"
            showingAlert = true
            return
        }
                
        if polyline.coordinates.count < 2 {
            message = "位置情報を二点以上入力してください"
            showingAlert = true
            return
        }
        
        try! fileRepository.saveMapObject(mapObject: MapObject.polyLine(polyline))

        dismiss = true
    }
}
