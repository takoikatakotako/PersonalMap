import SwiftUI

struct EditMapPointDetailView: View {
    // @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var viewState: EditMapPointDetailViewState
    
    init(point: MapPoint) {
        viewState = EditMapPointDetailViewState(point: point)
    }
    
//
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                MapObjectLabelTextField(labelName: $viewState.point.objectName)
                
                MapObjectSymbolSelecter(symbolName: $viewState.point.imageName)
                
                // MapObjectSingleLocationSelecter(latitude: $viewState.point.coordinate.longitude, longitude: $viewState.point.coordinate.longitude)
                
                // AddMapObjectItems(items: items, sheet: $sheet)
            }
        }
        .sheet(item: $viewState.sheet, onDismiss: {
            
        }, content: { item in
            Text("未実装")
        })
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("ポイントの編集")
        
//        ScrollView {
//            LazyVStack {
//                TextField("ピン名", text: $point.objectName)
//                    .textFieldStyle(.roundedBorder)
//
//
//                Image(systemName: point.imageName)
//                    .frame(width: 40, height: 40)
//
//                VStack {
//                    ForEach(systemNamesArray, id: \.self) { systemNames in
//                        HStack {
//                            ForEach(systemNames, id: \.self) { imageName in
//                                Button {
//                                    point.imageName = imageName
//                                } label: {
//                                    Image(systemName: imageName)
//                                }
//                            }
//                        }
//                    }
//                }
//
//
//                Text("Info")
//                ForEach(point.items) { info in
//                    HStack {
//                        Text(info.key)
//                        Text(" : ")
//                        Text(info.value)
//                    }
//                }
//
//                HStack {
//                    TextField("Key", text: $newKey)
//                        .textFieldStyle(.roundedBorder)
//                    TextField("Value", text: $newValue)
//                        .textFieldStyle(.roundedBorder)
//                }
//                .padding()
//
//                Button {
//                    point.items.append(Item(id: UUID(), itemType: .text, key: newKey, value: newValue))
//                    newKey = ""
//                    newValue = ""
//                } label: {
//                    Text("Info追加")
//                }
//
//                Button {
//
//                    print(point.id)
//
//                    let fileRepository = FileRepository()
//                    try! fileRepository.saveMapObject(mapObject: .point(point))
//
//                    presentationMode.wrappedValue.dismiss()
//                } label: {
//                    Text("更新")
//                }
//            }
//        }
    }
}

//struct MapPointDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPointDetail(point: <#T##MapPoint#>)
//    }
//}
