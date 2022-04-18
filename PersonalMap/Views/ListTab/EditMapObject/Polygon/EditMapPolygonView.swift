import SwiftUI

struct EditMapPolygonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject var viewState: EditMapPolygonViewState
    
    init(polygon: MapPolygon) {
        _viewState = StateObject(wrappedValue: EditMapPolygonViewState(polygon: polygon))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                MapObjectLabelTextField(labelName: $viewState.polygon.objectName)
                
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
        .navigationTitle("ポリゴンの編集")
    }
}

//struct MapPolygonDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapPolygonDetailView()
//    }
//}
