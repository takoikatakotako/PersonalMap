import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            TopView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            LayerListView()
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
        .font(.headline)
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
