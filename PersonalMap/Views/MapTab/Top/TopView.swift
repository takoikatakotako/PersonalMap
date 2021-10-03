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
                // self.mapObjectId = mapObjectId
                xxx = XXX.abc(mapObjectId)
            }
            .ignoresSafeArea()
        }
        .sheet(item: $xxx, onDismiss: {
            
        }, content: { item in
            switch item {
            case let .abc(id):
                Text("XXXX")
                // MapObjectDetailView(mapObjectId: id)
            }
        })
        .onAppear {
            let fileRepository = FileRepository()
            try! fileRepository.initialize()
            let mapLayers: [MapLayer] = try! fileRepository.getMapLyers()

//            for mapLayer in mapLayers {
//                switch mapLayer {
//                    case .point:
//                    mapObjects.append(.point(<#T##MapPoint#>))
//                }
//            }

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
