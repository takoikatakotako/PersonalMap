import SwiftUI
import MapKit

protocol PolylineAndPolygonLocationSelecterDelegate {
    func getCoordinates(coordinates: [Coordinate])
}

struct PolylineAndPolygonLocationSelecter: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var mapType: MKMapType = MKMapType.standard
    @State var coordinates: [Coordinate]?
    let delegate: PolylineAndPolygonLocationSelecterDelegate?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MultiLocationSelecterView(mapType: $mapType) { locations in
                self.coordinates = locations.map { $0.coordinate }
            }
            .ignoresSafeArea()
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                
                Button {
                    guard let coordinates = coordinates else {
                        return
                    }
                    delegate?.getCoordinates(coordinates: coordinates)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("OK")
                }
            }
        }
    }
}

struct LocationsSelecterView_Previews: PreviewProvider {
    static var previews: some View {
        PolylineAndPolygonLocationSelecter(delegate: nil)
    }
}
