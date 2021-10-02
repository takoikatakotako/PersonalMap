import SwiftUI

struct MapObjectInfo: Identifiable {
    let id: UUID
    let key: String
    let value: String
}

struct MapPointDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var name: String = "鉄塔あ"
    
    @State var mapObjectInfos: [MapObjectInfo] = [
        MapObjectInfo(id: UUID(), key: "管理番号", value: "43"),
        MapObjectInfo(id: UUID(), key: "型番", value: "SET3"),
    ]
    @State var newKey: String = ""
    @State var newValue: String = ""
        
    var body: some View {
        ScrollView {
            LazyVStack {
                TextField("ピン名", text: $name)
                    .textFieldStyle(.roundedBorder)

                Text("Info")
                ForEach(mapObjectInfos) { mapObjectInfo in
                    HStack {
                        Text(mapObjectInfo.key)
                        Text(" : ")
                        Text(mapObjectInfo.value)
                    }
                }
                
                HStack {
                    TextField("Key", text: $newKey)
                        .textFieldStyle(.roundedBorder)
                    TextField("Value", text: $newValue)
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                
                Button {
                    mapObjectInfos.append(MapObjectInfo(id: UUID(), key: newKey, value: newValue))
                    newKey = ""
                    newValue = ""
                } label: {
                    Text("Info追加")
                }
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("更新")
                }
            }
        }
    }
}

struct MapPointDetail_Previews: PreviewProvider {
    static var previews: some View {
        MapPointDetail()
    }
}
