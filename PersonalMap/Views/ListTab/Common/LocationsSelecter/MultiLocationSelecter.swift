import SwiftUI
import MapKit

struct MultiLocationSelecter: View {
    @Binding var coordinates: [Coordinate]
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var mapType: MKMapType = MKMapType.standard
    @State private var location: CLLocationCoordinate2D?
    @State private var locations: [CLLocationCoordinate2D] = []
    @State private var mapObjects: [MapObject] = []
    
    var body: some View {
        ZStack(alignment: .bottom) {
            LocationSelecterView(locations: locations, mapObjects: $mapObjects) { location in
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

//struct LocationsSelecterView_Previews: PreviewProvider {
//    static var previews: some View {
//        PolylineAndPolygonLocationSelecter(delegate: nil)
//    }
//}
