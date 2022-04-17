import SwiftUI

struct MapObjectDetailView: View {
    
    // @State var mapObject: MapObject
    
    
    @State var viewState: MapObjectDetailViewState
    
    init (mapObject: MapObject) {
        viewState = MapObjectDetailViewState(mapObject: mapObject)
    }
    
    let systemNamesArray: [[String]] = [
        ["star.circle", "parkingsign.circle", "checkmark.circle", "hand.point.up.left", "photo.circle", "fork.knife.circle", "takeoutbag.and.cup.and.straw", "car.circle", "building.2.crop.circle", "location.north.line"],
        ["circle.square", "mappin", "bolt.circle", "bolt.horizontal.circle", "wifi.circle", "hand.raised.circle", "exclamationmark.triangle", "point.3.connected.trianglepath.dotted", "arrowtriangle.left.and.line.vertical.and.arrowtriangle.right", "0.circle"],
        ["1.circle", "2.circle", "3.circle", "4.circle", "5.circle", "6.circle", "7.circle", "8.circle", "9.circle", "10.circle"],
    ]
    
    var body: some View {
        switch viewState.mapObject {
        case .point(let point):
            return AnyView(MapPointDetailView(point: point))
        case .polyLine(let polyLine):
            return AnyView(MapPolylineDetailView(polyline: polyLine, systemNamesArray: systemNamesArray))
        case .polygon(let polygon):
            return AnyView(MapPolygonDetailView(polygon: polygon, systemNamesArray: systemNamesArray))
        }
    }
}

//struct MapPointDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectDetail(, mapObject: )
//    }
//}
