import SwiftUI

struct AddMapLayerView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewState = AddMapLayerViewState()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("レイヤー名")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                TextField("レイヤー名を入力してください", text: $viewState.layerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("レイヤーの種類")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                Picker("", selection: $viewState.layerTypeIndex) {
                    Text("ポイント").tag(0)
                    Text("ライン").tag(1)
                    Text("エリア").tag(2)
                }
                .pickerStyle(.segmented)

                HStack {
                    Spacer()
                    Button {
                        viewState.save()
                    } label: {
                        Text("追加")
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 64)
                            .padding(.vertical, 12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    Spacer()
                }
                .padding(.top, 12)
                
                Spacer()
            }
            .onReceive(viewState.$dismiss, perform: { shouldDismiss in
                if shouldDismiss {
                    dismiss()
                }
            })
            .alert("エラー", isPresented: Binding(
                get: { viewState.errorMessage != nil },
                set: { if !$0 { viewState.errorMessage = nil } }
            )) {
                Button("閉じる", role: .cancel) { viewState.errorMessage = nil }
            } message: {
                if let message = viewState.errorMessage { Text(message) }
            }
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("レイヤーの新規登録")
        }
    }
}

#Preview {
    AddMapLayerView()
}
