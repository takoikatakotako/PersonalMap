import SwiftUI


protocol MapObjectPreviewViewDelegate {
    func showRoute(source: Coordinate, destination: Coordinate)
}

struct MapObjectPreviewView: View {
    let mapObjectId: UUID
    let delegate: MapObjectPreviewViewDelegate?
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
            return AnyView(MapPolyLinePreview(polyline: polyLine, delegate: delegate))
        case .polygon(let polygon):
            return AnyView(MapPolygonPreview(polygon: polygon, delegate: delegate))
        }
    }
}

struct MapObjectPreviewView_Previews: PreviewProvider {
    static var previews: some View {
        MapObjectPreviewView(mapObjectId: UUID(), delegate: nil)
    }
}
