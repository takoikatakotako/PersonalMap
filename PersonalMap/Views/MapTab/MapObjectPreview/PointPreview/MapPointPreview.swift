import SwiftUI

struct MapPointPreview: View {
    let point: MapPoint
    let delegate: MapObjectPreviewViewDelegate?
    @Environment(\.presentationMode) var presentationMode
    @State var showingAlert = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("オブジェクト名")
                .font(Font.system(size: 20).bold())
                .padding(.top, 12)
            Text(point.objectName)
            
            
            HStack {
                VStack {
                    Text("緯度: \(point.coordinate.latitude)")
                    Text("経度: \(point.coordinate.longitude)")
                }
                Spacer()
                Button {
                    if let coordinate = LocationManager.shared.lastKnownLocation?.coordinate {
                        delegate?.showRoute(source: coordinate, destination: point.coordinate)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingAlert = true
                    }
                } label: {
                    Text("ここにアクセス")
                }
            }
            
            
            
            
            ForEach(point.items) { info in
                HStack {
                    Text(info.key)
                    Text(": ")
                    Text(info.value)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("エラー"),
                  message: Text("現在の座標を取得できませんでした。権限を確認してください"),
                  dismissButton: .default(Text("閉じる")))  // ボタンの変更
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("ポイント詳細")
    }
}

//struct MapPointPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPointPreview(point: <#MapPoint#>)
//    }
//}
