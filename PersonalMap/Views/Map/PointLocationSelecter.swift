import SwiftUI
import MapKit

protocol PointLocationSelecterDelegate {
    func getLocation(latitude: Double, longitude: Double)
}

struct PointLocationSelecter: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var mapType: MKMapType = MKMapType.standard
    @State var location: CLLocationCoordinate2D?
    let delegate: PointLocationSelecterDelegate?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LocationSelecterView(mapType: $mapType) { location in
                self.location = location
            }
            .ignoresSafeArea()
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                
                Button {
                    guard let location = location else {
                        return
                    }
                    delegate?.getLocation(latitude: location.latitude, longitude: location.longitude)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("OK")
                }
            }
        }
    }
}

struct PointLocationSelecter_Previews: PreviewProvider {
    static var previews: some View {
        PointLocationSelecter(delegate: nil)
    }
}
