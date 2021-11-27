import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var selection = 0
    @State private var key: String = ""
    @State private var value: String = ""
    
    @State private var image: UIImage?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingSheet = false

    @Binding var items: [Item]
    
    private let fileRepository = FileRepository()
    
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
                        if let image = image {
                            Image(uiImage: image)
                                .resizable()
                                .frame(width: 120, height: 120)
                        } else {
                            Text("No Image")
                                .foregroundColor(Color.white)
                                .font(Font.system(size:20).bold())
                                .frame(width: 120, height: 120)
                                .background(Color(UIColor.lightGray))
                        }
                        
                        Spacer()
                        Button {
                            showingSheet = true
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
                        alertMessage = "Keyを入力させてください"
                        showingAlert = true
                        return
                    }
                    
                    switch itemType {
                    case .text:
                        saveTextItem()
                    case .url:
                        saveUrlItem()
                    case .image:
                        saveImageItem()
                    }
                }, label: {
                    Text("登録")
                        .font(Font.system(size: 16).bold())
                })
            )
            .alert(isPresented: $showingAlert)  {
                Alert(title: Text(""), message: Text(alertMessage), dismissButton: .default(Text("閉じる")))
            }
            .sheet(isPresented: $showingSheet) {
                
            } content: {
                ImagePicker(image: $image)
            }
            .navigationTitle("項目の追加")
        }
    }
    
    private func saveTextItem() {
        if value.isEmpty {
            alertMessage = "Valueを入力させてください"
            showingAlert = true
            return
        }
        
        let item = Item(id: UUID(), itemType: .text, key: key, value: value)
        items.append(item)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveUrlItem() {
        if URL(string: value) == nil {
            alertMessage = "URLが正しくありません"
            showingAlert = true
            return
        }
        
        let item = Item(id: UUID(), itemType: .url, key: key, value: value)
        items.append(item)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    private func saveImageItem() {
        guard let image = image else {
            alertMessage = "画像が選択されていません"
            showingAlert = true
            return
        }

        guard let pngData = image.pngData() else {
            alertMessage = "画像の保存に失敗しました"
            showingAlert = true
            return
        }
        
        do {
            let fileName = UUID().description + ".png"
            try fileRepository.saveImageData(data: pngData, fileName: fileName)
            let item = Item(id: UUID(), itemType: .image, key: key, value: fileName)
            items.append(item)
            presentationMode.wrappedValue.dismiss()
        } catch {
            alertMessage = "画像の保存に失敗しました"
            showingAlert = true
        }
    }
}

//struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView(delegate: nil)
//    }
//}
