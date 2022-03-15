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


enum TopAlertItem: Identifiable {
    var id: UUID {
        switch self {
        case let .routeConfirmAlert(id, _):
            return id
        case let .messageAlert(id, _):
            return id
        }
    }
    
    case routeConfirmAlert(UUID, CLLocationCoordinate2D)
    case messageAlert(UUID, String)
}

struct TopView: View {
    @State var mapObjects: [MapObject] = []
    @State var mapType: MKMapType = .standard
    @State var route: Route?
    @State var sheet: TopSheetItem?
    @State var alert: TopAlertItem?
    
    var body: some View {
        ZStack(alignment: .top) {
            MapObjectView(mapObjects: $mapObjects, mapType: $mapType, route: $route) { mapObjectId in
                sheet = .showMapObject(mapObjectId)
            } longPressEnded: { location in
                // long press
                print(location)

                alert = .routeConfirmAlert(UUID(), location)
                
            } xxxxx: {
                // 見つからなかった
                route = nil
                alert = .messageAlert(UUID(), "ルートが見つかりませんでした")
            }
            .ignoresSafeArea(.all, edges: .top)
            
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
                MapObjectPreviewView(mapObjectId: id, delegate: self)
            }
        })
        .alert(item: $alert) { item in
            switch item {
            case let .routeConfirmAlert(_, location):
                return Alert(
                    title: Text(""),
                    message: Text("現在地から\(location.latitude), \(location.longitude)へのアクセスを表示しますか？"),
                    primaryButton: .default(Text("キャンセル")),
                    secondaryButton: .default(Text("はい"), action: {
                        
                        guard let lastKnownLocation: CLLocationCoordinate2D = LocationManager.shared.lastKnownLocation else {
                            return
                        }
                                                
                        route = Route(source: lastKnownLocation, destination: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                    })
                )
            case let .messageAlert(_, message):
                return Alert(title: Text(""), message: Text(message), dismissButton: .default(Text("閉じる")))
            }
        }
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
            
            LocationManager.shared.start()
        }
    }
}


extension TopView: MapObjectPreviewViewDelegate {
    func showRoute(source: Coordinate, destination: Coordinate) {
        print(source)
        print(destination)
        
        route = Route(source: source.locationCoordinate2D, destination: destination.locationCoordinate2D)
    }
}


struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
