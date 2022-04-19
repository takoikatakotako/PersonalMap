import SwiftUI
import MapKit

class TopViewState: ObservableObject {
    @Published var mapObjects: [MapObject] = []
    @Published var mapType: MKMapType = .standard
    @Published var route: Route?
    @Published var sheet: TopSheetItem?
    @Published var alert: TopAlertItem?

    private let fileRepository = FileRepository()
    
    func onAppear() {
        var updatedMapObjects: [MapObject] = []
        let mapLayers: [MapLayer] = try! fileRepository.getMapLyers()
        for mapLayer in mapLayers {
            for mapObjectId in mapLayer.objectIds {
                let mapObject: MapObject = try! fileRepository.getMapObject(mapObjectId: mapObjectId)
                updatedMapObjects.append(mapObject)
            }
        }
        
        if mapObjects != updatedMapObjects {
            mapObjects = updatedMapObjects
        }
    }
}

