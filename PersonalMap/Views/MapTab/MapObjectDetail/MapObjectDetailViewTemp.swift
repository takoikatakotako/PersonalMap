import SwiftUI

struct MapObjectDetailViewTemp: View {
    let mapObjectId: UUID

    var body: some View {
        VStack {
            // Text(mapObjectId.description)
            Text("鉄塔１")
            
            HStack {
                Text("管理番号")
                Text(" : ")
                Text("43")
            }
            
            HStack {
                Text("型番")
                Text(" : ")
                Text("SET3")
            }
            
            HStack {
                Text("色")
                Text(" : ")
                Text("青色")
            }
        }
    }
}

//struct MapObjectDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapObjectDetailView(mapObjectId: UUID())
//    }
//}
