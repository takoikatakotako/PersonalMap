import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TopView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            MapLayerListView()
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("List")
                }
            ConfigView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Config")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
