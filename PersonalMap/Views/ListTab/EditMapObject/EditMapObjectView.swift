import SwiftUI

struct EditMapObjectView: View {

    @State var viewState: EditMapObjectViewState
    
    init (mapObject: MapObject) {
        viewState = EditMapObjectViewState(mapObject: mapObject)
    }
    
    var body: some View {
        switch viewState.mapObject {
        case .point(let point):
            return AnyView(EditMapPointView(point: point))
        case .polyLine(let polyLine):
            return AnyView(EditMapPolylineView(polyLine: polyLine))
        case .polygon(let polygon):
            return AnyView(EditMapPolygonView(polygon: polygon))
        }
    }
}

//struct MapPointDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectDetail(, mapObject: )
//    }
//}
