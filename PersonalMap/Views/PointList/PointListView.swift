import SwiftUI

struct PointListView: View {
    @Binding var points: [Point]
    var body: some View {
        NavigationView {
            List(points) { point in
                HStack {
                    Text(point.isHidden ? "非表示中" : "表示中")
                    Text(point.layerName)
                }
                .contextMenu {
                    Button(action: {
                        guard let index = points.firstIndex(where: { $0.id == point.id}) else {
                            return
                        }
                        points[index].isHidden.toggle()
                    }) {
                        Text(point.isHidden ? "表示する" : "非表示にする")
                    }
                    
                    Button(action: {
                        
                    }) {
                        Text("レイヤ名変更")
                    }
                }
            }
        }
    }
}

//struct PointListView_Previews: PreviewProvider {
//    static var previews: some View {
//        PointListView()
//    }
//}
