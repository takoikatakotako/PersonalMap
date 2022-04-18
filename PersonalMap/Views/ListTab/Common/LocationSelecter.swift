import SwiftUI
import MapKit

struct LocationSelecter: View {
    @Binding var latitudeString: String
    @Binding var longitudeString: String
    
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
                        latitudeString = latitude.description
                        longitudeString = longitude.description
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

//struct PointLocationSelecter_Previews: PreviewProvider {
//    static var previews: some View {
//        PointLocationSelecter(delegate: nil)
//    }
//}
