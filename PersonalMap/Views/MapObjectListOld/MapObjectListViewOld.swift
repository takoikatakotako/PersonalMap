import SwiftUI

struct MapObjectListViewOld: View {
    @Binding var mapObjects: [MapObject]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(mapObjects) { mapObject in
                    Text(mapObject.objectName)
                        .contextMenu {
                            Button(action: {
                                guard let index = mapObjects.firstIndex(where: { $0.id == mapObject.id}) else {
                                    return
                                }
                                switch mapObjects[index] {
                                case let .point(point):
                                    mapObjects.remove(at: index)
                                    var newPoint = point
                                    newPoint.isHidden.toggle()
                                    mapObjects.insert(.point(newPoint), at: index)
                                case let .polyLine(line):
                                    mapObjects.remove(at: index)
                                    var newLine = line
                                    newLine.isHidden.toggle()
                                    mapObjects.insert(.polyLine(newLine), at: index)
                                case .polygon(_):
                                    break
                                }
                            }) {
                                
                                Text("Todo")
                                // Text(mapObject.objectName ? "表示する" : "非表示にする")
                            }

                            Button(action: {

                            }) {
                                Text("レイヤ名変更")
                            }
                            
                            Button(action: {
                                guard let index = mapObjects.firstIndex(where: { $0.id == mapObject.id}) else {
                                    return
                                }
                                if index == 0 {
                                    return
                                }
                                
                                mapObjects.swapAt(index - 1, index)
                            }) {
                                Text("レイヤを一段上に")
                            }
                        }
                }
            }
            .navigationTitle("MapObject List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(mapObjects) { mapObject in
//                    HStack {
//                        Text(mapObject.value.isHidden ? "非表示中" : "表示中")
//                        Text(mapObject.value.layerName)
//                    }
//
//                }
//                .onMove { (indexSet, index) in
//                    self.mapObjects.move(fromOffsets: indexSet, toOffset: index)
//                }
//                .navigationBarItems(trailing: EditButton())
//            }
//            .navigationTitle("MapObject List")
//            .navigationBarTitleDisplayMode(.inline)
//        }
//    }
}

//struct PointListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PointListView()
//    }
//}
