import SwiftUI
import MapKit


enum XXX: Identifiable {
    var id: UUID {
        switch self {
        case let .abc(id):
            return id
        }
    }
    
    case abc(UUID)
}

struct TopView: View {
    @State var mapObjects: [MapObject] = [
        MapObject.point(MapPoint(isHidden: false, layerName: "鉄塔1", location: CLLocationCoordinate2D(latitude: 37.79161001928914, longitude: 138.08886667811578), infos: [])),
        MapObject.point(MapPoint(isHidden: false, layerName: "鉄塔2", location: CLLocationCoordinate2D(latitude: 35.79161001928914, longitude: 136.08886667811578), infos: []))]
    @State var mapType: MKMapType = MKMapType.standard
    @State var xxx: XXX?
    
    var body: some View {
        ZStack(alignment: .top) {
            MapObjectView(mapObjects: $mapObjects, mapType: $mapType) { mapObjectId in
                // self.mapObjectId = mapObjectId
                xxx = XXX.abc(mapObjectId)
            }
            .ignoresSafeArea()
        }
        .sheet(item: $xxx, onDismiss: {
            
        }, content: { item in
            switch item {
            case let .abc(id):
                MapObjectDetailView(mapObjectId: id)
            }
        })
        .onAppear {
            print("OnAppear")
        }
    }
    
    func xxxx() {
        
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
