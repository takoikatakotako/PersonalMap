import SwiftUI

struct MapPolyLinePreview: View {
    let polyline: MapPolyline
    @Binding var route: Route?

    @Environment(\.dismiss) var dismiss
    @State var showingAlert = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ObjectNamePreview(objectName: polyline.objectName)
                    
                    ObjectLocationsPreview(coordinates: polyline.coordinates, routeButtonTapped: { coordinate in
                        if let myCoordinate = LocationManager.shared.lastKnownLocation?.coordinate {
                            route = Route(source: myCoordinate.locationCoordinate2D, destination: coordinate.locationCoordinate2D)
                            dismiss()
                        } else {
                            showingAlert = true
                        }
                    })
                    
                    ObjectItemsPreview(items: polyline.items)
                }
            }
            .alert("エラー", isPresented: $showingAlert) {
                Button("閉じる", role: .cancel) {}
            } message: {
                Text("現在の座標を取得できませんでした。権限を確認してください")
            }
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("ポリライン詳細")
        }
    }
}

//struct MapPolyLinePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolyLinePreview()
//    }
//}
