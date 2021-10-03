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
    @State var mapObjects: [MapObject] = []
    @State var mapType: MKMapType = MKMapType.standard
    @State var xxx: XXX?
        
    var body: some View {
        ZStack(alignment: .top) {
            MapObjectView(mapObjects: $mapObjects, mapType: $mapType) { mapObjectId in
                xxx = XXX.abc(mapObjectId)
            }
            .ignoresSafeArea()
        }
        .sheet(item: $xxx, onDismiss: {
            
        }, content: { item in
            switch item {
            case let .abc(id):
                MapObjectPreview(mapObjectId: id)
            }
        })
        .onAppear {
            let fileRepository = FileRepository()
            try! fileRepository.initialize()
            let mapLayers: [MapLayer] = try! fileRepository.getMapLyers()

            for mapLayer in mapLayers {
                for objectId in mapLayer.objectIds {
                    let mapObject: MapObject = try! fileRepository.getMapObject(mapObjectId: objectId)
                    mapObjects.append(mapObject)
                }
            }
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
