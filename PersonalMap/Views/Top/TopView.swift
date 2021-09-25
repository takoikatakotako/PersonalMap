import SwiftUI
import MapKit

struct TopView: View {
    @State var mapObjects: [MapObject] = [MapObject.polyLine(MapPolyLine(isHidden: false, layerName: "s,. 0 llll;pss", locations: [CLLocationCoordinate2D(latitude: 37.79161001928914, longitude: 138.08886667811578), CLLocationCoordinate2D(latitude: 39.095964742457284, longitude: 138.14824213200006)], infos: []))]
    // MapObject.point(MapPoint(isHidden: false, layerName: "sss", location: CLLocationCoordinate2D(latitude: 37.79161001928914, longitude: 138.08886667811578), infos: []))
    @State var mapType: MKMapType = MKMapType.standard
        
    var body: some View {
        ZStack(alignment: .top) {
            MapView(mapObjects: $mapObjects, mapType: $mapType) { location in
                print(location)
            }
            .ignoresSafeArea()
        }
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
