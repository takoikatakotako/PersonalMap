import SwiftUI

struct MapPointPreview: View {
    let point: MapPoint
    @Binding var route: Route?
    
    @Environment(\.presentationMode) var presentationMode
    @State var showingAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ObjectNamePreview(objectName: point.objectName)
                    
                    ObjectLocationPreview(latitude: point.coordinate.latitude, longitude: point.coordinate.longitude, routeButtonTapped: {
                        if let coordinate = LocationManager.shared.lastKnownLocation?.coordinate {
                            route = Route(source: coordinate.locationCoordinate2D, destination: point.coordinate.locationCoordinate2D)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showingAlert = true
                        }
                    })
                    
                    ObjectItemsPreview(items: point.items)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("エラー"),
                      message: Text("現在の座標を取得できませんでした。権限を確認してください"),
                      dismissButton: .default(Text("閉じる")))
            }
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("ポイント詳細")
        }
    }
}

//struct MapPointPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPointPreview(point: <#MapPoint#>)
//    }
//}
