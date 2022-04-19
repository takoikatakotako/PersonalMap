import SwiftUI

struct MapPolygonPreview: View {
    let polygon: MapPolygon
    let delegate: MapObjectPreviewViewDelegate?

    @Environment(\.presentationMode) var presentationMode
    @State var showingAlert = false

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ObjectNamePreview(objectName: polygon.objectName)
                    
                    ObjectLocationsPreview(coordinates: polygon.coordinates, routeButtonTapped: { coordinate in
                        if let myCoordinate = LocationManager.shared.lastKnownLocation?.coordinate {
                            delegate?.showRoute(source: myCoordinate, destination: coordinate)
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showingAlert = true
                        }
                    })
                    
                    ObjectItemsPreview(items: polygon.items)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("エラー"),
                      message: Text("現在の座標を取得できませんでした。権限を確認してください"),
                      dismissButton: .default(Text("閉じる")))
            }
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("エリア詳細")
        }
        
    }
}
//
//struct MapPolygonPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolygonPreview()
//    }
//}
