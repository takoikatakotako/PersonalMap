import SwiftUI

struct EditMapPolylineView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewState: EditMapPolylineViewState
    
    init(polyLine: MapPolyLine) {
        _viewState = StateObject(wrappedValue: EditMapPolylineViewState(polyLine: polyLine))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                MapObjectLabelTextField(labelName: $viewState.polyline.objectName)
                
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
                    Text("登録")
                        .font(Font.system(size: 16).bold())
                })
        )
        .alert(isPresented: $viewState.showingAlert)  {
            Alert(title: Text(""), message: Text(viewState.message), dismissButton: .default(Text("閉じる")))
        }
        .onReceive(viewState.$dismiss, perform: { dismiss in
            if dismiss {
                presentationMode.wrappedValue.dismiss()
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
