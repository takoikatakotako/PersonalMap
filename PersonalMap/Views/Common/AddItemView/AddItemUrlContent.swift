import SwiftUI

struct AddItemUrlContent: View {
    @Binding var value: String
    var body: some View {
        TextField("URLを入力してください", text: $value)
            .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

//struct AddItemUrlContent_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemUrlContent()
//    }
//}
