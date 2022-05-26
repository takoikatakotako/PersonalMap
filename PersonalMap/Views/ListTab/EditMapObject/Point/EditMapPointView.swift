import SwiftUI

struct EditMapPointView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
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
        .alert(isPresented: $viewState.showingAlert) {
            Alert(
                title: Text(""),
                message: Text(viewState.message),
                dismissButton: .default(Text("閉じる"))
            )
        }
        .onReceive(viewState.$dismiss, perform: { dismiss in
            if dismiss {
                presentationMode.wrappedValue.dismiss()
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
