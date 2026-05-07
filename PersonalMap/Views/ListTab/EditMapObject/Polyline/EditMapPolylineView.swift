import SwiftUI

struct EditMapPolylineView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewState: EditMapPolylineViewState
    
    init(polyLine: MapPolyline) {
        _viewState = StateObject(wrappedValue: EditMapPolylineViewState(polyLine: polyLine))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                MapObjectLabelTextField(labelName: $viewState.polyline.objectName)
                
                MapObjectHiddenSelecter(hidden: $viewState.polyline.isHidden)
                
                MapObjectSymbolSelecter(symbolName: $viewState.polyline.imageName)
                
                MapObjectMultiLocationSelecter(coordinates: $viewState.polyline.coordinates)
                
                MapObjectItems(items: $viewState.polyline.items)
            }
        }
        .navigationBarItems(
            trailing:
                Button(action: {
                    viewState.savePolyline()
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
        .navigationTitle("ラインの編集")
    }
}

//struct MapPolylineDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolylineDetailView(polyline: <#MapPolyLine#>)
//    }
//}
