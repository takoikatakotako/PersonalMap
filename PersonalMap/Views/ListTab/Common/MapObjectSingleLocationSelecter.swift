import SwiftUI

struct MapObjectSingleLocationSelecter: View {
    @Binding var latitude: String
    @Binding var longitude: String
    @State private var showingSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("位置情報を選択")
                .font(Font.system(size: 20).bold())
                .padding(.top, 12)
            
            TextField("緯度を入力してください", text: $latitude)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("経度を入力してください", text: $longitude)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            HStack {
                Spacer()
                Button {
                    showingSheet = true
                } label: {
                    Text("位置情報を設定")
                }
            }
        }.sheet(isPresented: $showingSheet) {
            SingleLocationSelecter(latitudeString: $latitude, longitudeString: $longitude)
        }
    }
}

//struct AddMapObjectSingleLocationSelecter_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMapObjectSingleLocationSelecter()
//    }
//}
