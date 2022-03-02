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
        }
    }
    
    case routeConfirmAlert(UUID, CLLocationCoordinate2D)
}

struct TopView: View {
    @State var mapObjects: [MapObject] = []
    @State var mapType: MKMapType = .standard
    @State var route: Route?
    @State var sheet: TopSheetItem?
    @State var alert: TopAlertItem?
    @State var xxx: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            MapObjectView(mapObjects: $mapObjects, mapType: $mapType, route: $route) { mapObjectId in
                sheet = .showMapObject(mapObjectId)
                
            } longPressEnded: { location in
                // long press
                print(location)
                alert = .routeConfirmAlert(UUID(), location)
                
            } xxxxx: {
                // ここで
                xxx = true
                
                print("xxx")
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
            
            
            if xxx {
                VStack {
                    Spacer()
                    Text("ルートが見つかりませんでした。")
                    Spacer()
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
                        route = Route(source: CLLocationCoordinate2D(latitude: 35.6896, longitude: 139.7006), destination: CLLocationCoordinate2D(latitude: 35.6984, longitude: 139.7731))
                    })
                )
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
    
    
    private func xxx2() {
        DispatchQueue.main.async {
            xxx = true
            print("xxx = true")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                xxx = false
                print("xxx = false")
            }
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
