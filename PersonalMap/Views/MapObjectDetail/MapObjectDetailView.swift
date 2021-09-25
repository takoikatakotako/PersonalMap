import SwiftUI

struct MapObjectDetailView: View {
    let mapObjectId: UUID

    var body: some View {
        VStack {
            Text(mapObjectId.description)
            Text("鉄塔１")
        }
    }
}

struct MapObjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MapObjectDetailView(mapObjectId: UUID())
    }
}
