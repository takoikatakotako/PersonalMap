import SwiftUI
import MapKit

struct TopView: View {
    @State var mapObjects: [MapObject] = []
    @State var mapType: MKMapType = MKMapType.standard
        
    var body: some View {
        ZStack(alignment: .top) {
            MapView(mapObjects: $mapObjects, mapType: $mapType) { location in
                print(location)
            }
            .ignoresSafeArea()
        }
    }
}

struct TopView_Previews: PreviewProvider {
    static var previews: some View {
        TopView()
    }
}
