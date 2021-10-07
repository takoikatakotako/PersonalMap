import SwiftUI
import MapKit

protocol PointLocationSelecterDelegate {
    func getLocation(latitude: Double, longitude: Double)
}

struct PointLocationSelecter: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var mapType: MKMapType = MKMapType.standard
    
    let delegate: PointLocationSelecterDelegate?
    
    var body: some View {
        ZStack(alignment: .top) {
            MultiLocationSelecterView(mapType: $mapType) { locations in
                // delegate?.getLocation(latitude: location.latitude, longitude: location.longitude)
                // presentationMode.wrappedValue.dismiss()
            }
            .ignoresSafeArea()
        }
    }
}

struct LocationSelecterView_Previews: PreviewProvider {
    static var previews: some View {
        PointLocationSelecter(delegate: nil)
    }
}
