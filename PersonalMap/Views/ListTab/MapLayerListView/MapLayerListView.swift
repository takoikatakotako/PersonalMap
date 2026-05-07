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
                    viewState.sheetDismiss()
                }, content: {
                    AddMapLayerView()
                })
            .alert("エラー", isPresented: Binding(
                get: { viewState.errorMessage != nil },
                set: { if !$0 { viewState.errorMessage = nil } }
            )) {
                Button("閉じる", role: .cancel) { viewState.errorMessage = nil }
            } message: {
                if let message = viewState.errorMessage { Text(message) }
            }
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

#Preview {
    MapLayerListView()
}
