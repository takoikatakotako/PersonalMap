import SwiftUI
import MapKit

enum TopSheetItem: Identifiable {
    var id: UUID {
        switch self {
        case let .showMapObject(id):
            return id
        }
    }
    case showMapObject(UUID)
}


struct Route {
    let source: CLLocationCoordinate2D
    let destination: CLLocationCoordinate2D
}

struct TopView: View {
    @State var mapObjects: [MapObject] = []
    @State var mapType: MKMapType = .standard
    @State var route: Route?
    @State var sheet: TopSheetItem?
    let locationFetcher = LocationFetcher()
    
    var body: some View {
        ZStack(alignment: .top) {
            MapObjectView(mapObjects: $mapObjects, mapType: $mapType, route: $route) { mapObjectId in
                sheet = TopSheetItem.showMapObject(mapObjectId)
            }
            .ignoresSafeArea()
            
            HStack {
                Button {
                    mapType = .standard
                } label: {
                    CommonButton(systemName: "car", active: mapType == .standard)
                }

                Button {
                    mapType = .satellite
                } label: {
                    CommonButton(systemName: "airplane", active: mapType == .satellite)
                }
            }
        }
        .sheet(item: $sheet, onDismiss: {
            
        }, content: { item in
            switch item {
            case let .showMapObject(id):
                MapObjectPreview(mapObjectId: id, delegate: self)
            }
        })
        .onAppear {
            let fileRepository = FileRepository()
            try! fileRepository.initialize()
            let mapLayers: [MapLayer] = try! fileRepository.getMapLyers()
            
            if !mapObjects.isEmpty {
                mapObjects = []
            }

            for mapLayer in mapLayers {
                for mapObjectId in mapLayer.objectIds {
                    let mapObject: MapObject = try! fileRepository.getMapObject(mapObjectId: mapObjectId)
                    mapObjects.append(mapObject)
                }
            }
            
            locationFetcher.start()
        }
    }
}


extension TopView: MapObjectPreviewDelegate {
    func xxx() {
        print("XXXX")
        route = Route(source: CLLocationCoordinate2D(latitude: 35.6896, longitude: 139.7006), destination: CLLocationCoordinate2D(latitude: 35.6984, longitude: 139.7731))
    }
}


struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
