import SwiftUI

struct MapPointPreview: View {
    let point: MapPoint
    let delegate: MapObjectPreviewDelegate?
    var body: some View {
        VStack {
            Text(point.objectName)
            


            
            Button {
                delegate?.xxx()
            } label: {
                Text("ここにアクセス")
            }

            
            
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
