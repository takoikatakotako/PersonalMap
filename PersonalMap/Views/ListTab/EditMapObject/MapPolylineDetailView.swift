import SwiftUI

struct MapPolylineDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var polyline: MapPolyLine
    @State var newKey: String = ""
    @State var newValue: String = ""
        
    let systemNamesArray: [[String]]
    
    var body: some View {
        ScrollView {
            LazyVStack {
                TextField("PolyLine名", text: $polyline.objectName)
                    .textFieldStyle(.roundedBorder)

                Image(systemName: polyline.imageName)
                    .frame(width: 40, height: 40)
                
                VStack {
                    ForEach(systemNamesArray, id: \.self) { systemNames in
                        HStack {
                            ForEach(systemNames, id: \.self) { imageName in
                                Button {
                                    polyline.imageName = imageName
                                } label: {
                                    Image(systemName: imageName)
                                }
                            }
                        }
                    }
                }
                
                Text("Info")
                ForEach(polyline.items) { info in
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
                    polyline.items.append(Item(id: UUID(), itemType: .text, key: newKey, value: newValue))
                    newKey = ""
                    newValue = ""
                } label: {
                    Text("Info追加")
                }
                
                Button {
                                        
                    let fileRepository = FileRepository()
                    try! fileRepository.saveMapObject(mapObject: .polyLine(polyline))
                    
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("更新")
                }
            }
        }
    }
}

//struct MapPolylineDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolylineDetailView(polyline: <#MapPolyLine#>)
//    }
//}
