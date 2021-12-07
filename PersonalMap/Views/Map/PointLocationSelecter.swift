import SwiftUI
import MapKit

protocol PointLocationSelecterDelegate {
    func getLocation(latitude: Double, longitude: Double)
}

struct PointLocationSelecter: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var mapType: MKMapType = MKMapType.standard
    let delegate: PointLocationSelecterDelegate?
    
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
                        guard let latitude = latitude,
                              let longitude = longitude else {
                                  return
                              }
                        delegate?.getLocation(latitude: latitude, longitude: longitude)
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

struct PointLocationSelecter_Previews: PreviewProvider {
    static var previews: some View {
        PointLocationSelecter(delegate: nil)
    }
}
