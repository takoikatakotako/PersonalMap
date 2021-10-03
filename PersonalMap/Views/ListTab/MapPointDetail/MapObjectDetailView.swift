import SwiftUI

struct MapObjectDetailView: View {

    @State var mapObject: MapObject
    
    var body: some View {
        getAnyMapObjectDetailView()
    }
    
    func getAnyMapObjectDetailView() -> AnyView {
        switch mapObject {
        case .point(let point):
            return AnyView(MapPointDetailView(point: point))
        case .polyLine(let polyLine):
            return AnyView(MapPolylineDetailView(polyline: polyLine))
        case .polygon(let polygon):
            return AnyView(MapPolygonDetailView(polygon: polygon))
        }
    }
}

//struct MapPointDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectDetail(, mapObject: )
//    }
//}
