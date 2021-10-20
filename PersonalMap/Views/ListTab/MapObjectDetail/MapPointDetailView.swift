import SwiftUI

struct MapPointDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var point: MapPoint

    @State var newKey: String = ""
    @State var newValue: String = ""
    
    
    let systemNamesArray: [[String]]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                TextField("ピン名", text: $point.objectName)
                    .textFieldStyle(.roundedBorder)
                
                
                Image(systemName: point.imageName)
                    .frame(width: 40, height: 40)
                
                VStack {
                    ForEach(systemNamesArray, id: \.self) { systemNames in
                        HStack {
                            ForEach(systemNames, id: \.self) { imageName in
                                Button {
                                    point.imageName = imageName
                                } label: {
                                    Image(systemName: imageName)
                                }
                            }
                        }
                    }
                }
                

                Text("Info")
                ForEach(point.infos) { info in
                    HStack {
                        Text(info.key)
                        Text(" : ")
                        Text(info.value)
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
                    point.infos.append(Info(id: UUID(), key: newKey, value: newValue))
                    newKey = ""
                    newValue = ""
                } label: {
                    Text("Info追加")
                }
                
                Button {
                    
                    print(point.id)
                    
                    let fileRepository = FileRepository()
                    try! fileRepository.saveMapObject(mapObject: .point(point))
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("更新")
                }
            }
        }
    }
}

//struct MapPointDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPointDetail(point: <#T##MapPoint#>)
//    }
//}
