import SwiftUI

class EditMapPointViewState: ObservableObject {
    @Published var point: MapPoint
    @Published var latitudeString: String
    @Published var longnitudeString: String
    @Published var showingAlert: Bool = false
    @Published var message: String = ""
    @Published var dismiss: Bool = false

    private let fileRepository = FileRepository()

    init(point: MapPoint) {
        self.point = point
        latitudeString = point.coordinate.latitude.description
        longnitudeString = point.coordinate.longitude.description
    }
        
    func update() {
        guard let latitude = Double(latitudeString), let longnitude = Double(longnitudeString) else {
            message = "緯度と経度には数字を入力してください。"
            showingAlert = true
            return
        }
        
        point.coordinate = Coordinate(latitude: latitude, longitude: longnitude)
        try! fileRepository.saveMapObject(mapObject: MapObject.point(point))
        
        dismiss = true
    }
}
