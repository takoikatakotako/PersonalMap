import SwiftUI

struct MapPolyLinePreview: View {
    let polyline: MapPolyLine
    var body: some View {
        VStack {
            Text(polyline.objectName)
            
            ForEach(polyline.items) { info in
                HStack {
                    Text(info.key)
                    Text(": ")
                    Text(info.value)
                }
            }
        }
    }
}

//struct MapPolyLinePreview_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolyLinePreview()
//    }
//}
