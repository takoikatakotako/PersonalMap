import SwiftUI

struct MapPointPreview: View {
    let point: MapPoint
    let delegate: MapObjectPreviewViewDelegate?
    
    @State var showingAlert = false
    var body: some View {
        VStack {
            Text(point.objectName)
            
            Button {
                // showingAlert = true

                if let coordinate = LocationManager.shared.lastKnownLocation?.coordinate {
                    delegate?.showRoute(source: coordinate, destination: point.coordinate)
                } else {
                    showingAlert = true
                }
            } label: {
                Text("ここにアクセス")
            }

            
            
            ForEach(point.items) { info in
                HStack {
                    Text(info.key)
                    Text(": ")
                    Text(info.value)
                }
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("タイトル"),
                  message: Text("詳細メッセージです"),
                  dismissButton: .default(Text("了解")))  // ボタンの変更
        }
    }
}

//struct MapPointPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPointPreview(point: <#MapPoint#>)
//    }
//}
