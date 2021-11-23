import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var selection = 0
    @State private var key: String = ""
    @State private var value: String = ""
    
    @State private var showingAlert = false
    @State private var message = ""

    @Binding var items: [Item]
    
    var itemType: ItemType {
        if selection == 0 {
            return .text
        } else if selection == 1 {
            return .url
        } else {
            return .image
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("項目の種類")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                Picker("", selection: $selection) {
                    Text("テキスト").tag(0)
                    Text("URL").tag(1)
                    Text("画像").tag(2)
                }
                .pickerStyle(.segmented)
                
                Text("キー")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                TextField("キーを入力してください", text: $key)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("バリュー")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                if itemType == .text {
                    TextField("テキストを入力してください", text: $value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else if itemType == .url {
                    TextField("URLを入力してください", text: $value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else if itemType == .image {
                    HStack {
                        Image("icon")
                            .resizable()
                            .frame(width: 120, height: 120)
                        Spacer()
                        Button {
                        } label: {
                            Text("画像を設定")
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .navigationBarItems(
                trailing:
                Button(action: {
                    if key.isEmpty {
                        message = "Keyを入力させてください"
                        showingAlert = true
                        return
                    }
                    
                    if value.isEmpty {
                        message = "Valueを入力させてください"
                        showingAlert = true
                        return
                    }
                    
                    let item = Item(id: UUID(), itemType: .text, key: key, value: value)
                    items.append(item)
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("登録")
                        .font(Font.system(size: 16).bold())
                })
            )
            .alert(isPresented: $showingAlert)  {
                Alert(title: Text(""), message: Text(message), dismissButton: .default(Text("閉じる")))
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("項目の追加")
        }
    }
}

//struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView(delegate: nil)
//    }
//}
