import SwiftUI
import MapKit

struct LocationSelecterBindingCoordinate: View {
    @Binding var coordinate: Coordinate
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var mapType: MKMapType = MKMapType.standard
    @State private var latitude: Double?
    @State private var longitude: Double?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LocationSelecterView() { location in
                latitude = location.latitude
                longitude = location.longitude
            }
            .ignoresSafeArea()
            
            HStack {
                VStack {
                    if let latitude = latitude,
                       let longitude = longitude {
                        Text("緯度: \(latitude)")
                        Text("経度: \(longitude)")
                    }
                }
                .frame(width: 200, alignment: .leading)
                
                Spacer()
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    
                    Button {
                        guard let latitude = latitude, let longitude = longitude else {
                            return
                        }
                        coordinate = Coordinate(latitude: latitude, longitude: longitude)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("OK")
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
    }
}
