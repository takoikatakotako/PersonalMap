import SwiftUI

struct MapPolyLinePreview: View {
    let polyline: MapPolyLine
    let delegate: MapObjectPreviewViewDelegate?

    @Environment(\.presentationMode) var presentationMode
    @State var showingAlert = false

    var body: some View {
        VStack {
            Text(polyline.objectName)
            
            ForEach(polyline.coordinates, id: \.self) { coordinate in
                Text("lat: \(coordinate.latitude), lon: \(coordinate.longitude)にアクセス")

                Button {
                    if let myCoordinate = LocationManager.shared.lastKnownLocation?.coordinate {
                        delegate?.showRoute(source: myCoordinate, destination: coordinate)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }

                } label: {
                    VStack {
                        Text("ここへの経路を調べる")
                    }
                }
            }
            
            ForEach(polyline.items) { info in
                HStack {
                    Text(info.key)
                    Text(": ")
                    Text(info.value)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("エラー"),
                  message: Text("現在の座標を取得できませんでした。権限を確認してください"),
                  dismissButton: .default(Text("閉じる")))  // ボタンの変更
        }
    }
}

//struct MapPolyLinePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolyLinePreview()
//    }
//}
