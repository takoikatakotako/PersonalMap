import SwiftUI
import MapKit

protocol LocationSelecterDelegate {
    func getLocation(latitude: Double, longitude: Double)
}

struct LocationSelecterView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var mapObjects: [MapObject] = []
    @State var mapType: MKMapType = MKMapType.standard
    
    let delegate: LocationSelecterDelegate?
    
    var body: some View {
        ZStack(alignment: .top) {
            TapplableMapView(mapObjects: $mapObjects, mapType: $mapType) { location in
                delegate?.getLocation(latitude: location.latitude, longitude: location.longitude)
                presentationMode.wrappedValue.dismiss()
            }
            .ignoresSafeArea()
        }
    }
}

struct LocationSelecterView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSelecterView(delegate: nil)
    }
}
