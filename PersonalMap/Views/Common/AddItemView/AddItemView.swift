import SwiftUI

struct AddItemView: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewState: AddItemViewState
    
    init(items: Binding<[Item]>) {
        _viewState = StateObject(wrappedValue: AddItemViewState(items: items))
    }
    
    var itemType: ItemType {
        if viewState.selection == 0 {
            return .text
        } else if viewState.selection == 1 {
            return .url
        } else if viewState.selection == 2 {
            return .image
        } else {
            return .pdf
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("項目の種類")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                Picker("", selection: $viewState.selection) {
                    Text("テキスト").tag(0)
                    Text("URL").tag(1)
                    Text("画像").tag(2)
                    Text("PDF").tag(3)
                }
                .pickerStyle(.segmented)
                
                Text("項目名")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                TextField("項目名を入力してください", text: $viewState.key)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("内容")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                if itemType == .text {
                    AddItemTextContent(value: $viewState.value)
                } else if itemType == .url {
                    AddItemUrlContent(value: $viewState.value)
                } else if itemType == .image {
                    AddItemImageContent(image: $viewState.image, showingSheet: $viewState.showingSheet)
                } else if itemType == .pdf {
                    AddItemPDFContent(pdfDocument: $viewState.pdfDocument, showingSheet: $viewState.showingSheet)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .navigationBarItems(
                trailing:
                    Button(action: {
                        if viewState.key.isEmpty {
                            viewState.alertMessage = "Keyを入力させてください"
                            viewState.showingAlert = true
                            return
                        }
                        
                        switch itemType {
                        case .text:
                            viewState.saveTextItem()
                        case .url:
                            viewState.saveUrlItem()
                        case .image:
                            viewState.saveImageItem()
                        case .pdf:
                            viewState.savePDFItem()
                        }
                    }, label: {
                        Text("登録")
                            .font(Font.system(size: 16).bold())
                    })
            )
            .alert(isPresented: $viewState.showingAlert)  {
                Alert(title: Text(""), message: Text(viewState.alertMessage), dismissButton: .default(Text("閉じる")))
            }
            .sheet(item: $viewState.showingSheet) { item in
                switch item {
                case .image:
                    ImagePicker(image: $viewState.image)
                case .pdf:
                    PDFPickerView(document: $viewState.pdfDocument)
                }
            }
            .onReceive(viewState.$dismiss, perform: { dismiss in
                if dismiss {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .navigationTitle("項目の追加")
        }
    }
}

//struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView(delegate: nil)
//    }
//}
