import SwiftUI

struct AddMapLayerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State private var layerName: String = ""
    @State private var layerTypeIndex = 0
    
    private var layerType: MapObjectType {
        if layerTypeIndex == 0 {
            return .point
        } else if layerTypeIndex == 1 {
            return .polyLine
        } else {
            return .polygon
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("レイヤー名")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                TextField("レイヤー名を入力してください", text: $layerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Text("レイヤーの種類")
                    .font(Font.system(size: 20).bold())
                    .padding(.top, 12)
                
                Picker("", selection: $layerTypeIndex) {
                    Text("ポイント").tag(0)
                    Text("ライン").tag(1)
                    Text("エリア").tag(2)
                }
                .pickerStyle(.segmented)

                
                HStack {
                    Spacer()
                    Button {
                        let newMapLayer = MapLayer(id: UUID(), layerName: layerName, mapObjectType: layerType, objectIds: [])
                        
                        let fileRepository = FileRepository()
                        try! fileRepository.initialize()
                        try! fileRepository.saveMapLayer(mapLayer: newMapLayer)
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("追加")
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 64)
                            .padding(.vertical, 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                    }
                    Spacer()
                }
                .padding(.top, 12)
                
                Spacer()
            }
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
