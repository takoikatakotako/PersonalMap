import SwiftUI

struct EditMapPointView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewState: EditMapPointViewState
    
    init(point: MapPoint) {
        _viewState = StateObject(wrappedValue: EditMapPointViewState(point: point))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                MapObjectLabelTextField(labelName: $viewState.point.objectName)
                
                MapObjectHiddenSelecter(hidden: $viewState.point.isHidden)
                
                MapObjectSymbolSelecter(symbolName: $viewState.point.imageName)
                
                MapObjectSingleLocationSelecter(latitude: $viewState.latitudeString, longitude: $viewState.longnitudeString)
                
                MapObjectItems(items: $viewState.point.items)
            }
        }
        .toolbar {
            Button("更新") {
                viewState.update()
            }
        }
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
        .navigationTitle("ポイントの編集")
    }
}

//struct MapPointDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPointDetail(point: MapPoint())
//    }
//}
