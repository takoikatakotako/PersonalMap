import SwiftUI

struct MapPolygonDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var polygon: MapPolygon
    @State var newKey: String = ""
    @State var newValue: String = ""
    
    let systemNamesArray: [[String]]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                TextField("Polygon名", text: $polygon.objectName)
                    .textFieldStyle(.roundedBorder)

                Image(systemName: polygon.imageName)
                    .frame(width: 40, height: 40)
                
                VStack {
                    ForEach(systemNamesArray, id: \.self) { systemNames in
                        HStack {
                            ForEach(systemNames, id: \.self) { imageName in
                                Button {
                                    polygon.imageName = imageName
                                } label: {
                                    Image(systemName: imageName)
                                }
                            }
                        }
                    }
                }
                
                Text("Info")
                ForEach(polygon.infos) { info in
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
                    polygon.infos.append(Info(id: UUID(), key: newKey, value: newValue))
                    newKey = ""
                    newValue = ""
                } label: {
                    Text("Info追加")
                }
                
                Button {
                                        
                    let fileRepository = FileRepository()
                    try! fileRepository.saveMapObject(mapObject: .polygon(polygon))
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("更新")
                }
            }
        }
    }
}

//struct MapPolygonDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolygonDetailView()
//    }
//}
