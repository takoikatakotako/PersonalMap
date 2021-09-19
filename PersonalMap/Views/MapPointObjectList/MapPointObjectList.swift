import SwiftUI

struct MapPointObjectList: View {
    let mapLayerId: UUID
    let pointObjectIds: [UUID]

    @State var showingSheet = false
    var body: some View {
        List {
            Text("ここに追加されたポイントが入る")
        }
        .navigationBarItems(trailing: Button(action: {
            showingSheet = true
        }, label: {
            Text("追加")
        }))
        .sheet(isPresented: $showingSheet) {
            // on dissmiss
        } content: {
            AddMapPointObjectView(mapLayerId: mapLayerId)
        }
    }
}

struct MapPointObjectList_Previews: PreviewProvider {
    static var previews: some View {
        MapPointObjectList(mapLayerId: UUID(), pointObjectIds: [])
    }
}
