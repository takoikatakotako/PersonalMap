import SwiftUI

struct MapObjectLabelTextField: View {
    @Binding var labelName: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("ラベル名")
                .font(Font.system(size: 20).bold())
                .padding(.top, 12)
            
            TextField("ラベル名を入力してください", text: $labelName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}
