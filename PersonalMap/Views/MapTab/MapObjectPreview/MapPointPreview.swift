import SwiftUI

struct MapPointPreview: View {
    let point: MapPoint
    var body: some View {
        VStack {
            Text(point.objectName)
            
            ForEach(point.items) { info in
                HStack {
                    Text(info.key)
                    Text(": ")
                    Text(info.value)
                }
            }
        }
    }
}

//struct MapPointPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPointPreview(point: <#MapPoint#>)
//    }
//}
