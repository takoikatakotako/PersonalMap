import SwiftUI

protocol AddInfoViewDelegate {
    func addInfo(info: Item)
}

struct AddInfoView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    let delegate: AddInfoViewDelegate
    @State var key = ""
    @State var value = ""
    @State var showingAlert = false

    var body: some View {
        VStack {
            TextField("Key", text: $key)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Value", text: $value)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                if key.isEmpty {
                    showingAlert = true
                    return
                }
                delegate.addInfo(info: Item(itemType: .text, key: key, value: value))
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("保存")
            })
            
            Spacer()
        }
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("タイトル"),
                     message: Text("キーが空です"),
                     dismissButton: .default(Text("了解")))
        })
    }
}

struct AddInfoView_Previews: PreviewProvider {
    struct PreviewWrapper: View, AddInfoViewDelegate {
        var body: some View {
            AddInfoView(delegate: self)
        }
        func addInfo(info: Item) {}
    }
    
    static var previews: some View {
        PreviewWrapper()
    }
}
