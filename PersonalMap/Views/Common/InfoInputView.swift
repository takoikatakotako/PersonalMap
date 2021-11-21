import SwiftUI

struct InfoInputView: View {
    @State private var itemType = 0
    @State private var key: String = ""
    @State private var value: String = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("項目の種類")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                Picker("What is your favorite color?", selection: $itemType) {
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
                
                if itemType == 0 {
                    TextField("バリューを入力してください", text: $value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else if itemType == 1 {
                    TextField("URLを入力してください", text: $value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else if itemType == 2 {
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
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("項目の追加")
            .navigationBarItems(
                trailing:
                Button(action: {
                }, label: {
                    Text("登録")
                        .font(Font.system(size: 16).bold())
                })
            )
        }
    }
}

struct InfoInputView_Previews: PreviewProvider {
    static var previews: some View {
        InfoInputView()
    }
}
