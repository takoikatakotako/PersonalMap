import SwiftUI
import MapKit

struct PolylineAndPolygonLocationSelecter: View {
    @Binding var coordinates: [Coordinate]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var mapType: MKMapType = MKMapType.standard
    @State private var location: CLLocationCoordinate2D?
    @State private var locations: [CLLocationCoordinate2D] = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LocationsSelecterView(locations: locations) { location in
                 self.location = location
             }
            .ignoresSafeArea()

            HStack {
                  VStack(alignment: .leading) {
                      if let location = location {
                          Text("latitude: \(location.latitude)")
                          Text("longitude: \(location.longitude)")
                      }
                  }
                  
                  Spacer()
                                  
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
                  
                  Button {
                      if let location = location {
                          locations.append(location)
                      }
                  } label: {
                      Text("Add")
                  }
                
                Button {
                    coordinates = locations.map { $0.coordinate }
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("OK")
                }
              }
              .padding(.horizontal, 16)
              .padding(.bottom, 60)
        }
    }
}

//struct LocationsSelecterView_Previews: PreviewProvider {
//    static var previews: some View {
//        PolylineAndPolygonLocationSelecter(delegate: nil)
//    }
//}
