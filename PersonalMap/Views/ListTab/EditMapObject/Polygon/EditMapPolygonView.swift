import SwiftUI

struct EditMapPolygonView: View {
    @Environment(\.dismiss) var dismiss

    @StateObject var viewState: EditMapPolygonViewState
    
    init(polygon: MapPolygon) {
        _viewState = StateObject(wrappedValue: EditMapPolygonViewState(polygon: polygon))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                MapObjectLabelTextField(labelName: $viewState.polygon.objectName)
                
                MapObjectHiddenSelecter(hidden: $viewState.polygon.isHidden)
                
                MapObjectSymbolSelecter(symbolName: $viewState.polygon.imageName)

                MapObjectMultiLocationSelecter(coordinates: $viewState.polygon.coordinates)
                
                MapObjectItems(items: $viewState.polygon.items)
            }
        }
        .navigationBarItems(
            trailing:
                Button(action: {
                    viewState.savePolygon()
                }, label: {
                    Text("更新")
                        .font(Font.system(size: 16).bold())
                })
        )
        .alert("", isPresented: $viewState.showingAlert) {
            Button("閉じる", role: .cancel) {}
        } message: {
            Text(viewState.message)
        }
        .onReceive(viewState.$dismiss, perform: { shouldDismiss in
            if shouldDismiss {
                dismiss()
            }
        })
        .padding(.horizontal, 16)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("ポリゴンの編集")
    }
}

//struct MapPolygonDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolygonDetailView()
//    }
//}
