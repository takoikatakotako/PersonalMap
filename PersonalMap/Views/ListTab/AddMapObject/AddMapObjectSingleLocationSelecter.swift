import SwiftUI

struct AddMapObjectSingleLocationSelecter: View {
    @Binding var latitude: String
    @Binding var longitude: String
    @Binding var sheet: AddMapObjectSheet?
    
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
                    sheet = .location
                } label: {
                    Text("位置情報を設定")
                }
            }
        }
    }
}

//struct AddMapObjectSingleLocationSelecter_Previews: PreviewProvider {
//    static var previews: some View {
//        AddMapObjectSingleLocationSelecter()
//    }
//}
