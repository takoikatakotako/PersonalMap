import SwiftUI


protocol MapObjectPreviewDelegate {
    func xxx()
}

struct MapObjectPreview: View {
    let mapObjectId: UUID
    let delegate: MapObjectPreviewDelegate?
    @State var mapObject: MapObject?
    
    var body: some View {
        VStack {
            if let mapObject = mapObject {
                getPreview(mapObject: mapObject)
            } else {
                Text("Loading")
            }
        }.onAppear {
            let fileRepository = FileRepository()
            mapObject = try! fileRepository.getMapObject(mapObjectId: mapObjectId)
        }
    }
    
    func getPreview(mapObject: MapObject) -> AnyView {
        switch mapObject {
        case .point(let point):
            return AnyView(MapPointPreview(point: point, delegate: delegate))
        case .polyLine(let polyLine):
            return AnyView(MapPolyLinePreview(polyline: polyLine))
        case .polygon(let polygon):
            return AnyView(MapPolygonPreview(polygon: polygon))
        }
    }
}

struct MapObjectPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        MapObjectPreview(mapObjectId: UUID(), delegate: nil)
    }
}
