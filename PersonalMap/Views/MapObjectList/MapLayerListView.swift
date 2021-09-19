import SwiftUI

struct MapLayerListView: View {
    @State var mapLayers: [MapLayer] = []
    
    @State var showingSheet = false
    
    var body: some View {
        NavigationView {
            List(mapLayers) { (mapLayer: MapLayer) in
                NavigationLink(destination: Text("Hello")) {
                    VStack(alignment: .leading) {
                        Text(mapLayer.id.description)
                        Text(mapLayer.layerName)
                        Text(mapLayer.mapLayerType.rawValue)
                    }
                }
            }
            .onAppear {
                let mapLayers = try! FileRepository().getMapLyers()
                self.mapLayers = mapLayers
                print("onAppear")
            }
            .sheet(isPresented: $showingSheet, content: {
                AddMapLayerView()
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("List")
            .navigationBarItems(trailing: Button(action: {
                showingSheet = true
            }, label: {
                Text("Add")
            }))
        }
    }
}

struct LayerListView_Previews: PreviewProvider {
    static var previews: some View {
        MapLayerListView()
    }
}
