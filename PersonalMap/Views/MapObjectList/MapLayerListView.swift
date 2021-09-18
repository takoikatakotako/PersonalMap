import SwiftUI

struct MapLayerListView: View {
    @State var mapLayers: [MapLayer] = []
    
    @State var showingSheet = false
    
    var body: some View {
        NavigationView {
            List(mapLayers) { (mapLayer: MapLayer) in
                NavigationLink(destination: Text("Hello")) {
                    Text(mapLayer.layerName)
                }
            }
            .onAppear {
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
