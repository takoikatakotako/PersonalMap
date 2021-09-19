import SwiftUI

struct AddMapPointObjectView: View {
    let mapLayerId: UUID
    @State var objectName: String = ""
    @State var showingSheet = false
    @State var longitude: Double?
    @State var latitude: Double?
    
    var body: some View {
        VStack {
            Text("レイヤー名")
                .font(Font.system(size: 20).bold())
                .padding(.top, 16)
            TextField("オブジェクト名を入力してください", text: $objectName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button {
                showingSheet = true
            } label: {
                Text("位置情報を設定")
            }
            
            Text("緯度: \(longitude?.description ?? "???")")
            Text("軽度: \(longitude?.description ?? "???")")
            
            
            Button {
                // point を保存
                
                
                
            } label: {
                Text("ポイントを追加")
            }
        }
        .sheet(isPresented: $showingSheet) {
            // on dissmiss
        } content: {
            LocationSelecterView(delegate: self)
        }
    }
}

extension AddMapPointObjectView: LocationSelecterDelegate {
    func getLocation(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct AddMapPointObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapPointObjectView(mapLayerId: UUID())
    }
}
