import SwiftUI

struct AddItemTextContent: View {
    @Binding var value: String
    var body: some View {
        TextField("テキストを入力してください", text: $value)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

//struct AddItemText_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemText()
//    }
//}
