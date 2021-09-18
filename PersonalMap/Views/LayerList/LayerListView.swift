import SwiftUI

struct LayerListView: View {
    
    @State var mapObjects: [MapObject] = [
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "A", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "B", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "C", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "D", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "E", locations: [], infos: [])),
        MapObject.polyLine(MapPolyLine(isHidden: true, layerName: "F", locations: [], infos: [])),
    ]
    
    var body: some View {
        NavigationView {
            List(mapObjects) { (mapObject: MapObject) in
                NavigationLink(destination: Text("Hello")) {
                    Text(mapObject.objectName)
                }
            }
            .onAppear {
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("List")
            .navigationBarItems(trailing: NavigationLink("Add", destination: AddMapObjectView()))
        }
    }
}

struct LayerListView_Previews: PreviewProvider {
    static var previews: some View {
        LayerListView()
    }
}
