import SwiftUI
import MapKit

struct MultiLocationSelecter: View {
    @Binding var coordinates: [Coordinate]
    
    @Environment(\.dismiss) var dismiss
    
    @State private var mapType: MKMapType = MKMapType.standard
    @State private var location: CLLocationCoordinate2D?
    @State private var locations: [CLLocationCoordinate2D] = []
    @State private var mapObjects: [MapObject] = []
    @State private var errorMessage: String?
    
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
                    dismiss()
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
                    dismiss()
                } label: {
                    Text("OK")
                }
              }
              .padding(.horizontal, 16)
              .padding(.bottom, 60)
        }
        .onAppear {
            do {
                var updatedMapObjects: [MapObject] = []
                let fileRepository = FileRepository()
                let mapLayers = try fileRepository.getMapLyers()
                for mapLayer in mapLayers {
                    for mapObjectId in mapLayer.objectIds {
                        let mapObject = try fileRepository.getMapObject(mapObjectId: mapObjectId)
                        updatedMapObjects.append(mapObject)
                    }
                }

                // 差分がある場合は更新する
                if mapObjects != updatedMapObjects {
                    mapObjects = updatedMapObjects
                }
            } catch {
                errorMessage = "データの読み込みに失敗しました"
            }
        }
        .alert("エラー", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("閉じる", role: .cancel) { errorMessage = nil }
        } message: {
            if let message = errorMessage { Text(message) }
        }
    }
}

//struct LocationsSelecterView_Previews: PreviewProvider {
//    static var previews: some View {
//        PolylineAndPolygonLocationSelecter(delegate: nil)
//    }
//}
