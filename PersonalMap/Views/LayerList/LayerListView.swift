import SwiftUI

struct LayerListView: View {
    
    @State var mapObjects: [MapObject] = [
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "sss", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "sss", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "sss", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "sss", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "sss", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "sss", locations: [], infos: [])),
    ]
    
    var body: some View {
        NavigationView {
            List(mapObjects) { (mapObject: MapObject) in
                NavigationLink(destination: Text("Hello")) {
                    Text(mapObject.objectName)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("List")
            .navigationBarItems(trailing: NavigationLink("Add", destination: Text("Add")))
        }
    }
}

struct LayerListView_Previews: PreviewProvider {
    static var previews: some View {
        LayerListView()
    }
}
