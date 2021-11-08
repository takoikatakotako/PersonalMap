import SwiftUI

struct MapLayerListView: View {
    @State private var mapLayers: [MapLayer] = []
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            List(mapLayers) { (mapLayer: MapLayer) in
                NavigationLink(destination: MapLayerDetail(mapLayerId: mapLayer.id)) {
                    VStack(alignment: .leading) {
                        Text(mapLayer.layerName)
                        Text(mapLayer.mapObjectType.name)
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
            .navigationTitle("レイヤーリスト")
            .navigationBarItems(trailing: Button(action: {
                showingSheet = true
            }, label: {
                Text("登録")
            }))
        }
    }
}

struct LayerListView_Previews: PreviewProvider {
    static var previews: some View {
        MapLayerListView()
    }
}
