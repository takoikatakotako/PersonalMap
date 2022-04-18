import SwiftUI
import MapKit

struct AddMapPolylineView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @StateObject var viewState: AddMapPolylineViewState
    
    init(mapLayerId: UUID) {
        _viewState = StateObject(wrappedValue: AddMapPolylineViewState(mapLayerId: mapLayerId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    MapObjectLabelTextField(labelName: $viewState.labelName)
                    
                    MapObjectSymbolSelecter(symbolName: $viewState.symbolName)

                    MapObjectMultiLocationSelecter(coordinates: $viewState.coordinates)
                    
                    MapObjectItems(items: $viewState.items)
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
            .navigationTitle("ラインの新規登録")
        }
    }
}

struct AddMapPolylineObjectView_Previews: PreviewProvider {
    static var previews: some View {
        AddMapPolylineView(mapLayerId: UUID())
    }
}
