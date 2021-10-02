import SwiftUI

struct MapLayerListView: View {
    @State var mapLayers: [MapLayer] = []
    @State var showingSheet = false
    
    var body: some View {
        NavigationView {
            List(mapLayers) { (mapLayer: MapLayer) in
                NavigationLink(destination: MapLayerDetail(mapLayer: mapLayer)) {
                    VStack(alignment: .leading) {
                        Text(mapLayer.layerName)
                        Text(mapLayer.mapLayerType.rawValue)
                    }
                }
            }
            .onAppear {
                let fileRepository = FileRepository()
                try! fileRepository.initialize()
                let mapLayers = try! fileRepository.getMapLyers()
                self.mapLayers = mapLayers
            }
            .sheet(
                isPresented: $showingSheet, onDismiss: {
                    let mapLayers = try! FileRepository().getMapLyers()
                    self.mapLayers = mapLayers
                }, content: {
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
