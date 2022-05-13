import SwiftUI
import MapKit

struct LocationSelecter: View {
    @Binding var latitudeString: String
    @Binding var longitudeString: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var mapType: MKMapType = MKMapType.standard
    @State private var mapObjects: [MapObject] = []
    @State private var latitude: Double?
    @State private var longitude: Double?
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LocationSelecterView(mapObjects: $mapObjects) { location in
                latitude = location.latitude
                longitude = location.longitude
            }
            .ignoresSafeArea()
            
            HStack {
                VStack(alignment: .leading) {
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
        .onAppear {

            var updatedMapObjects: [MapObject] = []

            let fileRepository = FileRepository()
            let mapLayers: [MapLayer] = try! fileRepository.getMapLyers()
            for mapLayer in mapLayers {
                for mapObjectId in mapLayer.objectIds {
                    let mapObject: MapObject = try! fileRepository.getMapObject(mapObjectId: mapObjectId)
                    updatedMapObjects.append(mapObject)
                }
            }
            
            // 差分がある場合は更新する
            if mapObjects != updatedMapObjects {
                mapObjects = updatedMapObjects
            }
        }
    }
}

//struct PointLocationSelecter_Previews: PreviewProvider {
//    static var previews: some View {
//        PointLocationSelecter(delegate: nil)
//    }
//}
