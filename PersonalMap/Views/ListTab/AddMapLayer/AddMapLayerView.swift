import SwiftUI

struct AddMapLayerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
                        presentationMode.wrappedValue.dismiss()
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
            .onReceive(viewState.$dismiss, perform: { dismiss in
                if dismiss {
                    presentationMode.wrappedValue.dismiss()
                }
            })
            .padding(.horizontal, 16)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("レイヤーの新規登録")
        }
    }
}

struct AddMapObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapLayerView()
    }
}
