import SwiftUI

protocol AddInfoViewDelegate {
    func addInfo(info: Item)
}

struct AddInfoView: View {
    @Environment(\.dismiss) var dismiss

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
                dismiss()
            }, label: {
                Text("保存")
            })

            Spacer()
        }
        .alert("タイトル", isPresented: $showingAlert) {
            Button("了解", role: .cancel) {}
        } message: {
            Text("キーが空です")
        }
    }
}

private struct PreviewWrapper: View, AddInfoViewDelegate {
    var body: some View {
        AddInfoView(delegate: self)
    }
    func addInfo(info: Item) {}
}

#Preview {
    PreviewWrapper()
}
