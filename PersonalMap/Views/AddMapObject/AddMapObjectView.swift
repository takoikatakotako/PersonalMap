import SwiftUI

struct AddMapObjectView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AddPointObjectView()) {
                    Text("ポイント")
                        .font(Font.system(size: 20))
                }
                
                NavigationLink(destination: AddPolyLineObjectView()) {
                    Text("ポリライン")
                        .font(Font.system(size: 20))
                }
                
                NavigationLink(destination: AddPolygonObjectView()) {
                    Text("ポリゴン")
                        .font(Font.system(size: 20))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Map Object")
        }
    }
}

struct AddMapObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapObjectView()
    }
}
