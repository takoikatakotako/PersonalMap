import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Text("The First Tab")
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
            Text("Another Tab")
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("List")
                }
            Text("The Last Tab")
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
