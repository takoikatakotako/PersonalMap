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

struct TopView: View {
    @State var mapObjects: [MapObject] = []
    @State var mapType: MKMapType = .standard
    @State var sheet: TopSheetItem?
        
    var body: some View {
        ZStack(alignment: .top) {
            MapObjectView(mapObjects: $mapObjects, mapType: $mapType) { mapObjectId in
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
                MapObjectPreview(mapObjectId: id)
            }
        })
        .onAppear {
            let fileRepository = FileRepository()
            try! fileRepository.initialize()
            let mapLayers: [MapLayer] = try! fileRepository.getMapLyers()

            for mapLayer in mapLayers {
                for mapObjectId in mapLayer.objectIds {
                    let mapObject: MapObject = try! fileRepository.getMapObject(mapObjectId: mapObjectId)
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
