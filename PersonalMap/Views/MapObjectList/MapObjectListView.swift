import SwiftUI

struct MapObjectListView: View {
    @Binding var mapObjects: [MapObject]
    var body: some View {
        NavigationView {
            List(mapObjects) { mapObject in
                HStack {
                    Text(mapObject.value.isHidden ? "非表示中" : "表示中")
                    Text(mapObject.value.layerName)
                }
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
                        case let .line(line):
                            mapObjects.remove(at: index)
                            var newLine = line
                            newLine.isHidden.toggle()
                            mapObjects.insert(.line(newLine), at: index)
                        case .polygon(_):
                                break
                        }
                    }) {
                        Text(mapObject.value.isHidden ? "表示する" : "非表示にする")
                    }
                    
                    Button(action: {
                        
                    }) {
                        Text("レイヤ名変更")
                    }
                }
            }
            .navigationTitle("MapObject List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct PointListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PointListView()
//    }
//}
