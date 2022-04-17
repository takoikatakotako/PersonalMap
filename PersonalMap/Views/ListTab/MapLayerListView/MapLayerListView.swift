import SwiftUI

struct MapLayerListView: View {
    @ObservedObject var viewState: MapLayerListViewState = MapLayerListViewState()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewState.mapLayers) { (mapLayer: MapLayer) in
                    NavigationLink(destination: MapObjectListView(mapLayer: mapLayer)) {
                        VStack(alignment: .leading) {
                            Text(mapLayer.layerName)
                            Text(mapLayer.mapObjectType.name)
                        }
                    }
                }
                .onMove(perform: viewState.rowMove)
                .onDelete(perform: viewState.rowRemove)
            }
            .onAppear {
                viewState.onAppear()
            }
            .sheet(
                isPresented: $viewState.showingSheet, onDismiss: {
                    viewState.sheetDissmiss()
                }, content: {
                    AddMapLayerView()
                })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("レイヤーリスト")
            .navigationBarItems(
                trailing:
                    HStack {
                        EditButton()
                        
                        Button(action: {
                            viewState.plusTapped()
                        }, label: {
                            Image(systemName: "plus")
                        })
                    })
        }
    }
}

struct LayerListView_Previews: PreviewProvider {
    static var previews: some View {
        MapLayerListView()
    }
}
